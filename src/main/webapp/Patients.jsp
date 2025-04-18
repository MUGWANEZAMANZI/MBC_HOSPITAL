<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.mbc_hospital.model.Patient" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    //HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    
    
    String userType = (String) session.getAttribute("usertype");
    if (userType == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
      // Redirect based on user type

    String[] roles = {"doctor", "nurse", "patient"}; 
    if (userType.toLowerCase().equals(roles[0])) {
        response.sendRedirect("doctor.jsp");
        return;
    } else if (userType.toLowerCase().equals(roles[1])) {
        response.sendRedirect("nurse.jsp");
        return;
    } else if (userType.toLowerCase().equals(roles[2])) {
        response.sendRedirect("patient.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Registered Patients</title>
    <meta charset="UTF-8">
        <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-gray-100 min-h-screen flex flex-col">
<header class="bg-blue-600 text-white py-4 shadow-md">
        <div class="container mx-auto flex justify-between items-center">
            <h1 class="text-2xl font-bold">Admin Dashboard</h1>
            <p>Welcome, <span class="font-semibold"><%= session.getAttribute("username") %></span></p>
        </div>
    </header>
<div class="container mt-5">   
    <h2 class="text-2xl font-bold my-4">Patients Registered by Nurses</h2>
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
 
        </tr>
        <% } %>
        </tbody>
    </table>
</div>
</body>
</html>
