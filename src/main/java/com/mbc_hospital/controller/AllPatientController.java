package com.mbc_hospital.controller;

import com.mbc_hospital.dao.PatientDAO;
import com.mbc_hospital.model.Patient;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/all-patients")
public class AllPatientController extends HttpServlet {

    private PatientDAO patientDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        patientDAO = new PatientDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Fetch all patients using PatientDAO
            List<Patient> patients = patientDAO.getAllPatients();

            // Set the list of patients as an attribute in the request
            request.setAttribute("patients", patients);

            // Forward the request to the all-patients.jsp page to display the patients
            request.getRequestDispatcher("/all-patients.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error fetching patient data", e);
        }
    }
}
