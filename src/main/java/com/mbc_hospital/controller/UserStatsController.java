package com.mbc_hospital.controller;

import com.mbc_hospital.model.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import java.util.logging.Logger;

@WebServlet("/userStats")
public class UserStatsController extends HttpServlet {

    private static final Logger logger = Logger.getLogger(UserStatsController.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Map<String, Integer> counts = new HashMap<>();
        List<String> doctors = new ArrayList<>();
        List<String> nurses = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            logger.info("Database connection established.");

            // Count doctors and nurses
            String countSql = "SELECT UserType, COUNT(*) as total FROM Users WHERE UserType IN ('Doctor', 'Nurse') GROUP BY UserType";
            try (PreparedStatement stmt = conn.prepareStatement(countSql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    counts.put(rs.getString("UserType"), rs.getInt("total"));
                }
                logger.info("User counts fetched: " + counts.toString());
            }

            // Get list of doctors
            String doctorSql = "SELECT Username FROM Users WHERE UserType = 'Doctor'";
            try (PreparedStatement stmt = conn.prepareStatement(doctorSql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    doctors.add(rs.getString("Username"));
                }
                logger.info("Doctors retrieved: " + doctors.size());
            }

            // Get list of nurses
            String nurseSql = "SELECT Username FROM Users WHERE UserType = 'Nurse'";
            try (PreparedStatement stmt = conn.prepareStatement(nurseSql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    nurses.add(rs.getString("Username"));
                }
                logger.info("Nurses retrieved: " + nurses.size());
            }

            // Store in session
            HttpSession session = request.getSession();
            session.setAttribute("doctorCount", counts.getOrDefault("Doctor", 0));
            session.setAttribute("nurseCount", counts.getOrDefault("Nurse", 0));
            session.setAttribute("doctorList", doctors);
            session.setAttribute("nurseList", nurses);
            
            System.out.println("doc list"+ doctors);
            System.out.println("nurse list" + nurses);
            System.out.println("");

            logger.info("Session attributes set. Redirecting to dashboard.jsp");
            response.sendRedirect("dashboard.jsp");

        } catch (SQLException e) {
            logger.severe("Error while retrieving user stats: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
