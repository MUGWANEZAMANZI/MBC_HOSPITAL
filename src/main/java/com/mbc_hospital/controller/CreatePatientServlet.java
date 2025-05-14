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
import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/CreatePatientServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // Limit: 5MB
public class CreatePatientServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement stmt = null;
        
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
            String imageDbPath = null;

            if (filePart != null && filePart.getSize() > 0) {
                // Create a unique filename to prevent collisions
                fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                
                // Create the images directory if it doesn't exist
                String imagesPath = getServletContext().getRealPath("/") + "images";
                File imagesDir = new File(imagesPath);
                if (!imagesDir.exists()) {
                    imagesDir.mkdirs();
                }
                
                // Write the file to the images directory
                filePart.write(imagesPath + File.separator + fileName);
                
                // Set the database path - only storing the URL, not the actual image
                imageDbPath = "images/" + fileName;
            }

            // Store in DB
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO Patients (FirstName, LastName, Telephone, Email, Address, RegisteredBy, PImageLink) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, firstName);
            stmt.setString(2, lastName);
            stmt.setString(3, telephone);
            stmt.setString(4, email);
            stmt.setString(5, address);
            stmt.setInt(6, registeredBy);
            stmt.setString(7, imageDbPath); // Store the URL path, not the actual image

            stmt.executeUpdate();

            response.sendRedirect("patients-dir");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("nurse_dashboard.jsp?error=creation_failed");
        } finally {
            // Properly close resources
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
