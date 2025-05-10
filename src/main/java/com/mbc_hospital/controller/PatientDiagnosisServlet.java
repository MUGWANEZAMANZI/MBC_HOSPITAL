package com.mbc_hospital.controller;

import com.mbc_hospital.dao.PatientDiagnosisDAO;
import com.mbc_hospital.model.Patient;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/patients-dir")
public class PatientDiagnosisServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            PatientDiagnosisDAO dao = new PatientDiagnosisDAO();
            List<Patient> patients = dao.getAllPatientDiagnoses();

            request.setAttribute("patients", patients);
            System.out.println(patients);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/all_patients.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Database error while fetching patient diagnoses", e);
        }
    }
}
