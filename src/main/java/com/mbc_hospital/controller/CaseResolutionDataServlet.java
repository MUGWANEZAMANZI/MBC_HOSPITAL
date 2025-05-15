package com.mbc_hospital.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

import com.mbc_hospital.model.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/case-resolution-data")
public class CaseResolutionDataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (Connection conn = DBConnection.getConnection()) {
            JSONObject result = new JSONObject();
            
            // Get monthly cases data - doctor resolved cases vs nurse resolved cases
            Map<String, Object> monthlyData = getMonthlyResolutionData(conn);
            result.putAll(monthlyData);
            
            // Get case distribution by status
            Map<String, Object> distributionData = getCaseDistributionData(conn);
            result.putAll(distributionData);
            
            // Get case counts by resolver
            Map<String, Object> caseCounts = getCaseCounts(conn);
            result.putAll(caseCounts);
            
            response.getWriter().write(result.toString());
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error: " + e.getMessage() + "\"}");
        }
    }
    
    private Map<String, Object> getMonthlyResolutionData(Connection conn) throws SQLException {
        Map<String, Object> result = new HashMap<>();
        
        // SQL to get monthly data for the past year
        String sql = 
            "SELECT " +
            "  MONTH(DiagnosisDate) AS month, " +
            "  SUM(CASE WHEN DoctorID IS NOT NULL AND (DiagnoStatus = 'Positive' OR DiagnoStatus = 'Negative') THEN 1 ELSE 0 END) AS doctor_resolved, " +
            "  SUM(CASE WHEN DoctorID IS NULL AND (DiagnoStatus = 'Positive' OR DiagnoStatus = 'Negative') THEN 1 ELSE 0 END) AS nurse_resolved " +
            "FROM Diagnosis " +
            "WHERE DiagnosisDate >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR) " +
            "GROUP BY MONTH(DiagnosisDate) " +
            "ORDER BY MONTH(DiagnosisDate)";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            
            // Initialize arrays for all 12 months
            int[] doctorResolved = new int[12];
            int[] nurseResolved = new int[12];
            String[] months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
            
            // Fill in the data we have
            while (rs.next()) {
                int month = rs.getInt("month") - 1; // 0-indexed for array
                doctorResolved[month] = rs.getInt("doctor_resolved");
                nurseResolved[month] = rs.getInt("nurse_resolved");
            }
            
            // Add data to result
            result.put("labels", months);
            result.put("doctorResolved", doctorResolved);
            result.put("nurseResolved", nurseResolved);
        }
        
        return result;
    }
    
    private Map<String, Object> getCaseDistributionData(Connection conn) throws SQLException {
        Map<String, Object> result = new HashMap<>();
        
        // Get case distribution by status
        String sql = 
            "SELECT " +
            "  SUM(CASE WHEN DoctorID IS NOT NULL AND (DiagnoStatus = 'Positive' OR DiagnoStatus = 'Negative') THEN 1 ELSE 0 END) AS doctor_resolved, " +
            "  SUM(CASE WHEN DoctorID IS NULL AND (DiagnoStatus = 'Positive' OR DiagnoStatus = 'Negative') THEN 1 ELSE 0 END) AS nurse_resolved, " +
            "  SUM(CASE WHEN DiagnoStatus = 'Action Required' THEN 1 ELSE 0 END) AS pending_cases, " +
            "  SUM(CASE WHEN DiagnoStatus = 'Referrable' THEN 1 ELSE 0 END) AS referred_cases " +
            "FROM Diagnosis";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                int doctorResolved = rs.getInt("doctor_resolved");
                int nurseResolved = rs.getInt("nurse_resolved");
                int pendingCases = rs.getInt("pending_cases");
                int referredCases = rs.getInt("referred_cases");
                
                result.put("distributionLabels", new String[]{"Resolved by Doctors", "Resolved by Nurses", "Pending Cases", "Referred Cases"});
                result.put("distributionData", new int[]{doctorResolved, nurseResolved, pendingCases, referredCases});
            }
        }
        
        return result;
    }
    
    private Map<String, Object> getCaseCounts(Connection conn) throws SQLException {
        Map<String, Object> result = new HashMap<>();
        
        // Get case counts by resolver
        String sql = 
            "SELECT " +
            "  COUNT(CASE WHEN DoctorID IS NOT NULL AND (DiagnoStatus = 'Positive' OR DiagnoStatus = 'Negative') THEN 1 END) AS doctor_count, " +
            "  COUNT(CASE WHEN DoctorID IS NULL AND (DiagnoStatus = 'Positive' OR DiagnoStatus = 'Negative') THEN 1 END) AS nurse_count, " +
            "  COUNT(CASE WHEN DiagnoStatus IN ('Action Required', 'Referrable') THEN 1 END) AS pending_count, " +
            "  COUNT(*) AS total_count " +
            "FROM Diagnosis " +
            "WHERE DiagnosisDate >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                result.put("doctorCount", rs.getInt("doctor_count"));
                result.put("nurseCount", rs.getInt("nurse_count"));
                result.put("pendingCount", rs.getInt("pending_count"));
                result.put("totalCount", rs.getInt("total_count"));
            }
        }
        
        // Calculate year-over-year percentage changes
        String trendSql = 
            "SELECT " +
            "  (SELECT COUNT(*) FROM Diagnosis WHERE DoctorID IS NOT NULL AND (DiagnoStatus = 'Positive' OR DiagnoStatus = 'Negative') " +
            "   AND DiagnosisDate BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 60 DAY) AND DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)) AS prev_doctor_count, " +
            "  (SELECT COUNT(*) FROM Diagnosis WHERE DoctorID IS NULL AND (DiagnoStatus = 'Positive' OR DiagnoStatus = 'Negative') " +
            "   AND DiagnosisDate BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 60 DAY) AND DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)) AS prev_nurse_count, " +
            "  (SELECT COUNT(*) FROM Diagnosis WHERE DiagnoStatus IN ('Action Required', 'Referrable') " +
            "   AND DiagnosisDate BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 60 DAY) AND DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)) AS prev_pending_count";
        
        try (PreparedStatement stmt = conn.prepareStatement(trendSql)) {
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                int prevDoctorCount = rs.getInt("prev_doctor_count");
                int prevNurseCount = rs.getInt("prev_nurse_count");
                int prevPendingCount = rs.getInt("prev_pending_count");
                
                int doctorCount = (Integer)result.get("doctorCount");
                int nurseCount = (Integer)result.get("nurseCount");
                int pendingCount = (Integer)result.get("pendingCount");
                
                // Calculate percentage changes
                double doctorChange = prevDoctorCount > 0 ? ((doctorCount - prevDoctorCount) * 100.0 / prevDoctorCount) : 0;
                double nurseChange = prevNurseCount > 0 ? ((nurseCount - prevNurseCount) * 100.0 / prevNurseCount) : 0;
                double pendingChange = prevPendingCount > 0 ? ((pendingCount - prevPendingCount) * 100.0 / prevPendingCount) : 0;
                
                result.put("doctorChange", Math.round(doctorChange));
                result.put("nurseChange", Math.round(nurseChange));
                result.put("pendingChange", Math.round(pendingChange));
            }
        }
        
        return result;
    }
} 