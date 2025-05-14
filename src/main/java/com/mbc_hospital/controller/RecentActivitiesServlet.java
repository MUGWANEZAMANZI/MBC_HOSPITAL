package com.mbc_hospital.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
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

@WebServlet("/recent-activities")
public class RecentActivitiesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        
        try (Connection conn = DBConnection.getConnection();
             PrintWriter out = response.getWriter()) {
            
            List<Map<String, String>> activities = new ArrayList<>();
            
            // Get recent patient registrations
            String registrationSql = "SELECT p.FirstName, p.LastName, p.RegistrationDate, u.Username " +
                                    "FROM Patients p " +
                                    "JOIN Users u ON p.RegisteredBy = u.UserID " +
                                    "ORDER BY p.RegistrationDate DESC LIMIT 3";
                                    
            try (PreparedStatement ps = conn.prepareStatement(registrationSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> activity = new HashMap<>();
                    activity.put("type", "registration");
                    activity.put("icon", "user-plus");
                    activity.put("title", "New patient registered");
                    activity.put("description", rs.getString("FirstName") + " " + rs.getString("LastName") + " was added to the system");
                    activity.put("time", formatTimeAgo(rs.getTimestamp("RegistrationDate")));
                    activities.add(activity);
                }
            }
            
            // Get recent diagnoses
            String diagnosisSql = "SELECT p.FirstName, p.LastName, d.DiagnosisDate, u.Username " +
                                 "FROM Diagnosis d " +
                                 "JOIN Patients p ON d.PatientID = p.PatientID " +
                                 "JOIN Users u ON d.NurseID = u.UserID " +
                                 "WHERE d.DiagnoStatus IN ('Positive', 'Negative') " +
                                 "ORDER BY d.DiagnosisDate DESC LIMIT 3";
                                 
            try (PreparedStatement ps = conn.prepareStatement(diagnosisSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> activity = new HashMap<>();
                    activity.put("type", "diagnosis");
                    activity.put("icon", "clipboard-check");
                    activity.put("title", "Diagnosis completed");
                    activity.put("description", rs.getString("FirstName") + " " + rs.getString("LastName") + "'s diagnosis was completed");
                    activity.put("time", formatTimeAgo(rs.getTimestamp("DiagnosisDate")));
                    activities.add(activity);
                }
            }
            
            // Get recent referrals
            String referralSql = "SELECT p.FirstName, p.LastName, d.DiagnosisDate, u.Username, " +
                               "d2.Username AS DoctorName " +
                               "FROM Diagnosis d " +
                               "JOIN Patients p ON d.PatientID = p.PatientID " +
                               "JOIN Users u ON d.NurseID = u.UserID " +
                               "JOIN Users d2 ON d.DoctorID = d2.UserID " +
                               "WHERE d.DiagnoStatus = 'Referrable' " +
                               "ORDER BY d.DiagnosisDate DESC LIMIT 3";
                               
            try (PreparedStatement ps = conn.prepareStatement(referralSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> activity = new HashMap<>();
                    activity.put("type", "referral");
                    activity.put("icon", "share");
                    activity.put("title", "Case referred");
                    activity.put("description", rs.getString("FirstName") + " " + rs.getString("LastName") + " was referred to Dr. " + rs.getString("DoctorName"));
                    activity.put("time", formatTimeAgo(rs.getTimestamp("DiagnosisDate")));
                    activities.add(activity);
                }
            }
            
            // Build JSON manually
            StringBuilder json = new StringBuilder();
            json.append("[");
            
            for (int i = 0; i < activities.size(); i++) {
                Map<String, String> activity = activities.get(i);
                json.append("{");
                json.append("\"type\":\"").append(activity.get("type")).append("\",");
                json.append("\"icon\":\"").append(activity.get("icon")).append("\",");
                json.append("\"title\":\"").append(activity.get("title")).append("\",");
                json.append("\"description\":\"").append(activity.get("description")).append("\",");
                json.append("\"time\":\"").append(activity.get("time")).append("\"");
                json.append("}");
                
                if (i < activities.size() - 1) {
                    json.append(",");
                }
            }
            
            json.append("]");
            out.write(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("[{\"error\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}]");
        }
    }
    
    private String formatTimeAgo(Timestamp timestamp) {
        if (timestamp == null) {
            return "unknown time";
        }
        
        long diff = System.currentTimeMillis() - timestamp.getTime();
        long seconds = diff / 1000;
        long minutes = seconds / 60;
        long hours = minutes / 60;
        long days = hours / 24;
        
        if (days > 0) {
            return days + " day" + (days > 1 ? "s" : "") + " ago";
        } else if (hours > 0) {
            return hours + " hour" + (hours > 1 ? "s" : "") + " ago";
        } else if (minutes > 0) {
            return minutes + " minute" + (minutes > 1 ? "s" : "") + " ago";
        } else {
            return "just now";
        }
    }
} 