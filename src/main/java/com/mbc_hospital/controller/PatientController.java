package com.mbc_hospital.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.mbc_hospital.model.DBConnection;
import com.mysql.cj.xdevapi.Statement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/PatientController")
@MultipartConfig
public class PatientController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("registerPatient".equals(action)) {
            registerPatient(request, response);
        }
    }

    private void registerPatient(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        //HttpSession session = request.getSession();
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            // Optionally redirect to login page or show an error
            response.sendRedirect("login.jsp");
            return;
        }

        int registeredBy = (Integer) session.getAttribute("id");
        //int registeredBy = (int) session.getAttribute("id"); // Assumes user is logged in

        // Retrieve form fields
        String username = request.getParameter("username");
        String password = request.getParameter("password"); // Ideally hash this
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String telephone = request.getParameter("telephone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        
        Part filePart = request.getPart("pImage");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
        Files.createDirectories(Paths.get(uploadPath));
        filePart.write(uploadPath + File.separator + fileName);
        String imagePath = "images/" + fileName;

        Connection conn = null;
        PreparedStatement userStmt = null;
        PreparedStatement patientStmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Insert into Users table
            String userSQL = "INSERT INTO Users (Username, Password, UserType) VALUES (?, ?, ?)";
            userStmt = conn.prepareStatement(userSQL, PreparedStatement.RETURN_GENERATED_KEYS);
            userStmt.setString(1, username);
            userStmt.setString(2, password); // Add hash function
            userStmt.setString(3, "Patient");
            userStmt.executeUpdate();

            rs = userStmt.getGeneratedKeys();
            int userID = 0;
            if (rs.next()) {
                userID = rs.getInt(1);
            }

            // Insert into Patient table
            String patientSQL = "INSERT INTO Patients (PatientID, FirstName, LastName, Telephone, Email, Address, PImageLink, RegisteredBy) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            patientStmt = conn.prepareStatement(patientSQL);
            patientStmt.setInt(1, userID);
            patientStmt.setString(2, firstName);
            patientStmt.setString(3, lastName);
            patientStmt.setString(4, telephone);
            patientStmt.setString(5, email);
            patientStmt.setString(6, address);
            patientStmt.setString(7, imagePath);
            patientStmt.setInt(8, registeredBy);

            patientStmt.executeUpdate();

            conn.commit();
            response.sendRedirect("nurse.jsp");

        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (Exception ex) {}
            throw new ServletException("Registration failed", e);
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (userStmt != null) try { userStmt.close(); } catch (Exception e) {}
            if (patientStmt != null) try { patientStmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (Exception e) {}
        }
    }
}
