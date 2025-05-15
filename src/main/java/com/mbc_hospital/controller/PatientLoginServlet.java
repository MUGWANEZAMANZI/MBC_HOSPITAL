package com.mbc_hospital.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Diagnosis;
import com.mbc_hospital.model.Patient;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/patient-login")
public class PatientLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirect to login page if accessed directly
        response.sendRedirect("patient_login.jsp");
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String telephone = request.getParameter("telephone");
        String patientIDStr = request.getParameter("patientID");
        
        // Validate input
        if (telephone == null || telephone.trim().isEmpty() || patientIDStr == null || patientIDStr.trim().isEmpty()) {
            response.sendRedirect("patient_login.jsp?error=missing");
            return;
        }
        
        int patientID;
        try {
            patientID = Integer.parseInt(patientIDStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("patient_login.jsp?error=invalid");
            return;
        }
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Verify patient credentials - Use correct table and column names
            String sql = "SELECT * FROM Patients WHERE PatientID = ? AND Telephone = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, patientID);
            stmt.setString(2, telephone);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                // Patient found, create patient object
                Patient patient = new Patient();
                patient.setPatientID(rs.getInt("PatientID"));
                patient.setFirstName(rs.getString("FirstName"));
                patient.setLastName(rs.getString("LastName"));
                patient.setTelephone(rs.getString("Telephone"));
                patient.setEmail(rs.getString("Email"));
                patient.setAddress(rs.getString("Address"));
                patient.setRegistrationDate(rs.getString("RegistrationDate"));
                
                // Create session and set attributes
                HttpSession session = request.getSession();
                session.setAttribute("patient", patient);
                session.setAttribute("usertype", "patient");
                session.setAttribute("patientID", patient.getPatientID());
                
                // Get patient diagnoses
                List<Diagnosis> patientDiagnoses = getPatientDiagnoses(conn, patientID);
                request.setAttribute("patientDiagnoses", patientDiagnoses);
                
                // Forward to dashboard
                RequestDispatcher dispatcher = request.getRequestDispatcher("patient_dashboard.jsp");
                dispatcher.forward(request, response);
            } else {
                // Invalid credentials
                response.sendRedirect("patient_login.jsp?error=invalid");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("patient_login.jsp?error=database");
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    private List<Diagnosis> getPatientDiagnoses(Connection conn, int patientID) throws SQLException {
        List<Diagnosis> diagnoses = new ArrayList<>();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            // Use correct table and column names
            String sql = "SELECT d.*, CONCAT(u.FirstName, ' ', u.LastName) as doctor_name " +
                         "FROM Diagnosis d " +
                         "LEFT JOIN Users u ON d.DoctorID = u.UserID " +
                         "WHERE d.PatientID = ? " +
                         "ORDER BY d.DiagnosisDate DESC";
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, patientID);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                // Create Diagnosis object using constructor
                Diagnosis diagnosis = new Diagnosis(
                    rs.getInt("DiagnosisID"),
                    rs.getInt("PatientID"),
                    rs.getInt("NurseID"),
                    rs.getInt("DoctorID"),
                    rs.getString("DiagnoStatus"), // Note: Column name is DiagnoStatus, not Status
                    rs.getString("Result"),
                    rs.getString("MedicationsPrescribed"),
                    rs.getDate("FollowUpDate"),
                    rs.getTimestamp("DiagnosisDate"),
                    rs.getString("NurseAssessment")
                );
                
                // Add doctor name as a temporary attribute
                // Since there's no setter for doctorName, we'll handle it in the JSP
                
                diagnoses.add(diagnosis);
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        }
        
        return diagnoses;
    }
} 