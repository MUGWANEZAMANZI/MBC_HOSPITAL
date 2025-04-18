package com.mbc_hospital.controller;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.DoctorCase;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/doctor-cases")
public class DoctorCaseController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ArrayList<DoctorCase> caseList = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT d.DoctorID, d.FirstName, d.LastName, d.HospitalName, diag.DiagnosisID, diag.DiagnoStatus, diag.Result " +
                         "FROM Doctors d " +
                         "JOIN Diagnosis diag ON d.DoctorID = diag.DoctorID";

            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                DoctorCase dc = new DoctorCase();
                dc.setDoctorID(rs.getInt("DoctorID"));
                dc.setFirstName(rs.getString("FirstName"));
                dc.setLastName(rs.getString("LastName"));
                dc.setHospitalName(rs.getString("HospitalName"));
                dc.setDiagnosisID(rs.getInt("DiagnosisID"));
                dc.setDiagnoStatus(rs.getString("DiagnoStatus"));
                dc.setResult(rs.getString("Result"));

                caseList.add(dc);
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("cases", caseList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("doctorCases.jsp");
        dispatcher.forward(request, response);
    }
}
