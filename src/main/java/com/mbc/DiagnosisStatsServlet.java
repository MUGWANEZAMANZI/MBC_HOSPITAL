package com.mbc;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.mbc_hospital.model.DBConnection;

@WebServlet("/diagnosis-stats")
public class DiagnosisStatsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Get monthly stats for doctor and nurse resolved cases
            Map<String, List<Integer>> monthlyStats = getMonthlyStats(conn);
            // Get diagnosis status distribution stats
            Map<String, Integer> statusStats = getStatusStats(conn);
            
            // Create JSON response manually
            StringBuilder json = new StringBuilder("{");
            
            // Add doctor monthly stats
            json.append("\"doctorMonthlyStats\":[");
            List<Integer> doctorData = monthlyStats.get("doctor");
            for (int i = 0; i < doctorData.size(); i++) {
                json.append(doctorData.get(i));
                if (i < doctorData.size() - 1) {
                    json.append(",");
                }
            }
            json.append("],");
            
            // Add nurse monthly stats
            json.append("\"nurseMonthlyStats\":[");
            List<Integer> nurseData = monthlyStats.get("nurse");
            for (int i = 0; i < nurseData.size(); i++) {
                json.append(nurseData.get(i));
                if (i < nurseData.size() - 1) {
                    json.append(",");
                }
            }
            json.append("],");
            
            // Add status stats
            json.append("\"statusStats\":{");
            int count = 0;
            for (Map.Entry<String, Integer> entry : statusStats.entrySet()) {
                json.append("\"").append(entry.getKey()).append("\":").append(entry.getValue());
                if (count < statusStats.size() - 1) {
                    json.append(",");
                }
                count++;
            }
            json.append("}}");
            
            response.setContentType("application/json");
            response.getWriter().write(json.toString());
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error\"}");
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
    
    private Map<String, List<Integer>> getMonthlyStats(Connection conn) throws SQLException {
        Map<String, List<Integer>> result = new HashMap<>();
        List<Integer> doctorStats = new ArrayList<>(12);
        List<Integer> nurseStats = new ArrayList<>(12);
        
        // Initialize with zeros
        for (int i = 0; i < 12; i++) {
            doctorStats.add(0);
            nurseStats.add(0);
        }
        
        // Get monthly doctor resolved cases (Positive or Negative status)
        String doctorQuery = "SELECT MONTH(DiagnosisDate) as month, COUNT(*) as count " +
                             "FROM Diagnosis " +
                             "WHERE DoctorID IS NOT NULL " +
                             "AND DiagnoStatus IN ('Positive', 'Negative') " +
                             "AND YEAR(DiagnosisDate) = YEAR(CURRENT_DATE) " +
                             "GROUP BY MONTH(DiagnosisDate)";
        
        try (PreparedStatement stmt = conn.prepareStatement(doctorQuery);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                int month = rs.getInt("month");
                int count = rs.getInt("count");
                // Month is 1-based, but array is 0-based
                doctorStats.set(month - 1, count);
            }
        }
        
        // Get monthly nurse resolved cases (Positive or Negative status)
        String nurseQuery = "SELECT MONTH(DiagnosisDate) as month, COUNT(*) as count " +
                            "FROM Diagnosis " +
                            "WHERE NurseID IS NOT NULL " +
                            "AND DiagnoStatus IN ('Positive', 'Negative') " +
                            "AND YEAR(DiagnosisDate) = YEAR(CURRENT_DATE) " +
                            "GROUP BY MONTH(DiagnosisDate)";
        
        try (PreparedStatement stmt = conn.prepareStatement(nurseQuery);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                int month = rs.getInt("month");
                int count = rs.getInt("count");
                // Month is 1-based, but array is 0-based
                nurseStats.set(month - 1, count);
            }
        }
        
        result.put("doctor", doctorStats);
        result.put("nurse", nurseStats);
        return result;
    }
    
    private Map<String, Integer> getStatusStats(Connection conn) throws SQLException {
        Map<String, Integer> result = new HashMap<>();
        
        // Get counts for each status category
        String resolvedByDoctorsQuery = "SELECT COUNT(*) as count FROM Diagnosis " +
                                       "WHERE DoctorID IS NOT NULL " +
                                       "AND DiagnoStatus IN ('Positive', 'Negative')";
        
        String resolvedByNursesQuery = "SELECT COUNT(*) as count FROM Diagnosis " +
                                      "WHERE NurseID IS NOT NULL " +
                                      "AND DiagnoStatus IN ('Positive', 'Negative')";
        
        String pendingCasesQuery = "SELECT COUNT(*) as count FROM Diagnosis " +
                                  "WHERE DiagnoStatus = 'Action Required'";
        
        String referredCasesQuery = "SELECT COUNT(*) as count FROM Diagnosis " +
                                   "WHERE DiagnoStatus = 'Referrable'";
        
        // Query for resolved by doctors
        try (PreparedStatement stmt = conn.prepareStatement(resolvedByDoctorsQuery);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                result.put("resolvedByDoctors", rs.getInt("count"));
            }
        }
        
        // Query for resolved by nurses
        try (PreparedStatement stmt = conn.prepareStatement(resolvedByNursesQuery);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                result.put("resolvedByNurses", rs.getInt("count"));
            }
        }
        
        // Query for pending cases
        try (PreparedStatement stmt = conn.prepareStatement(pendingCasesQuery);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                result.put("pendingCases", rs.getInt("count"));
            }
        }
        
        // Query for referred cases
        try (PreparedStatement stmt = conn.prepareStatement(referredCasesQuery);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                result.put("referredCases", rs.getInt("count"));
            }
        }
        
        return result;
    }
} 