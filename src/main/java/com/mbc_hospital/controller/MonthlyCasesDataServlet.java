package com.mbc_hospital.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.mbc_hospital.model.DBConnection;

@WebServlet("/monthly-cases-data")
public class MonthlyCasesDataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        
        try (Connection conn = DBConnection.getConnection();
             PrintWriter out = response.getWriter()) {
            
            // Get current year
            int currentYear = LocalDate.now().getYear();
            
            // Get total cases per month for current year
            String totalSql = "SELECT MONTH(RegistrationDate) as month, COUNT(*) as count " +
                             "FROM Patients " +
                             "WHERE YEAR(RegistrationDate) = ? " +
                             "GROUP BY MONTH(RegistrationDate) " +
                             "ORDER BY month";
                             
            Map<Integer, Integer> totalCasesMap = new HashMap<>();
            try (PreparedStatement ps = conn.prepareStatement(totalSql)) {
                ps.setInt(1, currentYear);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        int month = rs.getInt("month");
                        int count = rs.getInt("count");
                        totalCasesMap.put(month, count);
                    }
                }
            }
            
            // Get referred cases per month for current year
            String referredSql = "SELECT MONTH(p.RegistrationDate) as month, COUNT(*) as count " +
                               "FROM Patients p " +
                               "JOIN Diagnosis d ON p.PatientID = d.PatientID " +
                               "WHERE YEAR(p.RegistrationDate) = ? " +
                               "AND d.DiagnoStatus = 'Referrable' " +
                               "GROUP BY MONTH(p.RegistrationDate) " +
                               "ORDER BY month";
                               
            Map<Integer, Integer> referredCasesMap = new HashMap<>();
            try (PreparedStatement ps = conn.prepareStatement(referredSql)) {
                ps.setInt(1, currentYear);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        int month = rs.getInt("month");
                        int count = rs.getInt("count");
                        referredCasesMap.put(month, count);
                    }
                }
            }
            
            // Create arrays for chart data
            String[] months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
            int[] totalCases = new int[12];
            int[] referredCases = new int[12];
            
            for (int i = 0; i < 12; i++) {
                int monthNumber = i + 1;
                totalCases[i] = totalCasesMap.getOrDefault(monthNumber, 0);
                referredCases[i] = referredCasesMap.getOrDefault(monthNumber, 0);
            }
            
            // Build JSON manually
            StringBuilder json = new StringBuilder();
            json.append("{");
            
            // Add labels array
            json.append("\"labels\":[");
            for (int i = 0; i < months.length; i++) {
                json.append("\"").append(months[i]).append("\"");
                if (i < months.length - 1) {
                    json.append(",");
                }
            }
            json.append("],");
            
            // Add totalCases array
            json.append("\"totalCases\":[");
            for (int i = 0; i < totalCases.length; i++) {
                json.append(totalCases[i]);
                if (i < totalCases.length - 1) {
                    json.append(",");
                }
            }
            json.append("],");
            
            // Add referredCases array
            json.append("\"referredCases\":[");
            for (int i = 0; i < referredCases.length; i++) {
                json.append(referredCases[i]);
                if (i < referredCases.length - 1) {
                    json.append(",");
                }
            }
            json.append("]");
            
            json.append("}");
            
            out.write(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
} 