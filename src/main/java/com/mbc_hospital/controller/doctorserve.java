package com.mbc_hospital.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.mbc_hospital.model.Doc;

@WebServlet("/doctorserve")
public class doctorserve extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Simulated doctor data
        List<Doc> doctors = new ArrayList<>();
        doctors.add(new Doc(1, "Dr. Smith", "Cardiology", "Main Hospital"));
        doctors.add(new Doc(2, "Dr. Johnson", "Pediatrics", "Downtown Clinic"));
        doctors.add(new Doc(3, "Dr. Williams", "Neurology", "Westside Medical"));

        // Set the data for JSP
        request.setAttribute("doctors", doctors);

        // Forward to JSP (be careful with the capital "D")
        request.getRequestDispatcher("findDoctor.jsp").forward(request, response);
    }
}
