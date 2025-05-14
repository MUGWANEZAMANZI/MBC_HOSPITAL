package com.mbc_hospital.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.mbc_hospital.model.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/submitDiagnosis")
public class SubmitDiagnosisServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Extract parameters from request
        String patientIDStr = request.getParameter("patientID");
        String nurseIDStr = request.getParameter("nurseID");
        String diagnosisStatus = request.getParameter("diagnosisStatus");
        String result = request.getParameter("result");
        String medicationsPrescribed = request.getParameter("medicationsPrescribed");
        String nurseAssessment = request.getParameter("nurseAssessment");
        
        System.out.println("SubmitDiagnosisServlet - Received parameters:");
        System.out.println("patientID: " + patientIDStr);
        System.out.println("nurseID: " + nurseIDStr);
        System.out.println("diagnosisStatus: " + diagnosisStatus);
        System.out.println("result: " + result);
        
        // Set response type
        response.setContentType("text/plain");
        
        // Validation
        if (patientIDStr == null || nurseIDStr == null || diagnosisStatus == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Missing required parameters");
            return;
        }
        
        try {
            int patientID = Integer.parseInt(patientIDStr);
            int nurseID = Integer.parseInt(nurseIDStr);
            
            // Set up database connection
            try (Connection conn = DBConnection.getConnection()) {
                // Check if a diagnosis entry already exists for this patient
                String checkSql = "SELECT DiagnosisID FROM Diagnosis WHERE PatientID = ?";
                try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                    checkStmt.setInt(1, patientID);
                    var rs = checkStmt.executeQuery();
                    
                    if (rs.next()) {
                        // Update existing diagnosis
                        int diagnosisId = rs.getInt("DiagnosisID");
                        System.out.println("Updating existing diagnosis ID: " + diagnosisId);
                        
                        String updateSql = "UPDATE Diagnosis SET " +
                                          "NurseID = ?, " +
                                          "DiagnoStatus = ?, " +
                                          "Result = ?, " +
                                          "MedicationsPrescribed = ?, " +
                                          "NurseAssessment = ?, " +
                                          "DiagnosisDate = NOW() " +
                                          "WHERE DiagnosisID = ?";
                        
                        try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                            updateStmt.setInt(1, nurseID);
                            updateStmt.setString(2, diagnosisStatus);
                            updateStmt.setString(3, result);
                            updateStmt.setString(4, medicationsPrescribed);
                            updateStmt.setString(5, nurseAssessment);
                            updateStmt.setInt(6, diagnosisId);
                            
                            int rowsUpdated = updateStmt.executeUpdate();
                            System.out.println("Diagnosis updated, rows affected: " + rowsUpdated);
                            System.out.println("Updated diagnosis status to: " + diagnosisStatus + " for patient ID: " + patientID);
                            
                            response.getWriter().write("Diagnosis updated successfully");
                        }
                    } else {
                        // Insert new diagnosis
                        System.out.println("Creating new diagnosis record");
                        
                        String insertSql = "INSERT INTO Diagnosis " +
                                          "(PatientID, NurseID, DiagnoStatus, Result, MedicationsPrescribed, NurseAssessment, DiagnosisDate) " +
                                          "VALUES (?, ?, ?, ?, ?, ?, NOW())";
                        
                        try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                            insertStmt.setInt(1, patientID);
                            insertStmt.setInt(2, nurseID);
                            insertStmt.setString(3, diagnosisStatus);
                            insertStmt.setString(4, result);
                            insertStmt.setString(5, medicationsPrescribed);
                            insertStmt.setString(6, nurseAssessment);
                            
                            int rowsInserted = insertStmt.executeUpdate();
                            System.out.println("New diagnosis created, rows affected: " + rowsInserted);
                            System.out.println("Created new diagnosis with status: " + diagnosisStatus + " for patient ID: " + patientID);
                            
                            response.getWriter().write("Diagnosis created successfully");
                        }
                    }
                }
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid number format: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid ID format");
        } catch (SQLException e) {
            System.err.println("SQL error: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Database error: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Unexpected error: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Server error: " + e.getMessage());
        }
    }
}
