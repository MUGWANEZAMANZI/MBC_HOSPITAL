<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mbc_hospital.model.Patient" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
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
    
    // Get the diagnosis details from request
    Patient diagnosis = (Patient) request.getAttribute("diagnosisDetails");
    if (diagnosis == null) {
        response.sendRedirect("nurse-view-diagnoses");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diagnosis Details | MBC Hospital</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
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
                <a href="patients-dir" class="sidebar-link flex items-center space-x-3 text-white/90 hover:bg-blue-700/50 p-3 rounded-lg mb-2">
                    <i class="fas fa-stethoscope w-6"></i>
                    <span>Make Diagnosis</span>
                </a>
                <a href="nurse-view-diagnoses" class="sidebar-link active flex items-center space-x-3 bg-blue-700/50 text-white p-3 rounded-lg mb-2">
                    <i class="fas fa-clipboard-check w-6"></i>
                    <span>View Diagnosed Cases</span>
                </a>
                <a href="logout.jsp" class="sidebar-link flex items-center space-x-3 text-white/90 hover:bg-red-700/30 p-3 rounded-lg mt-8 bg-red-500/20">
                    <i class="fas fa-sign-out-alt w-6"></i>
                    <span>Logout</span>
                </a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="ml-64 flex-grow p-6">
            <div class="mb-6">
                <a href="nurse-view-diagnoses" class="inline-flex items-center text-blue-600 hover:text-blue-800 mb-4">
                    <i class="fas fa-arrow-left mr-2"></i>
                    Back to Diagnosed Cases
                </a>
                <h1 class="text-2xl font-bold text-gray-800 flex items-center">
                    <i class="fas fa-clipboard-check mr-3 text-blue-600"></i>
                    Diagnosis Details
                </h1>
                <p class="text-gray-600 mt-1">Detailed information about this diagnosis</p>
            </div>

            <!-- Diagnosis Details Card -->
            <div class="bg-white rounded-xl shadow-lg overflow-hidden mt-6">
                <!-- Patient Info Header -->
                <div class="bg-gradient-to-r from-blue-600 to-blue-800 py-4 px-6 text-white">
                    <div class="flex justify-between items-center">
                        <div>
                            <h2 class="text-xl font-bold">Patient: <%= diagnosis.getFirstName() %> <%= diagnosis.getLastName() %></h2>
                            <p class="text-blue-100 text-sm">Patient ID: <%= diagnosis.getPatientID() %> | Diagnosis ID: <%= diagnosis.getDiagnosisID() %></p>
                        </div>
                        <div>
                            <% if ("Positive".equals(diagnosis.getDiagnosisStatus())) { %>
                                <span class="px-3 py-1 bg-red-500 text-white rounded-full text-sm font-medium">
                                    Positive
                                </span>
                            <% } else { %>
                                <span class="px-3 py-1 bg-green-500 text-white rounded-full text-sm font-medium">
                                    Negative
                                </span>
                            <% } %>
                        </div>
                    </div>
                </div>
                
                <!-- Diagnosis Content -->
                <div class="p-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                        <!-- Patient Information -->
                        <div class="bg-gray-50 rounded-lg p-4">
                            <h3 class="text-lg font-semibold text-gray-800 mb-3">Patient Information</h3>
                            <div class="space-y-2">
                                <p class="flex justify-between">
                                    <span class="text-gray-600">Name:</span>
                                    <span class="font-medium"><%= diagnosis.getFirstName() %> <%= diagnosis.getLastName() %></span>
                                </p>
                                <p class="flex justify-between">
                                    <span class="text-gray-600">Contact:</span>
                                    <span class="font-medium"><%= diagnosis.getTelephone() %></span>
                                </p>
                                <p class="flex justify-between">
                                    <span class="text-gray-600">Email:</span>
                                    <span class="font-medium"><%= diagnosis.getEmail() != null ? diagnosis.getEmail() : "Not provided" %></span>
                                </p>
                                <p class="flex justify-between">
                                    <span class="text-gray-600">Address:</span>
                                    <span class="font-medium"><%= diagnosis.getAddress() != null ? diagnosis.getAddress() : "Not provided" %></span>
                                </p>
                                <p class="flex justify-between">
                                    <span class="text-gray-600">Registered By:</span>
                                    <span class="font-medium"><%= diagnosis.getRegisteredByName() != null ? diagnosis.getRegisteredByName() : "Unknown" %></span>
                                </p>
                            </div>
                        </div>
                        
                        <!-- Diagnosis Status -->
                        <div class="bg-gray-50 rounded-lg p-4">
                            <h3 class="text-lg font-semibold text-gray-800 mb-3">Diagnosis Status</h3>
                            <div class="space-y-2">
                                <p class="flex justify-between">
                                    <span class="text-gray-600">Status:</span>
                                    <span class="font-medium">
                                        <% if ("Positive".equals(diagnosis.getDiagnosisStatus())) { %>
                                            <span class="px-2 py-1 bg-red-100 text-red-800 rounded-full text-xs font-medium">
                                                Positive
                                            </span>
                                        <% } else { %>
                                            <span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs font-medium">
                                                Negative
                                            </span>
                                        <% } %>
                                    </span>
                                </p>
                                <p class="flex justify-between">
                                    <span class="text-gray-600">Diagnosed On:</span>
                                    <span class="font-medium">
                                        <!-- Placeholder for diagnosis date, not available in the model -->
                                        N/A
                                    </span>
                                </p>
                                <p class="flex justify-between">
                                    <span class="text-gray-600">Follow-up Date:</span>
                                    <span class="font-medium">
                                        <%= diagnosis.getFollowUpDate() != null ? diagnosis.getFollowUpDate() : "Not scheduled" %>
                                    </span>
                                </p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Diagnosis Details -->
                    <div class="border-t border-gray-200 pt-6">
                        <h3 class="text-lg font-semibold text-gray-800 mb-3">Diagnosis Result</h3>
                        <div class="bg-gray-50 rounded-lg p-4 mb-4">
                            <p class="text-gray-700"><%= diagnosis.getDiagnosisResult() != null ? diagnosis.getDiagnosisResult() : "No diagnosis result provided" %></p>
                        </div>
                        
                        <h3 class="text-lg font-semibold text-gray-800 mb-3">Medications Prescribed</h3>
                        <div class="bg-gray-50 rounded-lg p-4 mb-4">
                            <p class="text-gray-700"><%= diagnosis.getMedicationsPrescribed() != null ? diagnosis.getMedicationsPrescribed() : "No medications prescribed" %></p>
                        </div>
                        
                        <h3 class="text-lg font-semibold text-gray-800 mb-3">Nurse Assessment</h3>
                        <div class="bg-gray-50 rounded-lg p-4">
                            <p class="text-gray-700"><%= diagnosis.getNurseAssessment() != null ? diagnosis.getNurseAssessment() : "No nurse assessment provided" %></p>
                        </div>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="mt-6 flex justify-end space-x-4">
                        <a href="nurse-view-diagnoses" class="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition flex items-center">
                            <i class="fas fa-arrow-left mr-2"></i>
                            Back to List
                        </a>
                        <button onclick="window.print()" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition flex items-center">
                            <i class="fas fa-print mr-2"></i>
                            Print Report
                        </button>
                    </div>
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