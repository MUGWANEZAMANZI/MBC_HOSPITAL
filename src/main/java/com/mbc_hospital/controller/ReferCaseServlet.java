package com.mbc_hospital.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.mbc_hospital.model.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/refer-case")
public class ReferCaseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Extract parameters
        String patientIdStr = request.getParameter("id");
        Integer nurseId = null;
        
        // Get nurse ID from session
        if (request.getSession().getAttribute("id") != null) {
            try {
                nurseId = (Integer) request.getSession().getAttribute("id");
            } catch (ClassCastException e) {
                e.printStackTrace();
            }
        }
        
        System.out.println("Referring case for patient ID: " + patientIdStr + ", Nurse ID: " + nurseId);
        
        // Validate parameters
        if (patientIdStr == null || nurseId == null) {
            request.getSession().setAttribute("error", "Missing patient ID or nurse ID");
            response.sendRedirect("nurse-action-cases");
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdStr);
            
            try (Connection conn = DBConnection.getConnection()) {
                // Check if a diagnosis entry already exists for this patient
                String checkSql = "SELECT DiagnosisID FROM Diagnosis WHERE PatientID = ?";
                boolean diagnosisExists = false;
                int diagnosisId = 0;
                
                try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                    checkStmt.setInt(1, patientId);
                    ResultSet rs = checkStmt.executeQuery();
                    
                    if (rs.next()) {
                        diagnosisExists = true;
                        diagnosisId = rs.getInt("DiagnosisID");
                        System.out.println("Existing diagnosis found with ID: " + diagnosisId);
                    }
                }
                
                if (diagnosisExists) {
                    // Update existing diagnosis
                    String updateSql = "UPDATE Diagnosis SET " +
                                      "NurseID = ?, " +
                                      "DiagnoStatus = 'Referrable', " +
                                      "DiagnosisDate = NOW() " +
                                      "WHERE DiagnosisID = ?";
                    
                    try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                        updateStmt.setInt(1, nurseId);
                        updateStmt.setInt(2, diagnosisId);
                        int rowsUpdated = updateStmt.executeUpdate();
                        System.out.println("Updated existing diagnosis, rows affected: " + rowsUpdated);
                    }
                } else {
                    // Insert new diagnosis with referrable status
                    String insertSql = "INSERT INTO Diagnosis " +
                                      "(PatientID, NurseID, DiagnoStatus, DiagnosisDate) " +
                                      "VALUES (?, ?, 'Referrable', NOW())";
                    
                    try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                        insertStmt.setInt(1, patientId);
                        insertStmt.setInt(2, nurseId);
                        int rowsInserted = insertStmt.executeUpdate();
                        System.out.println("Inserted new diagnosis, rows affected: " + rowsInserted);
                    }
                }
                
                // Set success message and redirect
                request.getSession().setAttribute("message", "Case successfully referred to doctor");
                response.sendRedirect("nurse-referred-cases");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Invalid patient ID");
            response.sendRedirect("nurse-action-cases");
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Database error: " + e.getMessage());
            response.sendRedirect("nurse-action-cases");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            response.sendRedirect("nurse-action-cases");
        }
    }
} 