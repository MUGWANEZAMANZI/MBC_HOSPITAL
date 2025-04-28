package com.mbc_hospital.controller;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;

import com.mbc_hospital.dao.UserDAO;
import com.mbc_hospital.model.DBConnection;

@WebServlet("/users-directory")
public class UserController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (Connection conn = DBConnection.getConnection()) {
            UserDAO dao = new UserDAO(conn);
            String action = request.getParameter("action");

            if ("delete".equals(action)) {
                int userID = Integer.parseInt(request.getParameter("id"));
                dao.deleteUser(userID);
                response.sendRedirect("users");
                return;
            }

            request.setAttribute("userList", dao.getAllUsers());
            RequestDispatcher dispatcher = request.getRequestDispatcher("userList.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
