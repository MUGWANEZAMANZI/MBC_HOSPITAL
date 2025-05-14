package com.mbc_hospital.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.mbc_hospital.model.DBConnection;

@WebServlet("/confirmed-cases-count")
public class ConfirmedCasesCountServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();
        
        try (Connection conn = DBConnection.getConnection()) {
            String query = "SELECT COUNT(*) FROM Diagnosis WHERE DiagnoStatus IN ('Positive', 'Negative')";
            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                out.println(rs.getInt(1));
            } else {
                out.println(0);
            }
        } catch (Exception e) {
            out.println("NaN");
            e.printStackTrace();
        }
    }
} 