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

        String nurseId = request.getParameter("nurseId");
        String firstname = request.getParameter("firstName");
        String lastname = request.getParameter("lastName");
        String telephone = request.getParameter("telephone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String hospitalName = request.getParameter("hospitalName");


        try (Connection conn = DBConnection.getConnection()) {

            String sql = "INSERT INTO nurses (NurseID, FirstName, LastName, Telephone, Email, Address, HealthCenter, RegisteredBy) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, nurseId);
            ps.setString(2, firstname);
            ps.setString(3, lastname);
            ps.setString(4, telephone);
            ps.setString(5, email);
            ps.setString(6, address);
            ps.setString(7, hospitalName);

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
            response.getWriter().println("alert('Error occurred during registration.');");
            response.getWriter().println("location='register_nurse.jsp';");
            response.getWriter().println("</script>");
        }
    }
}
