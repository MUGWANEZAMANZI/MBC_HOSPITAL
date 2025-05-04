package com.mbc_hospital.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.mbc_hospital.model.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/update-verification")
public class UpdateVerificationStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userId = request.getParameter("userId");
        String action = request.getParameter("action"); 
        int status = "verify".equalsIgnoreCase(action) ? 1 : 0;
        
        System.out.print(userId);

        response.setContentType("application/json");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE Users SET is_verified = ? WHERE UserID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, status);
            stmt.setInt(2, Integer.parseInt(userId));

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                response.getWriter().write("{\"success\": true}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"User not found.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"success\": false, \"error\": \"Server error.\"}");
        }
    }
}
