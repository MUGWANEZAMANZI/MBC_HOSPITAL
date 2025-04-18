package com.mbc_hospital.controller;

import com.mbc_hospital.model.Schedule;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/schedule")
public class ScheduleController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String patientName = request.getParameter("patientName");
        String email = request.getParameter("email");
        String appointmentType = request.getParameter("appointmentType");
        String doctor = request.getParameter("doctor");
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        String reason = request.getParameter("reason");

        Schedule schedule = new Schedule(patientName, email, appointmentType, doctor, date, time, reason);

        // Save to DB here (optional)

        request.setAttribute("message", "Appointment scheduled successfully!");
        request.setAttribute("schedule", schedule);
        request.getRequestDispatcher("findDoctor.jsp").forward(request, response);
    }
}
