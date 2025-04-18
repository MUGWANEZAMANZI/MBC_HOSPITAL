// File: LoginServlet.java (Controller)
package com.mbc_hospital.controller;

import com.mbc_hospital.model.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get credentials from request
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Validate input (simple example)
        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            response.sendRedirect("login.jsp?error=empty");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM Users WHERE username = ? AND password = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                stmt.setString(2, password);

                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                    	//Retrieving user type
                    	String usertype = rs.getString("usertype");
                    	int id = rs.getInt("UserID");
                        // Successful login
                    	
                        HttpSession session = request.getSession();
                        session.setAttribute("username", username);
                        session.setAttribute("usertype",usertype);
                        session.setAttribute("id", id);
                        response.sendRedirect("dashboard.jsp");
                    } else {
                        // Login failed
                        response.sendRedirect("login.jsp?error=invalid");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=server");
        }
    }
}
