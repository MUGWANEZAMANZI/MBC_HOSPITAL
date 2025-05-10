package com.mbc_hospital.controller;

import java.io.IOException;
import java.net.URL;
import java.io.ObjectInputStream;
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

@WebServlet("/doctor-list-data")
public class DoctorListDataServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/plain");
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM Users WHERE UserType = 'Doctor' AND is_verified = 1";
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    // Return all fields separated by |
                    String doctorData = rs.getInt("UserID") + "|" +
                                        rs.getString("Username") + "|" +
                                        rs.getString("UserType") + "|" +
                                        rs.getTimestamp("created_at") + "|" +
                                        rs.getBoolean("is_verified");
                    response.getWriter().println(doctorData);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("ERROR: Database failure");
        }
    }
}
