package com.mbc_hospital.controller;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Doctor;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/all-doctors")
public class RegisteredDoctorsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Doctor> doctorsList = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection()) {
            String sql = "SELECT * FROM doctors";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                Doctor doctor = new Doctor();
                doctor.setDoctorId(resultSet.getInt("DoctorID"));
                doctor.setFirstName(resultSet.getString("FirstName"));
                doctor.setLastName(resultSet.getString("LastName"));
                doctor.setTelephone(resultSet.getString("Telephone"));
                doctor.setEmail(resultSet.getString("Email"));
                doctor.setAddress(resultSet.getString("Address"));
                doctor.setHospitalName(resultSet.getString("HospitalName"));
                doctor.setRegisteredBy(resultSet.getString("RegisteredBy"));
                doctorsList.add(doctor);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("doctorsList", doctorsList);
        request.getRequestDispatcher("view_doctors.jsp").forward(request, response);
    }
}
