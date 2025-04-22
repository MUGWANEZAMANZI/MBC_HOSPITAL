package com.mbc_hospital.controller;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ManageUsersServlet")
public class ManageUsersServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> usersList = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM users";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                String username = rs.getString("username");
                String password = rs.getString("password");
                usersList.add(new User(username, password, password));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("usersList", usersList);
        request.getRequestDispatcher("manage_users.jsp").forward(request, response);
    }
}
