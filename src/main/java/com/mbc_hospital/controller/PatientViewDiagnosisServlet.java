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
        if (session == null || !"patient".equalsIgnoreCase((String) session.getAttribute("usertype"))) {
            response.sendRedirect("patient_login.jsp");
            return;
        }
        
        // Get diagnosis ID from request
        String diagnosisIdStr = request.getParameter("id");
        if (diagnosisIdStr == null || diagnosisIdStr.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Missing diagnosis ID");
            return;
        }
        
        int diagnosisId;
        try {
            diagnosisId = Integer.parseInt(diagnosisIdStr);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid diagnosis ID format");
            return;
        }
        
        // Get patient ID from session
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
            
            // Get diagnosis details
            String sql = "SELECT d.*, " +
                        "CONCAT(n.first_name, ' ', n.last_name) as nurse_name, " +
                        "CONCAT(doc.first_name, ' ', doc.last_name) as doctor_name " +
                        "FROM diagnoses d " +
                        "LEFT JOIN users n ON d.nurse_id = n.user_id " +
                        "LEFT JOIN users doc ON d.doctor_id = doc.user_id " +
                        "WHERE d.diagnosis_id = ? AND d.patient_id = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, diagnosisId);
            stmt.setInt(2, patientId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                // Create diagnosis object
                Diagnosis diagnosis = new Diagnosis();
                diagnosis.setDiagnosisId(rs.getInt("diagnosis_id"));
                diagnosis.setPatientId(rs.getInt("patient_id"));
                diagnosis.setNurseId(rs.getInt("nurse_id"));
                diagnosis.setDoctorId(rs.getInt("doctor_id"));
                diagnosis.setStatus(rs.getString("status"));
                diagnosis.setResult(rs.getString("result"));
                diagnosis.setMedicationsPrescribed(rs.getString("medications_prescribed"));
                diagnosis.setFollowUpDate(rs.getDate("follow_up_date"));
                diagnosis.setDiagnosisDate(rs.getDate("diagnosis_date"));
                diagnosis.setNurseAssessment(rs.getString("nurse_assessment"));
                diagnosis.setNurseName(rs.getString("nurse_name"));
                diagnosis.setDoctorName(rs.getString("doctor_name"));
                
                // Convert to JSON and return
                Gson gson = new Gson();
                String json = gson.toJson(diagnosis);
                
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(json);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("Diagnosis not found or not authorized to view");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Database error: " + e.getMessage());
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
} 