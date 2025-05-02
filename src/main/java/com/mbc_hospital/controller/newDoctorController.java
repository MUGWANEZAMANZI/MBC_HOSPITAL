package com.mbc_hospital.controller;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Doctor;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/new-doctor")
public class newDoctorController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	Doctor doctor = new Doctor();
    	doctor.setFirstName(request.getParameter("firstName"));
    	doctor.setLastName(request.getParameter("lastName"));
    	doctor.setTelephone(request.getParameter("telephone"));
    	doctor.setEmail(request.getParameter("email"));
    	doctor.setAddress(request.getParameter("address"));
    	doctor.setHospitalName(request.getParameter("healthCenter"));

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO Doctors (FirstName, LastName, Telephone, Email, Address, HospitalName, RegisteredBy) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, doctor.getFirstName());
            stmt.setString(2, doctor.getLastName());
            stmt.setString(3, doctor.getTelephone());
            stmt.setString(4, doctor.getEmail());
            stmt.setString(5, doctor.getAddress());
            stmt.setString(6, doctor.getHospitalName());
            stmt.setString(7, "admin");

            stmt.executeUpdate();
            response.sendRedirect(request.getContextPath() + "/doctors-dir");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to register nurse");
            request.getRequestDispatcher("register-nurse.jsp").forward(request, response);
        }

        System.out.println(doctor);
    }
}
