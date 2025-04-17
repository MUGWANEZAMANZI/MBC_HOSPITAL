<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.mbc_hospital.model.Patient" %>
<!DOCTYPE html>
<html>
<head>
    <title>Registered Patients</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h2>Patients Registered by Nurses</h2>
    <table class="table table-striped table-bordered">
        <thead>
        <tr>
            <th>ID</th>
            <th>Full Name</th>
            <th>Telephone</th>
            <th>Email</th>
            <th>Address</th>
            <th>Registered By (Nurse ID)</th>
        </tr>
        </thead>
        <tbody>
        <%
            List<Patient> patients = (List<Patient>) request.getAttribute("patients");
            if (patients != null) {
                for (Patient p : patients) {
        %>
        <tr>
            <td><%= p.getPatientID() %></td>
            <td><%= p.getFirstName() + " " + p.getLastName() %></td>
            <td><%= p.getTelephone() %></td>
            <td><%= p.getEmail() %></td>
            <td><%= p.getAddress() %></td>
            <td><%= p.getRegisteredByName() %></td>
            
        </tr>
        <%
                }
            } else {
        %>
        <tr>
            <td colspan="6" class="text-center text-danger">No patients found or failed to load data.</td>
            <td><%= patients %></td>
 
        </tr>
        <% } %>
        </tbody>
    </table>
</div>
</body>
</html>
