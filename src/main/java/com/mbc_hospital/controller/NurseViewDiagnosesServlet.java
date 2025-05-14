package com.mbc_hospital.controller;

import com.mbc_hospital.dao.PatientDiagnosisDAO;
import com.mbc_hospital.model.Patient;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/nurse-view-diagnoses")
public class NurseViewDiagnosesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            PatientDiagnosisDAO dao = new PatientDiagnosisDAO();
            List<Patient> completedDiagnoses = dao.getCompletedDiagnoses();

            request.setAttribute("completedDiagnoses", completedDiagnoses);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/nurse_view_diagnoses.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Database error while fetching completed diagnoses", e);
        }
    }
} 