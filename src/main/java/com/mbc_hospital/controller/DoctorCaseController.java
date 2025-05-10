package com.mbc_hospital.controller;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Patient;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/patients-by-doc")
public class DoctorCaseController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ArrayList<Patient> patients = new ArrayList<>();
        System.out.println("🚀 PatientController: doGet triggered...");
        System.out.print("patients "+ patients);


       

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT p.PatientID, p.FirstName AS PatientFirstName, p.LastName AS PatientLastName, " +
                         "p.Telephone, p.Email, p.Address, p.PImageLink, p.RegisteredBy, " +
                         "u.Username AS RegisteredByUsername " +
                         "FROM Patients p " +
                         "JOIN Users u ON p.RegisteredBy = u.UserID " +
                         "WHERE u.UserType = 'Doctor'";

            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Patient patient = new Patient();
                patient.setPatientID(rs.getInt("PatientID"));
                patient.setFirstName(rs.getString("PatientFirstName"));
                patient.setLastName(rs.getString("PatientLastName"));
                patient.setTelephone(rs.getString("Telephone"));
                patient.setEmail(rs.getString("Email"));
                patient.setAddress(rs.getString("Address"));
                patient.setPImageLink(rs.getString("PImageLink"));
                patient.setRegisteredBy(rs.getInt("RegisteredBy"));

                String username = rs.getString("RegisteredByUsername");
                patient.setRegisteredByName(username);

                patients.add(patient);
            }

            rs.close();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.print("patients "+ patients);
        request.setAttribute("patients-doc", patients);
        RequestDispatcher dispatcher = request.getRequestDispatcher("doctorCases.jsp");
        dispatcher.forward(request, response);
    }
}
