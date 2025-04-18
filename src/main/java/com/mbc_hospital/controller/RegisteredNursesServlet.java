package com.mbc_hospital.controller;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Nurse;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/RegisteredNursesServlet")
public class RegisteredNursesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Nurse> nurseList = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection()) {
            String sql = "SELECT * FROM nurses";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery();
            
            System.out.println(resultSet);

            while (resultSet.next()) {
                Nurse nurse = new Nurse();
                nurse.setNurseId(resultSet.getInt("NurseID"));
                nurse.setFirstName(resultSet.getString("FirstName"));
                nurse.setLastName(resultSet.getString("LastName"));
                nurse.setTelephone(resultSet.getString("Telephone"));
                nurse.setEmail(resultSet.getString("Email"));
                nurse.setAddress(resultSet.getString("Address"));
                nurse.setHealthCenter(resultSet.getString("HealthCenter"));
                nurse.setRegisteredBy(resultSet.getInt("RegisteredBy"));

                nurseList.add(nurse);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("nurseList", nurseList);
        request.getRequestDispatcher("view_nurse.jsp").forward(request, response);
    }
}
