package com.mbc_hospital.controller;
import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Patient;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/patients")
public class PatientController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ArrayList<Patient> patients = new ArrayList<>();

        try {
            
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT p.PatientID, p.FirstName AS PatientFirstName, p.LastName AS PatientLastName, p.Telephone, p.Email, p.Address, p.PImageLink, p.RegisteredBy, n.FirstName AS NurseFirstName, n.LastName AS NurseLastName FROM Patients p JOIN Nurses n ON p.RegisteredBy = n.NurseID";
       PreparedStatement stmt = conn.prepareStatement(sql);
       ResultSet rs = stmt.executeQuery();

       while (rs.next()) {
           Patient patient = new Patient();
           patient.setPatientID(rs.getInt("PatientID"));
           patient.setFirstName(rs.getString("PatientFirstName"));
           patient.setLastName(rs.getString("PatientLastName"));
           patient.setTelephone(rs.getString("Telephone"));
           patient.setEmail(rs.getString("Email"));
           patient.setAddress(rs.getString("Address"));
           patient.setPImageLink(rs.getString("PImageLink"));
           patient.setRegisteredBy(rs.getInt("RegisteredBy"));
           
           // You can create extra fields like `registeredByName` if needed:
           String nurseFullName = rs.getString("NurseFirstName") + " " + rs.getString("NurseLastName");
           request.setAttribute("nurseFullName_" + patient.getPatientID(), nurseFullName);
//           patient.setRegisteredByName(nurseFullName);
           patient.setRegisteredByName("wilson");

           patients.add(patient);
       }

            rs.close();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("patients", patients);
        System.out.println("Total patients fetched: " + patients.size());
        RequestDispatcher dispatcher = request.getRequestDispatcher("Patients.jsp");
        dispatcher.forward(request, response);
    }
}
