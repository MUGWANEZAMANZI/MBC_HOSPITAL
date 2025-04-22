package com.mbc_hospital.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.mbc_hospital.model.DBConnection;

@WebServlet("/NurseDashboardController")
public class NurseDashboardController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        int registeredPatients = 0;
        int referrableCases = 0;
        int nonReferrableCases = 0;
        int patientResults = 0;

        try {
            conn = DBConnection.getConnection();

            // Query to get the total number of registered patients
            String registeredPatientsSQL = "SELECT COUNT(*) FROM Patients";
            stmt = conn.prepareStatement(registeredPatientsSQL);
            rs = stmt.executeQuery();
            if (rs.next()) {
                registeredPatients = rs.getInt(1);
            }

            // Query to get the total number of referrable cases
            String referrableCasesSQL = "SELECT COUNT(*) FROM Diagnosis WHERE DiagnoStatus = 'Confirmed'";
            stmt = conn.prepareStatement(referrableCasesSQL);
            rs = stmt.executeQuery();
            if (rs.next()) {
                referrableCases = rs.getInt(1);
            }

            // Query to get the total number of non-referrable cases
            String nonReferrableCasesSQL = "SELECT COUNT(*) FROM Diagnosis WHERE DiagnoStatus = 'Confirmed'";
            stmt = conn.prepareStatement(nonReferrableCasesSQL);
            rs = stmt.executeQuery();
            if (rs.next()) {
                nonReferrableCases = rs.getInt(1);
            }

            // Query to get the total number of patients with finalized results
            String patientResultsSQL = "SELECT COUNT(*) FROM Diagnosis WHERE Result = 'Confirmed'";
            stmt = conn.prepareStatement(patientResultsSQL);
            rs = stmt.executeQuery();
            if (rs.next()) {
                patientResults = rs.getInt(1);
            }

            // Set the attributes to pass to the JSP
            request.setAttribute("registeredPatients", registeredPatients);
            request.setAttribute("referrableCases", referrableCases);
            request.setAttribute("nonReferrableCases", nonReferrableCases);
            request.setAttribute("patientResults", patientResults);

            // Forward the request to the JSP
            request.getRequestDispatcher("nurse.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error fetching nurse dashboard data", e);
        } finally {
            // Clean up resources
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}
