package com.mbc;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Patient;

@WebServlet("/patients")
public class PatientResultsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Session validation
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String userType = (String) session.getAttribute("usertype");
        if (userType == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Get patients list with their diagnoses
            List<Map<String, Object>> patientsWithDiagnoses = new ArrayList<>();
            
            // Query to get patients and their diagnoses
            String query = "SELECT p.PatientID, p.FirstName, p.LastName, p.Email, p.Telephone, " +
                           "d.DiagnosisID, d.DiagnoStatus, d.Result, d.MedicationsPrescribed, " +
                           "d.DiagnosisDate, d.NurseAssessment, " +
                           "n.Username AS NurseName, dr.Username AS DoctorName " +
                           "FROM Patients p " +
                           "LEFT JOIN Diagnosis d ON p.PatientID = d.PatientID " +
                           "LEFT JOIN Users n ON d.NurseID = n.UserID " +
                           "LEFT JOIN Users dr ON d.DoctorID = dr.UserID " +
                           "ORDER BY p.PatientID, d.DiagnosisDate DESC";
            
            try (PreparedStatement stmt = conn.prepareStatement(query);
                 ResultSet rs = stmt.executeQuery()) {
                
                Map<Integer, Map<String, Object>> patientMap = new HashMap<>();
                
                while (rs.next()) {
                    int patientId = rs.getInt("PatientID");
                    
                    // Create or get the patient entry
                    Map<String, Object> patient = patientMap.get(patientId);
                    if (patient == null) {
                        patient = new HashMap<>();
                        patient.put("patientId", patientId);
                        patient.put("firstName", rs.getString("FirstName"));
                        patient.put("lastName", rs.getString("LastName"));
                        patient.put("email", rs.getString("Email"));
                        patient.put("telephone", rs.getString("Telephone"));
                        patient.put("diagnoses", new ArrayList<Map<String, Object>>());
                        
                        patientMap.put(patientId, patient);
                        patientsWithDiagnoses.add(patient);
                    }
                    
                    // If there's a diagnosis entry, add it
                    if (rs.getObject("DiagnosisID") != null) {
                        Map<String, Object> diagnosis = new HashMap<>();
                        diagnosis.put("diagnosisId", rs.getInt("DiagnosisID"));
                        diagnosis.put("status", rs.getString("DiagnoStatus"));
                        diagnosis.put("result", rs.getString("Result"));
                        diagnosis.put("medications", rs.getString("MedicationsPrescribed"));
                        diagnosis.put("date", rs.getTimestamp("DiagnosisDate"));
                        diagnosis.put("nurseAssessment", rs.getString("NurseAssessment"));
                        diagnosis.put("nurseName", rs.getString("NurseName"));
                        diagnosis.put("doctorName", rs.getString("DoctorName"));
                        
                        // Add the diagnosis to the patient's diagnoses list
                        @SuppressWarnings("unchecked")
                        List<Map<String, Object>> diagnoses = (List<Map<String, Object>>) patient.get("diagnoses");
                        diagnoses.add(diagnosis);
                    }
                }
            }
            
            // Set the patients with diagnoses as a request attribute
            request.setAttribute("patientsWithDiagnoses", patientsWithDiagnoses);
            
            // Forward to the JSP
            request.getRequestDispatcher("/patient_results.jsp").forward(request, response);
            
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