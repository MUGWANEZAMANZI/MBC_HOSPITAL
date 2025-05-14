package com.mbc_hospital.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Patient;

@WebServlet("/confirmed-cases")
public class ConfirmedCasesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null || !session.getAttribute("usertype").equals("Doctor")) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        List<Patient> confirmedPatients = getConfirmedPatients();
        request.setAttribute("patients", confirmedPatients);
        request.setAttribute("confirmedCasesCount", confirmedPatients.size());
        request.setAttribute("currentPage", "confirmed");
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("confirmed_cases.jsp");
        dispatcher.forward(request, response);
    }
    
    private List<Patient> getConfirmedPatients() {
        List<Patient> patients = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            String query = "SELECT p.*, u.Username as RegisteredByName, d.DiagnosisID, d.DiagnoStatus, d.Result " +
                          "FROM Patients p " +
                          "JOIN Diagnosis d ON p.PatientID = d.PatientID " +
                          "LEFT JOIN Users u ON p.RegisteredBy = u.UserID " +
                          "WHERE d.DiagnoStatus IN ('Positive', 'Negative') " +
                          "ORDER BY d.DiagnosisDate DESC";
            
            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Patient patient = new Patient();
                patient.setPatientID(rs.getInt("PatientID"));
                patient.setFirstName(rs.getString("FirstName"));
                patient.setLastName(rs.getString("LastName"));
                patient.setTelephone(rs.getString("Telephone"));
                patient.setEmail(rs.getString("Email"));
                patient.setAddress(rs.getString("Address"));
                patient.setRegisteredByName(rs.getString("RegisteredByName"));
                patient.setDiagnosisID(rs.getInt("DiagnosisID"));
                patient.setDiagnosisStatus(rs.getString("DiagnoStatus"));
                patient.setDiagnosisResult(rs.getString("Result"));
                
                patients.add(patient);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return patients;
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
} 