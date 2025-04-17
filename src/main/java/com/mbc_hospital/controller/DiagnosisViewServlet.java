package com.mbc_hospital.controller;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Diagnosis;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/DiagnosisViewServlet")
public class DiagnosisViewServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Diagnosis> diagnosisList = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM diagnosis";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int diagnosisId = rs.getInt("DiagnosisID");
                int patientId = rs.getInt("PatientID");
                int nurseId = rs.getInt("NurseID");
                int doctorId = rs.getInt("DoctorID");
                String status = rs.getString("DiagnoStatus");
                String result = rs.getString("Result");

                diagnosisList.add(new Diagnosis(diagnosisId, patientId, nurseId, doctorId, status, result));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("diagnosisList", diagnosisList);
        request.getRequestDispatcher("diagnosis_view.jsp").forward(request, response);
    }
}
