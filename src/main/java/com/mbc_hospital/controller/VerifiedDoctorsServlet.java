package com.mbc_hospital.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/verified-doctors")
public class VerifiedDoctorsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in and is an admin
        if (session == null || session.getAttribute("username") == null || 
            !"Admin".equalsIgnoreCase((String) session.getAttribute("usertype"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        List<User> verifiedDoctors = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM Users WHERE UserType = 'Doctor' AND is_verified = 1";
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    User doctor = new User();
                    doctor.setUserID(rs.getInt("UserID"));
                    doctor.setUsername(rs.getString("Username"));
                    doctor.setUserType(rs.getString("UserType"));
                    doctor.setVerified(rs.getBoolean("is_verified"));
                    
                    // Additional fields can be added if needed
                    
                    verifiedDoctors.add(doctor);
                }
            }
            
            request.setAttribute("verifiedDoctors", verifiedDoctors);
            RequestDispatcher dispatcher = request.getRequestDispatcher("view_doctors.jsp");
            dispatcher.forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("error.jsp");
            dispatcher.forward(request, response);
        }
    }
} 