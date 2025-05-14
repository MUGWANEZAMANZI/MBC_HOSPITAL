package com.mbc_hospital.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Diagnosis;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/update-diagnosis")
public class UpdateDiagnosisServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        if (session == null || session.getAttribute("username") == null || 
            !session.getAttribute("usertype").equals("Doctor")) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String diagnosisId = request.getParameter("id");
        
        if (diagnosisId == null || diagnosisId.trim().isEmpty()) {
            request.setAttribute("error", "Diagnosis ID is required");
            request.getRequestDispatcher("referred-diagnoses").forward(request, response);
            return;
        }
        
        try {
            // Get the diagnosis details
            Diagnosis diagnosis = getDiagnosisById(Integer.parseInt(diagnosisId));
            
            if (diagnosis == null) {
                request.setAttribute("error", "Diagnosis not found");
                request.getRequestDispatcher("referred-diagnoses").forward(request, response);
                return;
            }
            
            // Get patient name
            String patientName = getPatientName(diagnosis.getPatientId());
            
            // Set attributes for the form
            request.setAttribute("diagnosis", diagnosis);
            request.setAttribute("patientName", patientName);
            
            // Forward to the diagnosis update form
            request.getRequestDispatcher("/update_diagnosis.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid diagnosis ID format");
            request.getRequestDispatcher("referred-diagnoses").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("referred-diagnoses").forward(request, response);
        }
    }

    // Helper method to get diagnosis by ID
    private Diagnosis getDiagnosisById(int diagnosisId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Diagnosis WHERE DiagnosisID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, diagnosisId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                // Use full constructor with all parameters
                return new Diagnosis(
                    rs.getInt("DiagnosisID"),
                    rs.getInt("PatientID"),
                    rs.getInt("NurseID"),
                    rs.getInt("DoctorID"),
                    rs.getString("DiagnoStatus"),
                    rs.getString("Result"),
                    rs.getString("MedicationsPrescribed"),
                    rs.getDate("FollowUpDate"),
                    rs.getTimestamp("DiagnosisDate"),
                    rs.getString("NurseAssessment")
                );
            }
            
            return null;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    // Helper method to get patient name
    private String getPatientName(int patientId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT FirstName, LastName FROM Patients WHERE PatientID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, patientId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("FirstName") + " " + rs.getString("LastName");
            }
            
            return "Unknown Patient";
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Get user info from session - check multiple possible session attributes
        Integer doctorID = null;
        if (session.getAttribute("id") != null) {
            doctorID = (Integer) session.getAttribute("id");
        } else if (session.getAttribute("userid") != null) {
            doctorID = (Integer) session.getAttribute("userid");
        } else if (session.getAttribute("UserID") != null) {
            doctorID = (Integer) session.getAttribute("UserID");
        } else if (session.getAttribute("userId") != null) {
            doctorID = (Integer) session.getAttribute("userId");
        } else if (session.getAttribute("user_id") != null) {
            doctorID = (Integer) session.getAttribute("user_id");
        }
        
        // Get form parameters
        String diagnosisIDStr = request.getParameter("diagnosisID");
        String patientIDStr = request.getParameter("patientID");
        String diagnoStatus = request.getParameter("diagnoStatus");
        String result = request.getParameter("result");
        String medicationsPrescribed = request.getParameter("medicationsPrescribed");
        String followUpDate = request.getParameter("followUpDate");
        
        // Print debug info
        System.out.println("Processing diagnosis update:");
        System.out.println("patientID: " + patientIDStr);
        System.out.println("diagnosisID: " + diagnosisIDStr);
        System.out.println("diagnoStatus: " + diagnoStatus);
        System.out.println("result: " + result);
        System.out.println("medicationsPrescribed: " + medicationsPrescribed);
        System.out.println("followUpDate: " + followUpDate);
        System.out.println("doctorID: " + doctorID);
        
        // Print all session attributes for debugging
        System.out.println("Session attributes:");
        java.util.Enumeration<String> attributeNames = session.getAttributeNames();
        while (attributeNames.hasMoreElements()) {
            String name = attributeNames.nextElement();
            System.out.println(name + ": " + session.getAttribute(name));
        }
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Check if this is a new diagnosis or an update to existing one
            int patientID = Integer.parseInt(patientIDStr);
            
            // Use REPLACE INTO to either insert new or update existing record
            String sql = "REPLACE INTO Diagnosis (DiagnosisID, PatientID, DoctorID, DiagnoStatus, Result, MedicationsPrescribed, FollowUpDate) VALUES (?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            
            // If diagnosisID is empty or null, use patient ID (create new diagnosis)
            if (diagnosisIDStr == null || diagnosisIDStr.trim().isEmpty()) {
                stmt.setInt(1, patientID); // Use patientID as diagnosisID
            } else {
                stmt.setInt(1, Integer.parseInt(diagnosisIDStr));
            }
            
            stmt.setInt(2, patientID);
            
            // Handle null doctorID
            if (doctorID != null) {
                stmt.setInt(3, doctorID);
            } else {
                // Set to NULL in database - doctor not assigned yet
                stmt.setNull(3, java.sql.Types.INTEGER);
            }
            
            stmt.setString(4, diagnoStatus);
            stmt.setString(5, result);
            
            // Handle null values for optional fields
            if (medicationsPrescribed == null || medicationsPrescribed.trim().isEmpty()) {
                stmt.setNull(6, java.sql.Types.VARCHAR);
            } else {
                stmt.setString(6, medicationsPrescribed);
            }
            
            if (followUpDate == null || followUpDate.trim().isEmpty()) {
                stmt.setNull(7, java.sql.Types.DATE);
            } else {
                // Convert string date to SQL Date
                java.sql.Date sqlDate = java.sql.Date.valueOf(followUpDate);
                stmt.setDate(7, sqlDate);
            }
            
            int rows = stmt.executeUpdate();
            
            if (rows > 0) {
                session.setAttribute("message", "Diagnosis updated successfully");
                response.sendRedirect("DiagnosisViewServlet"); // Redirect to the diagnosis list view
            } else {
                session.setAttribute("error", "Failed to update diagnosis");
                response.sendRedirect("referred-diagnoses"); // Redirect back to list of referred cases
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Database error: " + e.getMessage());
            response.sendRedirect("referred-diagnoses");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("error", "Invalid ID format: " + e.getMessage());
            response.sendRedirect("referred-diagnoses");
        } finally {
            try { if (stmt != null) stmt.close(); } catch (Exception e) { }
            try { if (conn != null) conn.close(); } catch (Exception e) { }
        }
    }
} 