package com.mbc_hospital.controller;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Patient;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/patients")
public class PatientController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ArrayList<Patient> patients = new ArrayList<>();
        System.out.println("🚀 PatientController: doGet triggered...");
        
        // Get session and user info
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String userType = (String) session.getAttribute("usertype");
        int userId = (Integer) session.getAttribute("id");
        
        System.out.println("User type: " + userType);
        System.out.println("User ID: " + userId);
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql;
            
            // Different SQL query based on user role
            if ("Nurse".equalsIgnoreCase(userType)) {
                // Nurses should only see patients they registered
                sql = "SELECT p.PatientID, p.FirstName AS PatientFirstName, p.LastName AS PatientLastName, " +
                      "p.Telephone, p.Email, p.Address, p.PImageLink, p.RegisteredBy, " +
                      "u.Username AS RegisteredByUsername " +
                      "FROM Patients p " +
                      "JOIN Users u ON p.RegisteredBy = u.UserID " +
                      "WHERE p.RegisteredBy = ?";
                
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, userId);
            } else if ("Doctor".equalsIgnoreCase(userType)) {
                // Doctors should see patients from their hospital (simplified version)
                sql = "SELECT p.PatientID, p.FirstName AS PatientFirstName, p.LastName AS PatientLastName, " +
                      "p.Telephone, p.Email, p.Address, p.PImageLink, p.RegisteredBy, " +
                      "u.Username AS RegisteredByUsername " +
                      "FROM Patients p " +
                      "JOIN Users u ON p.RegisteredBy = u.UserID " +
                      "JOIN Nurses n ON u.UserID = n.NurseId " +
                      "JOIN Doctors d ON d.DoctorId = ? " +
                      "WHERE n.HealthCenter = d.HospitalName";
                
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, userId);
            } else {
                // Admin or other users see all patients
                sql = "SELECT p.PatientID, p.FirstName AS PatientFirstName, p.LastName AS PatientLastName, " +
                      "p.Telephone, p.Email, p.Address, p.PImageLink, p.RegisteredBy, " +
                      "u.Username AS RegisteredByUsername " +
                      "FROM Patients p " +
                      "JOIN Users u ON p.RegisteredBy = u.UserID " +
                      "WHERE u.UserType = 'Nurse'";
                
                stmt = conn.prepareStatement(sql);
            }

            rs = stmt.executeQuery();

            while (rs.next()) {
                Patient patient = new Patient();
                patient.setPatientID(rs.getInt("PatientID"));
                patient.setFirstName(rs.getString("PatientFirstName"));
                patient.setLastName(rs.getString("PatientLastName"));
                patient.setTelephone(rs.getString("Telephone"));
                patient.setEmail(rs.getString("Email"));
                patient.setAddress(rs.getString("Address"));
                patient.setImageLink(rs.getString("PImageLink"));
                patient.setRegisteredBy(rs.getInt("RegisteredBy"));

                String username = rs.getString("RegisteredByUsername");
                patient.setRegisteredByName(username);

                patients.add(patient);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        System.out.println("Found " + patients.size() + " patients");
        request.setAttribute("patients", patients);
        RequestDispatcher dispatcher = request.getRequestDispatcher("Patients.jsp");
        dispatcher.forward(request, response);
    }
}
