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

import com.mbc_hospital.model.DBConnection;

@WebServlet("/doctor-solved-cases")
public class DoctorSolvedCasesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Map<String, Object>> solvedCases = new ArrayList<>();
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Query for cases solved by doctors (Positive or Negative status)
            String query = "SELECT d.DiagnosisID, d.PatientID, p.FirstName, p.LastName, " +
                          "d.DiagnoStatus, d.Result, d.DiagnosisDate, " +
                          "u.Username AS DoctorName " +
                          "FROM Diagnosis d " +
                          "JOIN Patients p ON d.PatientID = p.PatientID " +
                          "JOIN Users u ON d.DoctorID = u.UserID " +
                          "WHERE d.DoctorID IS NOT NULL " +
                          "AND d.DiagnoStatus IN ('Positive', 'Negative') " +
                          "ORDER BY d.DiagnosisDate DESC";
            
            try (PreparedStatement stmt = conn.prepareStatement(query);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    Map<String, Object> caseDetails = new HashMap<>();
                    caseDetails.put("diagnosisID", rs.getInt("DiagnosisID"));
                    caseDetails.put("patientID", rs.getInt("PatientID"));
                    caseDetails.put("patientName", rs.getString("FirstName") + " " + rs.getString("LastName"));
                    caseDetails.put("status", rs.getString("DiagnoStatus"));
                    caseDetails.put("result", rs.getString("Result"));
                    caseDetails.put("date", rs.getTimestamp("DiagnosisDate"));
                    caseDetails.put("doctorName", rs.getString("DoctorName"));
                    
                    solvedCases.add(caseDetails);
                }
            }
            
            // Set the list as a request attribute and forward to the JSP
            request.setAttribute("solvedCases", solvedCases);
            request.getRequestDispatcher("/doctor_solved_cases.jsp").forward(request, response);
            
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