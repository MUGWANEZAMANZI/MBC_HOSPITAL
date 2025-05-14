<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.mbc_hospital.model.Patient" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    // Validate user session
    Integer userID = null;
    String userType = null;

    if (session != null) {
        if (session.getAttribute("id") != null) {
            try {
                userID = (Integer) session.getAttribute("id");
            } catch (ClassCastException e) {
                // Handle exception
            }
        }
        
        if (session.getAttribute("usertype") != null) {
            userType = (String) session.getAttribute("usertype");
        }
    }

    if (userID == null || !"nurse".equalsIgnoreCase(userType)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get data from request
    List<Patient> nurseCompletedCases = (List<Patient>) request.getAttribute("nurseCompletedCases");
    String errorMessage = (String) request.getAttribute("error");
    int caseCount = (nurseCompletedCases != null) ? nurseCompletedCases.size() : 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nurse-Completed Cases - MBC Hospital</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <style>
        .animate-fade-in {
            animation: fadeIn 0.5s ease-in-out forwards;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body class="bg-gray-50 min-h-screen">

    <!-- Header -->
    <header class="bg-gradient-to-r from-blue-700 to-blue-900 text-white shadow-xl">
        <div class="container mx-auto py-4 px-6">
            <div class="flex justify-between items-center">
                <div class="flex items-center space-x-3">
                    <i class="fas fa-hospital text-3xl text-blue-200"></i>
                    <h1 class="text-3xl font-bold tracking-tight">MBC HOSPITAL</h1>
                </div>
                <div class="flex items-center space-x-6">
                    <a class="flex items-center px-4 py-2 bg-blue-800 hover:bg-blue-600 rounded-lg transition duration-300 shadow-md" href="nurse.jsp">
                        <i class="fas fa-home mr-2"></i>Home
                    </a>
                    <div class="flex items-center bg-blue-800/50 px-4 py-2 rounded-lg">
                        <i class="fas fa-user-circle text-xl mr-2 text-blue-200"></i>
                        <p>Welcome, <span class="font-semibold"><%= session.getAttribute("username") %></span></p>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Sidebar -->
    <div class="flex">
        <aside class="w-64 h-screen bg-gradient-to-b from-blue-800 to-blue-900 text-white fixed left-0 top-0 pt-24 transform transition-transform duration-300 ease-in-out">
            <div class="px-6 py-4 border-t border-blue-700">
                <div class="flex items-center space-x-3">
                    <div class="h-10 w-10 rounded-full bg-blue-600 flex items-center justify-center">
                        <i class="fas fa-user-nurse"></i>
                    </div>
                    <div>
                        <p class="text-xs text-blue-300">Logged in as</p>
                        <p class="font-medium"><%= session.getAttribute("username") %></p>
                    </div>
                </div>
            </div>
            
            <nav class="mt-8 px-6">
                <a href="nurse.jsp" class="sidebar-link flex items-center space-x-3 text-white/90 hover:bg-blue-700/50 p-3 rounded-lg mb-2">
                    <i class="fas fa-tachometer-alt w-6"></i>
                    <span>Dashboard</span>
                </a>
                <a href="create_patient.jsp" class="sidebar-link flex items-center space-x-3 text-white/90 hover:bg-blue-700/50 p-3 rounded-lg mb-2">
                    <i class="fas fa-user-plus w-6"></i>
                    <span>Register Patient</span>
                </a>
                <a href="nurse-action-cases" class="sidebar-link flex items-center space-x-3 text-white/90 hover:bg-blue-700/50 p-3 rounded-lg mb-2">
                    <i class="fas fa-clipboard-list w-6"></i>
                    <span>Cases Requiring Action</span>
                </a>
                <a href="nurse-referred-cases" class="sidebar-link flex items-center space-x-3 text-white/90 hover:bg-blue-700/50 p-3 rounded-lg mb-2">
                    <i class="fas fa-share w-6"></i>
                    <span>Referred Cases</span>
                </a>
                <a href="nurse-completed-cases" class="sidebar-link active flex items-center space-x-3 bg-blue-700/50 text-white p-3 rounded-lg mb-2">
                    <i class="fas fa-check-circle w-6"></i>
                    <span>Nurse-Completed Cases</span>
                </a>
                <a href="nurse-view-diagnoses" class="sidebar-link flex items-center space-x-3 text-white/90 hover:bg-blue-700/50 p-3 rounded-lg mb-2">
                    <i class="fas fa-clipboard-check w-6"></i>
                    <span>View All Diagnosed Cases</span>
                </a>
                <a href="logout.jsp" class="sidebar-link flex items-center space-x-3 text-white/90 hover:bg-red-700/30 p-3 rounded-lg mt-8 bg-red-500/20">
                    <i class="fas fa-sign-out-alt w-6"></i>
                    <span>Logout</span>
                </a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="ml-64 flex-grow p-6">
            <div class="mb-6 animate-fade-in">
                <h1 class="text-2xl font-bold text-gray-800 flex items-center">
                    <i class="fas fa-check-circle mr-3 text-green-600"></i>
                    Nurse-Completed Cases
                </h1>
                <p class="text-gray-600 mt-1">Cases diagnosed and completed by nurses without doctor referral</p>
            </div>

            <!-- Error Message (if any) -->
            <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6 rounded-md shadow-sm animate-fade-in">
                <div class="flex">
                    <div class="flex-shrink-0">
                        <i class="fas fa-exclamation-triangle text-red-500"></i>
                    </div>
                    <div class="ml-3">
                        <p class="text-sm text-red-700">
                            Error: <%= errorMessage %>
                        </p>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Info Banner -->
            <div class="bg-blue-50 border-l-4 border-blue-500 p-4 mb-6 rounded-md shadow-sm animate-fade-in">
                <div class="flex">
                    <div class="flex-shrink-0">
                        <i class="fas fa-info-circle text-blue-500"></i>
                    </div>
                    <div class="ml-3">
                        <p class="text-sm text-blue-700">
                            Found <%= caseCount %> cases completed by nurses without doctor referral.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Cases Table -->
            <div class="bg-white rounded-xl shadow-lg overflow-hidden mt-6 animate-fade-in" style="animation-delay: 0.2s">
                <div class="p-6">
                    <table class="min-w-full bg-white">
                        <thead class="bg-gray-100 text-gray-700">
                            <tr>
                                <th class="py-3 px-4 text-left font-semibold">Patient ID</th>
                                <th class="py-3 px-4 text-left font-semibold">Patient Name</th>
                                <th class="py-3 px-4 text-left font-semibold">Diagnosis Date</th>
                                <th class="py-3 px-4 text-left font-semibold">Status</th>
                                <th class="py-3 px-4 text-left font-semibold">Result</th>
                                <th class="py-3 px-4 text-left font-semibold">Nurse</th>
                                <th class="py-3 px-4 text-left font-semibold">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-200">
                            <%
                            if (nurseCompletedCases != null && !nurseCompletedCases.isEmpty()) {
                                for (Patient patient : nurseCompletedCases) {
                            %>
                            <tr class="hover:bg-gray-50 transition duration-150">
                                <td class="py-3 px-4"><%= patient.getPatientID() %></td>
                                <td class="py-3 px-4 font-medium"><%= patient.getFirstName() + " " + patient.getLastName() %></td>
                                <td class="py-3 px-4"><%= patient.getDiagnosisDate() != null ? patient.getDiagnosisDate().substring(0, 10) : "N/A" %></td>
                                <td class="py-3 px-4">
                                    <% if ("Positive".equals(patient.getDiagnosisStatus())) { %>
                                        <span class="px-2 py-1 bg-red-100 text-red-800 rounded-full text-xs font-medium">
                                            <i class="fas fa-plus-circle mr-1"></i> Positive
                                        </span>
                                    <% } else { %>
                                        <span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs font-medium">
                                            <i class="fas fa-minus-circle mr-1"></i> Negative
                                        </span>
                                    <% } %>
                                </td>
                                <td class="py-3 px-4 max-w-xs truncate"><%= patient.getDiagnosisResult() %></td>
                                <td class="py-3 px-4">
                                    <div class="flex items-center">
                                        <div class="h-7 w-7 bg-blue-100 rounded-full flex items-center justify-center mr-2">
                                            <i class="fas fa-user-nurse text-blue-600"></i>
                                        </div>
                                        <%= patient.getNurseName() != null ? patient.getNurseName() : "Unknown" %>
                                    </div>
                                </td>
                                <td class="py-3 px-4">
                                    <a href="view-diagnosis?id=<%= patient.getDiagnosisID() %>" 
                                       class="px-3 py-1 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition flex items-center text-sm inline-flex">
                                        <i class="fas fa-eye mr-1"></i> View Details
                                    </a>
                                </td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="7" class="py-4 px-4 text-center text-gray-500">
                                    <div class="flex flex-col items-center justify-center py-8">
                                        <div class="inline-flex h-20 w-20 rounded-full bg-blue-100 text-blue-600 items-center justify-center mb-4">
                                            <i class="fas fa-clipboard-check text-4xl"></i>
                                        </div>
                                        <h3 class="text-lg font-medium text-gray-900 mb-2">No nurse-completed cases found</h3>
                                        <p class="text-gray-500">There are currently no cases completed by nurses without doctor referral.</p>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- Footer -->
    <footer class="bg-white border-t border-gray-200 ml-64">
        <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
            <div class="md:flex md:items-center md:justify-between">
                <div class="flex justify-center space-x-6 md:order-2">
                    <a href="#" class="text-gray-400 hover:text-gray-500">
                        <i class="fab fa-facebook"></i>
                    </a>
                    <a href="#" class="text-gray-400 hover:text-gray-500">
                        <i class="fab fa-instagram"></i>
                    </a>
                    <a href="#" class="text-gray-400 hover:text-gray-500">
                        <i class="fab fa-twitter"></i>
                    </a>
                </div>
                <div class="mt-8 md:mt-0 md:order-1">
                    <p class="text-center text-gray-500">&copy; 2025 MBC Hospital System. All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>
</body>
</html> 