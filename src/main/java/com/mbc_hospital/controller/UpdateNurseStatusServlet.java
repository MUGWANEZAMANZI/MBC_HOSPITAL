package com.mbc_hospital.controller;

import com.mbc_hospital.dao.NurseDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/update-nurse-status")
public class UpdateNurseStatusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String nurseIdStr = req.getParameter("nurseId");
        String status = req.getParameter("status");

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        try {
            int nurseId = Integer.parseInt(nurseIdStr);
            System.out.println("testn id" + nurseId);
            boolean success = NurseDAO.updateStatus(nurseId, status);
            if (success) {
                out.print("{\"success\": true}");
            } else {
                out.print("{\"success\": false, \"error\": \"Update failed\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"Server error\"}");
        }
    }
}
