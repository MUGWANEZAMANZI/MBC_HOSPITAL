package com.mbc_hospital.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;

import com.mbc_hospital.model.DBConnection;

@WebServlet("/unverified-accounts")
public class UnverifiedAccountsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Optional: allow frontend JS access from any domain (not secure for production)
        response.setHeader("Access-Control-Allow-Origin", "*");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT UserID, username, email, usertype FROM Users WHERE is_verified = FALSE AND usertype != 'Admin'";
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {

                StringBuilder json = new StringBuilder();
                json.append("[");

                boolean first = true;
                while (rs.next()) {
                    if (!first) json.append(",");
                    json.append("{");
                    json.append("\"UserID\":").append(rs.getInt("UserID")).append(",");
                    json.append("\"username\":\"").append(rs.getString("username")).append("\",");
                    json.append("\"email\":\"").append(rs.getString("email")).append("\",");
                    json.append("\"usertype\":\"").append(rs.getString("usertype")).append("\"");
                    json.append("}");
                    first = false;
                }

                json.append("]");
                response.getWriter().write(json.toString());
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"success\": false, \"error\": \"Server error\"}");
        }
    }
}
