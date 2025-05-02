package com.mbc_hospital.controller;

import com.mbc_hospital.model.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/patient-count")
public class PatientCountServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int count = 0;

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT COUNT(*) FROM Patients";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

            rs.close();
            stmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println(count);
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();
        out.print(count);
        out.flush();
    }
}
