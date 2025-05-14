package com.mbc_hospital.controller;

import com.mbc_hospital.dao.Doctor_diagnosis_dao;
import com.mbc_hospital.model.Patient;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/reffered")
public class DoctorDiagnosisController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
        	Doctor_diagnosis_dao dao = new Doctor_diagnosis_dao();
            List<Patient> patients = dao.getAllPatientDiagnoses();
            
            System.out.println(patients);


            request.setAttribute("patients", patients);
            System.out.println(patients);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/doctor.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Database error while fetching patient diagnoses", e);
        }
    }
}
