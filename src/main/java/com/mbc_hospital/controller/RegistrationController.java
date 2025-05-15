package com.mbc_hospital.controller;

import jakarta.servlet.ServletException;
import com.mbc_hospital.model.DBConnection;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/registration")
public class RegistrationController extends HttpServlet {
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		//Get form data
		String username = request.getParameter("uname");
		String password = request.getParameter("pass");
		String userType = request.getParameter("userType");
		
		// Get additional user information
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String telephone = request.getParameter("telephone");
		String email = request.getParameter("email");
		String address = request.getParameter("address");
		String hospitalName = request.getParameter("hospitalName");
		
		System.out.println("User Type: " + userType);
		System.out.println("Username: " + username);
		System.out.println("Password: " + password);
		System.out.println("FirstName: " + firstName);
		System.out.println("LastName: " + lastName);
		System.out.println("Email: " + email);
		
		// Validate required fields
		if (firstName == null || firstName.trim().isEmpty()) {
			System.out.println("First name is required");
			response.sendRedirect("registration.jsp?error=first_name_required");
			return;
		}
		
		if (lastName == null || lastName.trim().isEmpty()) {
			System.out.println("Last name is required");
			response.sendRedirect("registration.jsp?error=last_name_required");
			return;
		}
		
		//Verify username and password
		if(username.length() > 2 && password.length() > 2) {
			try (Connection conn = DBConnection.getConnection()) {
				// Store all data in the Users table
				String sql = "INSERT INTO Users(username, password, userType, FirstName, LastName, Telephone, Email, Address, HospitalName, is_verified) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, false)";
				
				try (PreparedStatement st = conn.prepareStatement(sql)) {
					st.setString(1, username);
					st.setString(2, password);
					st.setString(3, userType);
					st.setString(4, firstName);
					st.setString(5, lastName);
					st.setString(6, telephone != null ? telephone : "");
					st.setString(7, email != null ? email : "");
					st.setString(8, address != null ? address : "");
					st.setString(9, hospitalName != null ? hospitalName : "");
					
					int rows = st.executeUpdate();
					
					if (rows > 0) {
						// Store info in session before redirecting to pending page
						HttpSession session = request.getSession();
						session.setAttribute("pending_username", username);
						session.setAttribute("pending_usertype", userType);
						response.sendRedirect("pending.jsp");
					} else {
						System.out.println("Registration failed");
						response.sendRedirect("registration.jsp?error=failed");
					}
				}
			} catch (SQLException e) {
				e.printStackTrace();
				System.out.println("SQL Error: " + e.getMessage());
				response.sendRedirect("registration.jsp?error=server&message=" + e.getMessage());
			}
		} else {
			System.out.println("Username and password should be 3 characters long");
			response.sendRedirect("registration.jsp?error=validation");
			return;
		}
	}
}
