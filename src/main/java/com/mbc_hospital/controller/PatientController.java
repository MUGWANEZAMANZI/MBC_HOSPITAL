package com.mbc_hospital.controller;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Patient;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/patients-list")
public class PatientController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("🚀 PatientController: doGet triggered...");
        
        // Get session and user info
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String userType = (String) session.getAttribute("usertype");
        int userId = (Integer) session.getAttribute("id");
        
        System.out.println("User type: " + userType);
        System.out.println("User ID: " + userId);
        
        // Check if we're viewing a specific patient's diagnoses
        String action = request.getParameter("action");
        String patientIdStr = request.getParameter("id");
        
        if ("view".equals(action) && patientIdStr != null && !patientIdStr.isEmpty()) {
            try {
                int patientId = Integer.parseInt(patientIdStr);
                viewPatientDiagnoses(request, response, patientId);
                return;
            } catch (NumberFormatException e) {
                System.out.println("Invalid patient ID: " + patientIdStr);
            }
        }
        
        // Default behavior - show all patients
        ArrayList<Patient> patients = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql;
            
            // Different SQL query based on user role
            if ("Nurse".equalsIgnoreCase(userType)) {
                // Nurses should only see patients they registered
                sql = "SELECT p.PatientID, p.FirstName AS PatientFirstName, p.LastName AS PatientLastName, " +
                      "p.Telephone, p.Email, p.Address, p.PImageLink, p.RegisteredBy, " +
                      "u.Username AS RegisteredByUsername " +
                      "FROM Patients p " +
                      "JOIN Users u ON p.RegisteredBy = u.UserID " +
                      "WHERE p.RegisteredBy = ?";
                
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, userId);
            } else if ("Doctor".equalsIgnoreCase(userType)) {
                // Doctors should see patients from their hospital (simplified version)
                sql = "SELECT p.PatientID, p.FirstName AS PatientFirstName, p.LastName AS PatientLastName, " +
                      "p.Telephone, p.Email, p.Address, p.PImageLink, p.RegisteredBy, " +
                      "u.Username AS RegisteredByUsername " +
                      "FROM Patients p " +
                      "JOIN Users u ON p.RegisteredBy = u.UserID " +
                      "JOIN Nurses n ON u.UserID = n.NurseId " +
                      "JOIN Doctors d ON d.DoctorId = ? " +
                      "WHERE n.HealthCenter = d.HospitalName";
                
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, userId);
            } else {
                // Admin or other users see all patients
                sql = "SELECT p.PatientID, p.FirstName AS PatientFirstName, p.LastName AS PatientLastName, " +
                      "p.Telephone, p.Email, p.Address, p.PImageLink, p.RegisteredBy, " +
                      "u.Username AS RegisteredByUsername " +
                      "FROM Patients p " +
                      "JOIN Users u ON p.RegisteredBy = u.UserID " +
                      "WHERE u.UserType = 'Nurse'";
                
                stmt = conn.prepareStatement(sql);
            }

            rs = stmt.executeQuery();

            while (rs.next()) {
                Patient patient = new Patient();
                patient.setPatientID(rs.getInt("PatientID"));
                patient.setFirstName(rs.getString("PatientFirstName"));
                patient.setLastName(rs.getString("PatientLastName"));
                patient.setTelephone(rs.getString("Telephone"));
                patient.setEmail(rs.getString("Email"));
                patient.setAddress(rs.getString("Address"));
                patient.setImageLink(rs.getString("PImageLink"));
                patient.setRegisteredBy(rs.getInt("RegisteredBy"));

                String username = rs.getString("RegisteredByUsername");
                patient.setRegisteredByName(username);

                patients.add(patient);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        System.out.println("Found " + patients.size() + " patients");
        request.setAttribute("patients", patients);
        RequestDispatcher dispatcher = request.getRequestDispatcher("Patients.jsp");
        dispatcher.forward(request, response);
    }
    
    // Function to handle viewing a patient's diagnoses
    private void viewPatientDiagnoses(HttpServletRequest request, HttpServletResponse response, int patientId) 
            throws ServletException, IOException {
        
        Patient patient = null;
        List<Map<String, Object>> diagnoses = new ArrayList<>();
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Step 1: Get patient details
            String patientQuery = "SELECT p.PatientID, p.FirstName, p.LastName, p.Telephone, p.Email, p.Address, " +
                                 "u.Username AS RegisteredByUsername " +
                                 "FROM Patients p " +
                                 "JOIN Users u ON p.RegisteredBy = u.UserID " +
                                 "WHERE p.PatientID = ?";
                                 
            try (PreparedStatement stmt = conn.prepareStatement(patientQuery)) {
                stmt.setInt(1, patientId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        patient = new Patient();
                        patient.setPatientID(rs.getInt("PatientID"));
                        patient.setFirstName(rs.getString("FirstName"));
                        patient.setLastName(rs.getString("LastName"));
                        patient.setTelephone(rs.getString("Telephone"));
                        patient.setEmail(rs.getString("Email"));
                        patient.setAddress(rs.getString("Address"));
                        patient.setRegisteredByName(rs.getString("RegisteredByUsername"));
                    }
                }
            }
            
            // Step 2: Get patient's diagnoses
            if (patient != null) {
                String diagnosisQuery = "SELECT d.DiagnosisID, d.DiagnoStatus, d.Result, d.MedicationsPrescribed, " +
                                       "d.DiagnosisDate, d.NurseAssessment, " +
                                       "n.Username AS NurseName, dr.Username AS DoctorName " +
                                       "FROM Diagnosis d " +
                                       "LEFT JOIN Users n ON d.NurseID = n.UserID " +
                                       "LEFT JOIN Users dr ON d.DoctorID = dr.UserID " +
                                       "WHERE d.PatientID = ? " +
                                       "ORDER BY d.DiagnosisDate DESC";
                
                try (PreparedStatement stmt = conn.prepareStatement(diagnosisQuery)) {
                    stmt.setInt(1, patientId);
                    try (ResultSet rs = stmt.executeQuery()) {
                        while (rs.next()) {
                            Map<String, Object> diagnosis = new HashMap<>();
                            diagnosis.put("diagnosisId", rs.getInt("DiagnosisID"));
                            diagnosis.put("status", rs.getString("DiagnoStatus"));
                            diagnosis.put("result", rs.getString("Result"));
                            diagnosis.put("medications", rs.getString("MedicationsPrescribed"));
                            diagnosis.put("date", rs.getTimestamp("DiagnosisDate"));
                            diagnosis.put("nurseAssessment", rs.getString("NurseAssessment"));
                            diagnosis.put("nurseName", rs.getString("NurseName"));
                            diagnosis.put("doctorName", rs.getString("DoctorName"));
                            
                            diagnoses.add(diagnosis);
                        }
                    }
                }
            }
            
            // Forward to the patient details page
            request.setAttribute("patient", patient);
            request.setAttribute("patientDiagnoses", diagnoses);
            
            // Forward to patient_diagnoses.jsp (using the same layout as patient_results.jsp for consistency)
            RequestDispatcher dispatcher = request.getRequestDispatcher("patient_diagnoses.jsp");
            dispatcher.forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred: " + e.getMessage());
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
