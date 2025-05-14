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
		
		//doGet(request, response);
		//Get form data
		String username = request.getParameter("uname");
		String password = request.getParameter("pass");
		String userType= request.getParameter("userType");
		
		System.out.println("User Type: " + userType);
		System.out.println("Username: " + username);
		System.out.println("Password: " + password);
		System.out.println("UserType: " + userType);


		
		//Verify form data
		if(username.length() > 2 && password.length() > 2) {
			try ( Connection conn = DBConnection.getConnection()){
				String sql = "INSERT INTO Users(username,password, userType, is_verified) VALUES(?,?,?,false)";
				
				System.out.println("Username: " + username);
				System.out.println("Password: " + password);
				System.out.println("UserType: " + userType);

				
				try (PreparedStatement st = conn.prepareStatement(sql)){
					st.setString(1,username);
					st.setString(2, password);
					st.setString(3, userType);


					
					int rows = st.executeUpdate();
					
						if(rows > 0) {
							// Store info in session before redirecting to pending page
							HttpSession session = request.getSession();
							session.setAttribute("pending_username", username);
							session.setAttribute("pending_usertype", userType);
							response.sendRedirect("pending.jsp");
							
						}else {
							System.out.println("Registration failed");		
				}
				
			}
			
		}catch (SQLException e) {
			e.printStackTrace();
			response.sendRedirect("registration.jsp?error=server");
		}
			
		}
		else {
			System.out.println("USername and password should be 3 characters long");
			return;
		}
		
	}

}
