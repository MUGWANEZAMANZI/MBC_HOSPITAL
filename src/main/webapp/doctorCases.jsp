<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mbc_hospital.model.DoctorCase" %>
<%@ page import="java.util.List" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    // Session validation
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
    
    // Get cases data
    @SuppressWarnings("unchecked")
    List<DoctorCase> cases = (List<DoctorCase>) request.getAttribute("cases");
    int caseCount = (cases != null) ? cases.size() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Cases</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
</head>
<body class="bg-white min-h-screen flex flex-col">
    <header class="bg-blue-700 text-white py-4 px-6 shadow-lg">
        <div class="container mx-auto flex justify-between items-center">
            <div class="flex items-center space-x-2">
                <i class="fas fa-hospital text-2xl"></i>
                <h1 class="text-2xl font-bold">MBC HOSPITAL</h1>
            </div>
            <div class="flex items-center space-x-3">
                <a class="flex items-center px-4 py-2 bg-blue-800 hover:bg-blue-900 rounded-md transition" 
                   href="dashboard.jsp">
                    <i class="fas fa-home mr-2"></i>Home
                </a>
                <div class="flex items-center space-x-2">
                    <i class="fas fa-user-circle"></i>
                    <p>Welcome, <span class="font-semibold"><%= session.getAttribute("username") %></span></p>
                </div>
            </div>
        </div>
    </header>

    <main class="container mx-auto p-6 flex-grow">
        <div class="bg-white rounded-lg shadow-md p-6 mb-6 border border-blue-100">
            <div class="flex flex-col md:flex-row md:justify-between md:items-center mb-6">
                <h2 class="text-2xl font-bold text-blue-800 mb-4 md:mb-0 flex items-center">
                    <i class="fas fa-stethoscope text-blue-600 mr-2"></i>
                    Cases Handled by Doctors
                </h2>
                
                <div class="bg-blue-50 border border-blue-100 rounded-lg p-4 flex items-center">
                    <div class="bg-blue-100 p-3 rounded-full mr-4">
                        <i class="fas fa-clipboard-list text-blue-600 text-xl"></i>
                    </div>
                    <div>
                        <h5 class="text-sm font-medium text-blue-600">TOTAL CASES</h5>
                        <p class="text-2xl font-bold text-blue-700"><%= caseCount %></p>
                    </div>
                </div>
            </div>

            <div class="overflow-x-auto rounded-lg border border-blue-100">
                <table class="w-full border-collapse">
                    <thead>
                        <tr class="bg-blue-50">
                            <th class="border-b border-blue-100 px-4 py-3 text-left text-sm font-medium text-blue-700">Doctor ID</th>
                            <th class="border-b border-blue-100 px-4 py-3 text-left text-sm font-medium text-blue-700">Name</th>
                            <th class="border-b border-blue-100 px-4 py-3 text-left text-sm font-medium text-blue-700">Hospital</th>
                            <th class="border-b border-blue-100 px-4 py-3 text-left text-sm font-medium text-blue-700">Diagnosis ID</th>
                            <th class="border-b border-blue-100 px-4 py-3 text-left text-sm font-medium text-blue-700">Status</th>
                            <th class="border-b border-blue-100 px-4 py-3 text-left text-sm font-medium text-blue-700">Result</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (cases != null && !cases.isEmpty()) { 
                            for (DoctorCase dc : cases) { 
                                // Determine status styling
                                String statusClass = "";
                                String statusIcon = "";
                                
                                if (dc.getDiagnoStatus().equalsIgnoreCase("completed")) {
                                    statusClass = "bg-green-50 text-green-700 border-green-100";
                                    statusIcon = "fa-check-circle text-green-500";
                                } else if (dc.getDiagnoStatus().equalsIgnoreCase("pending")) {
                                    statusClass = "bg-yellow-50 text-yellow-700 border-yellow-100";
                                    statusIcon = "fa-clock text-yellow-500";
                                } else if (dc.getDiagnoStatus().equalsIgnoreCase("in progress")) {
                                    statusClass = "bg-blue-50 text-blue-700 border-blue-100";
                                    statusIcon = "fa-spinner text-blue-500";
                                } else {
                                    statusClass = "bg-red-50 text-red-700 border-red-100";
                                    statusIcon = "fa-exclamation-circle text-red-500";
                                }
                        %>
                                <tr class="hover:bg-blue-50 transition border-b border-blue-50">
                                    <td class="px-4 py-3 text-sm"><%= dc.getDoctorID() %></td>
                                    <td class="px-4 py-3 text-sm font-medium">
                                        <div class="flex items-center">
                                            <div class="h-8 w-8 bg-blue-100 rounded-full flex items-center justify-center mr-3">
                                                <i class="fas fa-user-md text-blue-500"></i>
                                            </div>
                                            <%= dc.getFirstName() %> <%= dc.getLastName() %>
                                        </div>
                                    </td>
                                    <td class="px-4 py-3 text-sm">
                                        <div class="flex items-center">
                                            <i class="fas fa-hospital-alt text-blue-400 mr-2"></i>
                                            <%= dc.getHospitalName() %>
                                        </div>
                                    </td>
                                    <td class="px-4 py-3 text-sm text-blue-600 font-medium">
                                        #<%= dc.getDiagnosisID() %>
                                    </td>
                                    <td class="px-4 py-3 text-sm">
                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium <%= statusClass %>">
                                            <i class="fas <%= statusIcon %> mr-1"></i>
                                            <%= dc.getDiagnoStatus() %>
                                        </span>
                                    </td>
                                    <td class="px-4 py-3 text-sm">
                                        <% if (dc.getResult() != null && !dc.getResult().isEmpty()) { %>
                                            <%= dc.getResult() %>
                                        <% } else { %>
                                            <span class="text-gray-400">Not available</span>
                                        <% } %>
                                    </td>
                                </tr>
                        <% } 
                        } else { %>
                            <tr>
                                <td colspan="6" class="px-4 py-8 text-sm text-center">
                                    <div class="flex flex-col items-center justify-center">
                                        <i class="fas fa-folder-open text-blue-200 text-5xl mb-3"></i>
                                        <p class="text-blue-500">No cases available</p>
                                        <a href="dashboard.jsp" class="mt-3 text-blue-600 hover:text-blue-800">
                                            <i class="fas fa-arrow-left mr-1"></i> Return to Dashboard
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
            <div class="mt-6">
                <a href="dashboard.jsp" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition flex items-center inline-block">
                    <i class="fas fa-arrow-left mr-2"></i> Back to Dashboard
                </a>
            </div>
        </div>
    </main>
    
    <footer class="bg-white py-4 border-t border-blue-100">
        <div class="container mx-auto text-center text-blue-500 text-sm">
            &copy; <%= new java.util.Date().getYear() + 1900 %> MBC Hospital Management System
        </div>
    </footer>
</body>
</html>