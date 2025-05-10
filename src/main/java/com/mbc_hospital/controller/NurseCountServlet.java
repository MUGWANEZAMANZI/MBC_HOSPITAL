package com.mbc_hospital.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

import com.mbc_hospital.model.DBConnection;

@WebServlet("/nurse-count")
public class NurseCountServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT COUNT(*) AS total FROM Users WHERE UserType = 'Nurse'";
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    response.getWriter().print(rs.getInt("total"));
                }
            }
        } catch (SQLException e) {
            response.getWriter().print("0");
            e.printStackTrace();
        }
    }
}
