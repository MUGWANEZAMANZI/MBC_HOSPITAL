package com.mbc_hospital.controller;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/unverified-nurse-list")
public class UnverifiedNurseListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<User> unverifiedNurses = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM Users WHERE UserType = 'Nurse' AND is_verified = 0";
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setUserID(rs.getInt("UserID"));
                    user.setUsername(rs.getString("Username"));
                    user.setUserType(rs.getString("UserType"));
                    user.setVerified(rs.getBoolean("is_verified"));
                    unverifiedNurses.add(user);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Send serialized data
        response.setContentType("application/x-java-serialized-object");
        try (ObjectOutputStream out = new ObjectOutputStream(response.getOutputStream())) {
            out.writeObject(unverifiedNurses);
        }
    }
} 