package com.mbc_hospital.controller;

import com.mbc_hospital.model.Patient;
import com.mbc_hospital.model.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet("/CreatePatientServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // Limit: 5MB
public class CreatePatientServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(CreatePatientServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement stmt = null;
        PreparedStatement diagnosisStmt = null;
        ResultSet generatedKeys = null;
        
        try {
            // Retrieve form fields
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String telephone = request.getParameter("telephone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            int registeredBy = Integer.parseInt(request.getParameter("registeredBy"));

            LOGGER.info("Creating new patient: " + firstName + " " + lastName);

            // Handle uploaded image
            Part filePart = request.getPart("pImageLink");
            String fileName = null;
            String imageDbPath = null;

            if (filePart != null && filePart.getSize() > 0) {
                // Create a unique filename to prevent collisions
                fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                
                // Create the images directory if it doesn't exist
                String imagesPath = getServletContext().getRealPath("/") + "images";
                File imagesDir = new File(imagesPath);
                if (!imagesDir.exists()) {
                    imagesDir.mkdirs();
                }
                
                // Write the file to the images directory
                filePart.write(imagesPath + File.separator + fileName);
                
                // Set the database path - only storing the URL, not the actual image
                imageDbPath = "images/" + fileName;
            }

            // Store in DB
            conn = DBConnection.getConnection();
            
            // Start transaction
            conn.setAutoCommit(false);
            
            // 1. Insert patient
            String sql = "INSERT INTO Patients (FirstName, LastName, Telephone, Email, Address, RegisteredBy, PImageLink) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, firstName);
            stmt.setString(2, lastName);
            stmt.setString(3, telephone);
            stmt.setString(4, email);
            stmt.setString(5, address);
            stmt.setInt(6, registeredBy);
            stmt.setString(7, imageDbPath); // Store the URL path, not the actual image

            int patientsAffected = stmt.executeUpdate();
            LOGGER.info("Patient record inserted: " + patientsAffected + " row(s) affected");
            
            // Get the generated patient ID
            generatedKeys = stmt.getGeneratedKeys();
            int patientId = 0;
            if (generatedKeys.next()) {
                patientId = generatedKeys.getInt(1);
                LOGGER.info("Generated PatientID: " + patientId);
                
                // 2. Create a diagnosis entry with "Action Required" status
                String diagnosisSql = "INSERT INTO Diagnosis (PatientID, NurseID, DiagnoStatus, Result) VALUES (?, ?, 'Action Required', 'Pending')";
                diagnosisStmt = conn.prepareStatement(diagnosisSql);
                diagnosisStmt.setInt(1, patientId);
                diagnosisStmt.setInt(2, registeredBy); // Assuming the nurse who registered the patient
                int diagnosisAffected = diagnosisStmt.executeUpdate();
                LOGGER.info("Diagnosis record created with 'Action Required' status: " + diagnosisAffected + " row(s) affected");
            }
            
            // Commit transaction
            conn.commit();
            LOGGER.info("Transaction committed successfully");

            response.sendRedirect("patients-dir");

        } catch (Exception e) {
            // Roll back transaction on error
            if (conn != null) {
                try {
                    conn.rollback();
                    LOGGER.log(Level.SEVERE, "Transaction rolled back due to error", e);
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Failed to roll back transaction", ex);
                }
            }
            LOGGER.log(Level.SEVERE, "Error creating patient record", e);
            e.printStackTrace();
            response.sendRedirect("nurse_dashboard.jsp?error=creation_failed");
        } finally {
            // Properly close resources
            try {
                if (generatedKeys != null) generatedKeys.close();
                if (diagnosisStmt != null) diagnosisStmt.close();
                if (stmt != null) stmt.close();
                if (conn != null) {
                    conn.setAutoCommit(true); // Reset auto-commit
                    conn.close();
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing resources", e);
                e.printStackTrace();
            }
        }
    }
}
