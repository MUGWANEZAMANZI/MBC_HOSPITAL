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

import com.google.gson.Gson;

@WebServlet("/patient-view-diagnosis")
public class PatientViewDiagnosisServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in as patient
        if (session == null || session.getAttribute("usertype") == null || 
            !session.getAttribute("usertype").equals("patient")) {
            response.sendRedirect("patient_login.jsp");
            return;
        }
        
        // Get diagnosisId from request
        String diagnosisIdStr = request.getParameter("diagnosisId");
        if (diagnosisIdStr == null || diagnosisIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Diagnosis ID is required");
            return;
        }
        
        int diagnosisId;
        try {
            diagnosisId = Integer.parseInt(diagnosisIdStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Diagnosis ID");
            return;
        }
        
        // Get patientId from session
        Integer patientId = (Integer) session.getAttribute("patientID");
        if (patientId == null) {
            response.sendRedirect("patient_login.jsp");
            return;
        }
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Query to get diagnosis details - Use correct table and column names
            String sql = "SELECT d.*, " +
                         "CONCAT(doc.FirstName, ' ', doc.LastName) as doctor_name, " +
                         "CONCAT(nur.FirstName, ' ', nur.LastName) as nurse_name " +
                         "FROM Diagnosis d " +
                         "LEFT JOIN Users doc ON d.DoctorID = doc.UserID " +
                         "LEFT JOIN Users nur ON d.NurseID = nur.UserID " +
                         "WHERE d.DiagnosisID = ? AND d.PatientID = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, diagnosisId);
            stmt.setInt(2, patientId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                // Create diagnosis object with all fields
                Diagnosis diagnosis = new Diagnosis(
                    rs.getInt("DiagnosisID"),
                    rs.getInt("PatientID"),
                    rs.getInt("NurseID"),
                    rs.getInt("DoctorID"),
                    rs.getString("DiagnoStatus"), // Note: Column name is DiagnoStatus, not Status
                    rs.getString("Result"),
                    rs.getString("MedicationsPrescribed"),
                    rs.getDate("FollowUpDate"),
                    rs.getTimestamp("DiagnosisDate"),
                    rs.getString("NurseAssessment")
                );
                
                // Create response JSON with diagnosis and additional doctor/nurse names
                Gson gson = new Gson();
                String json = gson.toJson(diagnosis);
                
                // Set response type and write JSON
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(json);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Diagnosis not found or access denied");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // For future implementation if needed
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
} 