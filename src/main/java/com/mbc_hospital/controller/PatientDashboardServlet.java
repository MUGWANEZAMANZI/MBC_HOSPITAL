package com.mbc_hospital.controller;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

@WebServlet("/patientdashboard")
public class PatientDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("Starting PatientDashboardServlet...");

        Integer userId = (Integer) request.getSession().getAttribute("id");
        System.out.println("Retrieved userID from session: " + userId);

        if (userId == null) {
            System.out.println("User is not logged in. Redirecting to login page...");
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            System.out.println("Database connection established.");

            String sql = """
                SELECT p.*, d.DiagnoStatus, d.Result
                FROM Patients p
                LEFT JOIN Diagnosis d ON p.PatientID = d.PatientID
                WHERE p.PatientID = ?
            """;
            System.out.println("Executing SQL query: " + sql);

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            System.out.println("Prepared statement set with userID: " + userId);

            ResultSet rs = ps.executeQuery();
            System.out.println("Query executed. Processing result set...");

            if (rs.next()) {
                System.out.println("Patient data found. Populating Patient object...");
                Patient patient = new Patient();
                patient.setPatientID(rs.getInt("PatientID"));
                patient.setFirstName(rs.getString("FirstName"));
                patient.setLastName(rs.getString("LastName"));
                patient.setTelephone(rs.getString("Telephone"));
                patient.setEmail(rs.getString("Email"));
                patient.setAddress(rs.getString("Address"));
                patient.setStatus(rs.getString("DiagnoStatus"));
                patient.setResult(rs.getString("Result"));

                System.out.println("Patient object populated: " + patient.getFirstName() + " " + patient.getLastName());

                request.setAttribute("patient", patient);
                System.out.println("Patient object set as request attribute. Forwarding to dashboard.jsp...");
                request.getRequestDispatcher("patientdashboard.jsp").forward(request, response);
            } else {
                System.out.println("No patient data found for userID: " + userId);
                response.getWriter().println("Patient not found.");
            }

        } catch (Exception e) {
            System.out.println("An error occurred while processing the request.");
            e.printStackTrace();
            response.getWriter().println("Database error.");
        }

        System.out.println("PatientDashboardServlet processing completed.");
    }
}
