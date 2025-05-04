package com.mbc_hospital.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.http.HttpSession;

import com.mbc_hospital.model.DBConnection;
import com.mysql.cj.Session;

@WebServlet("/RegisterNurse")
public class RegisterNurse extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String firstname = request.getParameter("firstName");
        String lastname = request.getParameter("lastName");
        String telephone = request.getParameter("telephone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String hospitalName = request.getParameter("hospitalName");
        
        System.out.println("Firstname: " + firstname);
        System.out.println("Lastname: " + lastname);
        System.out.println("Telephone: " + telephone);
        System.out.println("Email: " + email);
        System.out.println("Address: " + address);
        System.out.println("Hospital: " + hospitalName);


        try (Connection conn = DBConnection.getConnection()) {

        	String sql = "INSERT INTO Nurses (FirstName, LastName, Telephone, Email, Address, HealthCenter, RegisteredBy) VALUES (?, ?, ?, ?, ?, ?, ?)";
        	PreparedStatement ps = conn.prepareStatement(sql);
        	ps.setString(1, firstname);
        	ps.setString(2, lastname);
        	ps.setString(3, telephone); // Correct index
        	ps.setString(4, email);
        	ps.setString(5, address);
        	ps.setString(6, hospitalName);
        	ps.setString(7, "admin");

            int rowsInserted = ps.executeUpdate();

            response.setContentType("text/html");
            PrintWriter out = response.getWriter();

            if (rowsInserted > 0) {
                out.println("<script type='text/javascript'>");
                out.println("alert('Nurse Registered Successfully!');");
                out.println("location='doctor.jsp';"); // Change to your target page
                out.println("</script>");
            } else {
                out.println("<script type='text/javascript'>");
                out.println("alert('Registration Failed. Please try again.');");
                out.println("location='register_nurse.jsp';"); // Back to form
                out.println("</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<script type='text/javascript'>");
            response.getWriter().println("alert('Error occurred during registration.' + e);");
//            response.getWriter().println("location='register_nurse.jsp';");
            response.getWriter().println("</script>");
        }
    }
}
