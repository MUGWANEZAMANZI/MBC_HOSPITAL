package com.mbc_hospital.controller;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Doctor;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

@WebServlet("/doctors-dir")
public class DoctorController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ArrayList<Doctor> doctors = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM Doctors";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Doctor doc = new Doctor();
                doc.setDoctorId(rs.getInt("DoctorID"));
                doc.setFirstName(rs.getString("FirstName"));
                doc.setLastName(rs.getString("LastName"));
                doc.setTelephone(rs.getString("Telephone"));
                doc.setEmail(rs.getString("Email"));
                doc.setAddress(rs.getString("Address"));
                doc.setHospitalName(rs.getString("HospitalName"));
                doc.setRegisteredBy(rs.getString("RegisteredBy"));
                doc.setStatus(rs.getString("status"));
                doctors.add(doc);
            }
            request.setAttribute("doctorCount", doctors.size());
            request.setAttribute("doctors", doctors);
            System.out.println(doctors);
            request.getRequestDispatcher("view_doctors.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to load doctors list");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
