package com.mbc_hospital.controller;

import com.mbc_hospital.model.DBConnection;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.sql.*;

@WebServlet("/verify-nurse")
public class NurseVerificationServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Check if user is authorized (must be a doctor or admin)
        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("usertype");
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        if (!"Doctor".equalsIgnoreCase(userType) && !"Admin".equalsIgnoreCase(userType)) {
            out.print("{\"success\": false, \"message\": \"Unauthorized. Only doctors and administrators can verify nurses.\"}");
            return;
        }
        
        String action = request.getParameter("action");
        int nurseid = Integer.parseInt(request.getParameter("nurseid"));
        
        try (Connection conn = DBConnection.getConnection()) {
            boolean success = false;
            
            if ("verify".equalsIgnoreCase(action)) {
                // Set is_verified to true
                String sql = "UPDATE Users SET is_verified = 1 WHERE UserID = ? AND UserType = 'Nurse'";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, nurseid);
                    int updated = stmt.executeUpdate();
                    success = updated > 0;
                }
            } else if ("reject".equalsIgnoreCase(action)) {
                // Optionally, you could either mark as rejected or delete the user
                // Here we'll implement deletion
                String sql = "DELETE FROM Users WHERE UserID = ? AND UserType = 'Nurse' AND is_verified = 0";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, nurseid);
                    int deleted = stmt.executeUpdate();
                    success = deleted > 0;
                }
            }
            
            if (success) {
                String message = "Nurse " + ("verify".equalsIgnoreCase(action) ? "verified" : "rejected") + " successfully";
                out.print("{\"success\": true, \"message\": \"" + message + "\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"No nurse found with the provided ID or action failed\"}");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Database error: " + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
} 