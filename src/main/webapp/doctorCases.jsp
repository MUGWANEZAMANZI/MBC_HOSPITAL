<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mbc_hospital.model.DoctorCase" %>
<%@ page import="java.util.List" %>
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
    <title>Doctor Cases</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 10px; border: 1px solid #ddd; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>

    <header class="bg-blue-600 text-white py-4 shadow-md">
        <div class="container mx-auto flex justify-between items-center">
            <h1 class="text-2xl font-bold">Admin Dashboard</h1>
            <div class="flex">            
                <a class="block text-white bg-gray-800 hover:bg-gray-900 focus:outline-none focus:ring-4 focus:ring-gray-300 font-medium rounded-full text-sm px-5 py-2 me-2 dark:bg-gray-800 dark:hover:bg-gray-700 dark:focus:ring-gray-700 dark:border-gray-700" href="dashboard.jsp">Home</a>
                <p class="text-sm px-5 py-2 me-2">Welcome, <span class="font-semibold"><%= session.getAttribute("username") %></span></p>
            </div>
        </div>
    </header>
    <div class="container m-10">
    <h2 class="text-2lx font-bold">Cases Handled by Doctors</h2>
    <%
        @SuppressWarnings("unchecked")
        List<DoctorCase> cases = (List<DoctorCase>) request.getAttribute("cases");
    %>
    <table class="table table-striped table-bordered">
        <thead>
            <tr>
                <th>Doctor ID</th>
                <th>Name</th>
                <th>Hospital</th>
                <th>Diagnosis ID</th>
                <th>Status</th>
                <th>Result</th>
            </tr>
        </thead>
        <tbody>
           <%
    if (cases != null && !cases.isEmpty()) {
        for (DoctorCase dc : cases) {
%>
        <tr>
            <td><%= dc.getDoctorID() %></td>
            <td><%= dc.getFirstName() %> <%= dc.getLastName() %></td>
            <td><%= dc.getHospitalName() %></td>
            <td><%= dc.getDiagnosisID() %></td>
            <td><%= dc.getDiagnoStatus() %></td>
            <td><%= dc.getResult() %></td>
        </tr>
<%
        }
    } else {
%>
        <tr>
            <td colspan="6" style="text-align: center;">No cases available</td>
        </tr>
<%
    }
%>

        </tbody>
    </table>
    </div>
</body>
</html>
