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
		
		//Verify form data
		if(username.length() > 2 && password.length() > 2) {
			try ( Connection conn = DBConnection.getConnection()){
				String sql = "INSERT INTO Users(username,password) VALUES(?,?)";
				
				try (PreparedStatement st = conn.prepareStatement(sql)){
					st.setString(1,username);
					st.setString(2, password);
					
					int rows = st.executeUpdate();
					
						if(rows > 0) {
							HttpSession session = request.getSession();
							session.setAttribute("username", username);
							session.setAttribute("usertype", "admin");
							response.sendRedirect("dashboard.jsp");
							
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
