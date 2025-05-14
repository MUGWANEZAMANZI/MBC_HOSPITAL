package com.mbc_hospital.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/nurse-action-cases")
public class NurseActionCasesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("NurseActionCasesServlet: doGet method called");
        
        // Set cache control headers to prevent caching
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        List<Patient> actionRequiredCases = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                System.err.println("ERROR: Database connection is null!");
                request.setAttribute("error", "Failed to connect to database");
                request.setAttribute("actionRequiredCases", actionRequiredCases);
                request.getRequestDispatcher("nurse_action_cases.jsp").forward(request, response);
                return;
            }
            
            System.out.println("Database connection established successfully");
            
            // Simplified query without using RegistrationDate formatting
            String sql = "SELECT p.*, d.DiagnosisID, d.DiagnoStatus, d.Result " +
                         "FROM Patients p " +
                         "INNER JOIN Diagnosis d ON p.PatientID = d.PatientID " +
                         "WHERE UPPER(d.DiagnoStatus) = UPPER('Action Required')";
            
            System.out.println("Executing SQL: " + sql); // Debug log
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                try (ResultSet rs = ps.executeQuery()) {
                    System.out.println("Query executed successfully");
                    
                    while (rs.next()) {
                        Patient patient = new Patient();
                        int patientId = rs.getInt("PatientID");
                        String firstName = rs.getString("FirstName");
                        String lastName = rs.getString("LastName");
                        String diagnosisStatus = rs.getString("DiagnoStatus");
                        
                        System.out.println("Found patient: ID=" + patientId + ", Name=" + firstName + " " + lastName + 
                                          ", Diagnosis Status: '" + diagnosisStatus + "'");
                        
                        patient.setPatientID(patientId);
                        patient.setFirstName(firstName);
                        patient.setLastName(lastName);
                        patient.setAddress(rs.getString("Address"));
                        patient.setTelephone(rs.getString("Telephone"));
                        patient.setEmail(rs.getString("Email"));
                        
                        // Set registration date without formatting
                        try {
                            if (rs.getTimestamp("RegistrationDate") != null) {
                                patient.setRegistrationDate(rs.getTimestamp("RegistrationDate").toString());
                            } else {
                                patient.setRegistrationDate("N/A");
                            }
                        } catch (SQLException e) {
                            System.out.println("RegistrationDate column might not exist: " + e.getMessage());
                            patient.setRegistrationDate("N/A");
                        }
                        
                        patient.setDiagnosisID(rs.getInt("DiagnosisID"));
                        patient.setDiagnosisStatus(rs.getString("DiagnoStatus"));
                        patient.setDiagnosisResult(rs.getString("Result"));
                        
                        actionRequiredCases.add(patient);
                        System.out.println("Added patient: ID=" + patientId + ", Name=" + firstName + " " + lastName + 
                                           ", Diagnosis Status: " + patient.getDiagnosisStatus()); // Debug log
                    }
                }
            }
            
            System.out.println("Total action required cases found: " + actionRequiredCases.size());
            
        } catch (SQLException e) {
            System.err.println("SQL Exception in NurseActionCasesServlet: " + e.getMessage());
            e.printStackTrace();
            // Log the error or add it to request attributes
            request.setAttribute("error", "Failed to retrieve cases requiring action: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("General Exception in NurseActionCasesServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Unexpected error: " + e.getMessage());
        }
        
        System.out.println("Setting actionRequiredCases attribute with " + actionRequiredCases.size() + " cases");
        request.setAttribute("actionRequiredCases", actionRequiredCases);
        request.getRequestDispatcher("nurse_action_cases.jsp").forward(request, response);
    }
} 