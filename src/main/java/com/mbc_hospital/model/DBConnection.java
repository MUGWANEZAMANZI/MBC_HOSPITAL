package com.mbc_hospital.model;
import java.sql.*;

public class DBConnection {
	private static final String url = "jdbc:mysql://localhost:3306/PMS";
	private static final String user = "root";
	private static final String pass ="468161Ro@";
	
	public static Connection getConnection() {
		Connection con = null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection(url,user,pass);
			
		}catch(ClassNotFoundException | SQLException e) {
			e.printStackTrace();
	
		}
		return con;
	}
	
	
}
