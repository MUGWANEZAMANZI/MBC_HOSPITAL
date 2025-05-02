package com.mbc_hospital.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.mbc_hospital.model.DBConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/update-doctor-status")
public class UpdateDoctorStatusServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String doctorId = req.getParameter("doctorId");
        String status = req.getParameter("status");
        
        if (doctorId == null || doctorId.trim().isEmpty() || status == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"success\": false, \"error\": \"Missing doctorId or status\"}");
            return;
        }

        
        System.out.println("test id" + doctorId);
        System.out.println("test status" + status);

        resp.setContentType("application/json");  
        try (Connection conn = DBConnection.getConnection()) {
        	int doctorIdC = Integer.parseInt(doctorId.trim());
            String sql = "UPDATE Doctors SET status = ? WHERE DoctorID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setInt(2, doctorIdC);

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                resp.getWriter().write("{\"success\": true}");
            } else {
                resp.getWriter().write("{\"success\": false}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);  // set proper HTTP status
            resp.getWriter().write("{\"success\": false, \"error\": \"Server error\"}");
        }
    }
}

