package com.mbc_hospital.controller;

import com.mbc_hospital.model.Patient;
import com.mbc_hospital.model.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/CreatePatientServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // Limit: 5MB
public class CreatePatientServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Retrieve form fields
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String telephone = request.getParameter("telephone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            int registeredBy = Integer.parseInt(request.getParameter("registeredBy"));


            // Handle uploaded image
            Part filePart = request.getPart("pImageLink");
            String fileName = null;

            if (filePart != null && filePart.getSize() > 0) {
                fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("/") + "uploads";
                filePart.write(uploadPath + "/" + fileName);
            }

            // Store in DB
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO Patients (FirstName, LastName, Telephone, Email, Address, RegisteredBy) " +
                         "VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, firstName);
            stmt.setString(2, lastName);
            stmt.setString(3, telephone);
            stmt.setString(4, email);
            stmt.setString(5, address);
            stmt.setInt(6, registeredBy);

            stmt.executeUpdate();

            response.sendRedirect("patients-dir");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("nurse_dashboard.jsp?error=creation_failed");
        }
    }
}
