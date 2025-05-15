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
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

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
				// Set autocommit to false for transaction
				conn.setAutoCommit(false);
				
				// Insert into Users table first and get the generated user ID
				String userSql = "INSERT INTO Users(username, password, userType, is_verified) VALUES(?, ?, ?, false)";
				
				int userId = -1;
				try (PreparedStatement st = conn.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS)) {
					st.setString(1, username);
					st.setString(2, password);
					st.setString(3, userType);
					
					int rows = st.executeUpdate();
					
					if (rows > 0) {
						// Get the generated user ID
						try (ResultSet generatedKeys = st.getGeneratedKeys()) {
							if (generatedKeys.next()) {
								userId = generatedKeys.getInt(1);
							}
						}
						
						// Now insert additional profile information based on userType
						boolean profileInserted = false;
						
						if (userId > 0) {
							PreparedStatement profileSt = null;
							
							try {
								if ("Patient".equalsIgnoreCase(userType)) {
									String profileSql = "INSERT INTO Patients (FirstName, LastName, Telephone, Email, Address, RegisteredBy, UserID) VALUES (?, ?, ?, ?, ?, ?, ?)";
									profileSt = conn.prepareStatement(profileSql);
									profileSt.setString(1, firstName);
									profileSt.setString(2, lastName);
									profileSt.setString(3, telephone != null ? telephone : "");
									profileSt.setString(4, email != null ? email : "");
									profileSt.setString(5, address != null ? address : "");
									profileSt.setString(6, "system");
									profileSt.setInt(7, userId);
								} else if ("Doctor".equalsIgnoreCase(userType)) {
									String profileSql = "INSERT INTO Doctors (FirstName, LastName, Telephone, Email, Address, HospitalName, RegisteredBy, UserID) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
									profileSt = conn.prepareStatement(profileSql);
									profileSt.setString(1, firstName);
									profileSt.setString(2, lastName);
									profileSt.setString(3, telephone != null ? telephone : "");
									profileSt.setString(4, email != null ? email : "");
									profileSt.setString(5, address != null ? address : "");
									profileSt.setString(6, hospitalName != null ? hospitalName : "");
									profileSt.setString(7, "system");
									profileSt.setInt(8, userId);
								} else if ("Nurse".equalsIgnoreCase(userType)) {
									String profileSql = "INSERT INTO Nurses (FirstName, LastName, Telephone, Email, Address, HealthCenter, RegisteredBy, UserID) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
									profileSt = conn.prepareStatement(profileSql);
									profileSt.setString(1, firstName);
									profileSt.setString(2, lastName);
									profileSt.setString(3, telephone != null ? telephone : "");
									profileSt.setString(4, email != null ? email : "");
									profileSt.setString(5, address != null ? address : "");
									profileSt.setString(6, hospitalName != null ? hospitalName : "");
									profileSt.setString(7, "system");
									profileSt.setInt(8, userId);
								}
								
								if (profileSt != null) {
									profileInserted = profileSt.executeUpdate() > 0;
								}
							} finally {
								if (profileSt != null) {
									profileSt.close();
								}
							}
						}
						
						if (profileInserted) {
							// Commit the transaction if successful
							conn.commit();
							
							// Store info in session before redirecting to pending page
							HttpSession session = request.getSession();
							session.setAttribute("pending_username", username);
							session.setAttribute("pending_usertype", userType);
							response.sendRedirect("pending.jsp");
						} else {
							// Roll back if profile insertion failed
							conn.rollback();
							System.out.println("Profile creation failed");
							response.sendRedirect("registration.jsp?error=profile_creation_failed");
						}
					} else {
						conn.rollback();
						System.out.println("Registration failed");
						response.sendRedirect("registration.jsp?error=failed");
					}
				} catch (SQLException e) {
					// Rollback on error
					try {
						conn.rollback();
					} catch (SQLException ex) {
						ex.printStackTrace();
					}
					e.printStackTrace();
					System.out.println("SQL Error: " + e.getMessage());
					response.sendRedirect("registration.jsp?error=server");
				}
			} catch (SQLException e) {
				e.printStackTrace();
				System.out.println("Connection Error: " + e.getMessage());
				response.sendRedirect("registration.jsp?error=server");
			}
		} else {
			System.out.println("Username and password should be 3 characters long");
			response.sendRedirect("registration.jsp?error=validation");
			return;
		}
	}
}
