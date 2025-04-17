<%@ page contentType="text/html;charset=UTF-8" %>
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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen flex flex-col">
    <header class="bg-blue-600 text-white py-4 shadow-md">
        <div class="container mx-auto flex justify-between items-center">
            <h1 class="text-2xl font-bold">Admin Dashboard</h1>
            <p>Welcome, <span class="font-semibold"><%= session.getAttribute("username") %></span></p>
        </div>
    </header>

    <main class="container mx-auto flex-grow mt-8">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <a href="<%= request.getContextPath() %>/register_doctor.jsp" class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition">
                <h2 class="text-xl font-semibold text-blue-600">Register New Doctors</h2>
                <p class="text-gray-600 mt-2">Create doctor accounts with detailed information.</p>
            </a>
            <a href="<%= request.getContextPath() %>/RegisteredDoctorsServlet" class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition">
                <h2 class="text-xl font-semibold text-blue-600">View All Registered Doctors</h2>
                <p class="text-gray-600 mt-2">See a list of all registered doctors.</p>
            </a>
            <a href="<%= request.getContextPath() %>/RegisteredNursesServlet" class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition">
                <h2 class="text-xl font-semibold text-blue-600">View All Registered Nurses</h2>
                <p class="text-gray-600 mt-2">View nurses and their contact information.</p>
            </a>
            <a href="track_cases_nurses.jsp" class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition">
                <h2 class="text-xl font-semibold text-blue-600">Track Cases Registered by Nurses</h2>
                <p class="text-gray-600 mt-2">Monitor patient cases registered by nurses.</p>
            </a>
            <a href="track_cases_doctors.jsp" class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition">
                <h2 class="text-xl font-semibold text-blue-600">Track Cases Handled by Doctors</h2>
                <p class="text-gray-600 mt-2">View statistics of cases handled by doctors.</p>
            </a>
            <a href="<%= request.getContextPath() %>/DiagnosisViewServlet" class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition">
                <h2 class="text-xl font-semibold text-blue-600">Monitor Diagnosis Status</h2>
                <p class="text-gray-600 mt-2">Track diagnosis trends and statuses.</p>
            </a>
            <a href="<%= request.getContextPath() %>/ManageUsersServlet" class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition">
                <h2 class="text-xl font-semibold text-blue-600">Manage Users Table</h2>
                <p class="text-gray-600 mt-2">View and manage user details securely.</p>
            </a>
            <a href="audit_logs.jsp" class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition">
                <h2 class="text-xl font-semibold text-blue-600">Audit Logs</h2>
                <p class="text-gray-600 mt-2">Review activity logs for accountability.</p>
            </a>
            <a href="logout.jsp" class="bg-red-500 text-white p-6 rounded-lg shadow-md hover:bg-red-600 transition">
                <h2 class="text-xl font-semibold">Logout</h2>
                <p class="mt-2">Safely exit the system.</p>
            </a>
        </div>
    </main>

    <footer class="bg-gray-800 text-white py-4 mt-8">
        <div class="container mx-auto text-center">
            <p>&copy; 2023 Patient Management System. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>

