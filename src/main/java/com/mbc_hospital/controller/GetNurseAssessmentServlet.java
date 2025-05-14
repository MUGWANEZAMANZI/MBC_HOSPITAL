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

@WebServlet("/getNurseAssessment")
public class GetNurseAssessmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String patientIdStr = request.getParameter("patientId");
        
        if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Patient ID is required");
            return;
        }
        
        int patientId;
        try {
            patientId = Integer.parseInt(patientIdStr);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid Patient ID format");
            return;
        }
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Get the most recent nurse assessment for this patient
            String sql = "SELECT NurseAssessment FROM Diagnosis " +
                         "WHERE PatientID = ? AND NurseAssessment IS NOT NULL " +
                         "ORDER BY DiagnosisDate DESC LIMIT 1";
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, patientId);
            rs = stmt.executeQuery();
            
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            
            if (rs.next()) {
                String nurseAssessment = rs.getString("NurseAssessment");
                if (nurseAssessment != null && !nurseAssessment.trim().isEmpty()) {
                    response.getWriter().write(nurseAssessment);
                } else {
                    response.getWriter().write("No detailed assessment available for this patient.");
                }
            } else {
                // If no diagnosis exists with assessment, check if a previous diagnosis exists at all
                sql = "SELECT COUNT(*) as count FROM Diagnosis WHERE PatientID = ?";
                stmt.close();
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, patientId);
                rs.close();
                rs = stmt.executeQuery();
                
                if (rs.next() && rs.getInt("count") > 0) {
                    response.getWriter().write("Previous diagnosis exists, but no nurse assessment was provided.");
                } else {
                    response.getWriter().write("This is the patient's first diagnosis. No previous assessment available.");
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error retrieving nurse assessment: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error retrieving nurse assessment: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) { }
            try { if (stmt != null) stmt.close(); } catch (Exception e) { }
            try { if (conn != null) conn.close(); } catch (Exception e) { }
        }
    }
} 