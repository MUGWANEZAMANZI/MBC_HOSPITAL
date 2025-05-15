<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat, com.mbc_hospital.model.Patient" %>
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
    
    // Get patient data and diagnoses
    Patient patient = (Patient) request.getAttribute("patient");
    @SuppressWarnings("unchecked")
    List<Map<String, Object>> patientDiagnoses = 
        (List<Map<String, Object>>) request.getAttribute("patientDiagnoses");
    
    boolean hasPatient = (patient != null);
    boolean hasDiagnoses = (patientDiagnoses != null && !patientDiagnoses.isEmpty());
    
    // Date formatter
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
    
    // Status colors
    Map<String, String> statusColors = new HashMap<>();
    statusColors.put("Positive", "bg-green-100 text-green-800 border-green-200");
    statusColors.put("Negative", "bg-red-100 text-red-800 border-red-200");
    statusColors.put("Action Required", "bg-yellow-100 text-yellow-800 border-yellow-200");
    statusColors.put("Referrable", "bg-blue-100 text-blue-800 border-blue-200");
    statusColors.put("Not Referable", "bg-purple-100 text-purple-800 border-purple-200");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Diagnoses | MBC Hospital</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .gradient-bg {
            background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);
        }
        .sidebar-link {
            transition: all 0.2s ease;
        }
        .sidebar-link:hover {
            padding-left: 1.5rem;
        }
        .sidebar-link.active {
            background-color: rgba(255, 255, 255, 0.1);
            border-right: 3px solid white;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-fade-in {
            animation: fadeIn 0.6s ease forwards;
        }
        .diagnosis-card {
            transition: all 0.3s ease;
        }
        .diagnosis-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }
    </style>
</head>
<body class="bg-gray-50 min-h-screen flex">
    <!-- Sidebar -->
    <aside class="fixed h-screen w-64 gradient-bg text-white hidden lg:block shadow-xl">
        <div class="p-6">
            <div class="flex items-center space-x-2">
                <i class="fas fa-hospital text-3xl"></i>
                <h1 class="text-2xl font-bold">MBC Hospital</h1>
            </div>
            <p class="text-blue-200 text-sm mt-1">Administration Portal</p>
        </div>
        
        <div class="mt-2">
            <div class="px-6 py-4 border-t border-b border-blue-900/30">
                <div class="flex items-center space-x-4">
                    <div class="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center">
                        <i class="fas fa-user-shield text-xl"></i>
                    </div>
                    <div>
                        <p class="text-sm text-blue-100">Welcome,</p>
                        <p class="font-semibold"><%= session.getAttribute("username") %></p>
                    </div>
                </div>
            </div>
            
            <nav class="mt-6 px-4">
                <a href="dashboard.jsp" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                    <i class="fas fa-tachometer-alt w-6"></i>
                    <span>Dashboard</span>
                </a>
                <a href="users-directory" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                    <i class="fas fa-users w-6"></i>
                    <span>User directory</span>
                </a>
                <a href="patients" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                    <i class="fas fa-clipboard-list w-6"></i>
                    <span>Patient Results</span>
                </a>
                <a href="logout.jsp" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mt-8 bg-red-500/20 hover:bg-red-500/30">
                    <i class="fas fa-sign-out-alt w-6"></i>
                    <span>Logout</span>
                </a>
            </nav>
        </div>
    </aside>

    <!-- Main Content -->
    <div class="flex-1 lg:ml-64">
        <!-- Top Navigation -->
        <header class="bg-white shadow-md py-4 px-6 flex justify-between items-center sticky top-0 z-10">
            <div class="flex items-center lg:hidden">
                <button id="menu-toggle" class="text-gray-600 hover:text-gray-800">
                    <i class="fas fa-bars text-xl"></i>
                </button>
                <h1 class="text-xl font-bold text-gray-800 ml-4">Patient Diagnoses</h1>
            </div>
            
            <div class="hidden lg:block">
                <h1 class="text-xl font-bold text-gray-800">Patient Diagnoses</h1>
            </div>
            
            <div class="flex items-center space-x-4">
                <div class="relative">
                    <a href="patients" class="text-blue-600 hover:text-blue-800">
                        <i class="fas fa-arrow-left mr-2"></i>Back to Patients
                    </a>
                </div>
            </div>
        </header>

        <!-- Main Content Area -->
        <main class="p-6 pb-16">
            <% if (hasPatient) { %>
                <!-- Patient Info Section -->
                <div class="bg-white rounded-xl shadow-md p-6 mb-6 animate-fade-in">
                    <div class="flex flex-col md:flex-row items-start md:items-center">
                        <div class="h-16 w-16 bg-blue-100 rounded-full flex items-center justify-center text-blue-600 mr-6 mb-4 md:mb-0">
                            <i class="fas fa-user text-3xl"></i>
                        </div>
                        <div class="flex-1">
                            <h2 class="text-2xl font-bold text-gray-800"><%= patient.getFirstName() %> <%= patient.getLastName() %></h2>
                            <div class="flex flex-col sm:flex-row sm:space-x-6 text-gray-600 mt-1">
                                <span class="flex items-center"><i class="fas fa-id-card mr-2 text-gray-400"></i> ID: <%= patient.getPatientID() %></span>
                                <span class="flex items-center"><i class="fas fa-phone mr-2 text-gray-400"></i> <%= patient.getTelephone() %></span>
                                <span class="flex items-center"><i class="fas fa-envelope mr-2 text-gray-400"></i> <%= patient.getEmail() %></span>
                            </div>
                            <div class="mt-2 flex items-center">
                                <div class="h-6 w-6 bg-green-100 rounded-full flex items-center justify-center mr-2">
                                    <i class="fas fa-user-nurse text-green-600 text-xs"></i>
                                </div>
                                <span class="text-sm text-gray-600">Registered by: </span>
                                <span class="text-sm font-medium text-gray-700 ml-1"><%= patient.getRegisteredByName() %></span>
                            </div>
                        </div>
                        <div class="mt-4 md:mt-0 flex items-center">
                            <div class="bg-blue-100 text-blue-800 px-4 py-2 rounded-lg text-sm font-medium">
                                <%= hasDiagnoses ? patientDiagnoses.size() : 0 %> diagnosis<%= (hasDiagnoses && patientDiagnoses.size() > 1) ? "es" : "" %>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Diagnoses List -->
                <div class="space-y-6 animate-fade-in" style="animation-delay: 0.2s">
                    <h3 class="text-xl font-bold text-gray-800 mb-4">Diagnosis History</h3>
                    
                    <% if (hasDiagnoses) { 
                        for (Map<String, Object> diagnosis : patientDiagnoses) { 
                            String status = (String) diagnosis.get("status");
                            String statusClass = statusColors.getOrDefault(status, "bg-gray-100 text-gray-800 border-gray-200");
                    %>
                        <div class="diagnosis-card bg-white rounded-xl border border-gray-200 overflow-hidden shadow-md">
                            <div class="p-4 border-b border-gray-100">
                                <div class="flex flex-wrap justify-between items-center">
                                    <div>
                                        <span class="px-3 py-1 rounded-full text-xs font-medium <%= statusClass %>">
                                            <%= status %>
                                        </span>
                                        <span class="ml-2 text-sm text-gray-500">
                                            <i class="far fa-clock mr-1"></i>
                                            <%= diagnosis.get("date") != null ? dateFormat.format(diagnosis.get("date")) : "N/A" %>
                                        </span>
                                    </div>
                                    <div class="mt-2 sm:mt-0">
                                        <span class="text-sm text-gray-500">
                                            <% if (diagnosis.get("doctorName") != null) { %>
                                                <i class="fas fa-user-md mr-1 text-blue-500"></i> Dr. <%= diagnosis.get("doctorName") %>
                                            <% } %>
                                            <% if (diagnosis.get("nurseName") != null) { %>
                                                <i class="fas fa-user-nurse mx-1 text-purple-500"></i> <%= diagnosis.get("nurseName") %>
                                            <% } %>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="p-5 grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div>
                                    <h5 class="text-sm font-semibold text-gray-700 mb-1">Result</h5>
                                    <p class="text-sm bg-gray-50 p-3 rounded-lg border border-gray-100"><%= diagnosis.get("result") != null ? diagnosis.get("result") : "Pending" %></p>
                                </div>
                                
                                <div>
                                    <h5 class="text-sm font-semibold text-gray-700 mb-1">Medications</h5>
                                    <p class="text-sm bg-gray-50 p-3 rounded-lg border border-gray-100"><%= diagnosis.get("medications") != null ? diagnosis.get("medications") : "None prescribed" %></p>
                                </div>
                                
                                <div class="md:col-span-2">
                                    <h5 class="text-sm font-semibold text-gray-700 mb-1">Nurse Assessment</h5>
                                    <p class="text-sm bg-gray-50 p-3 rounded-lg border border-gray-100"><%= diagnosis.get("nurseAssessment") != null ? diagnosis.get("nurseAssessment") : "No assessment provided" %></p>
                                </div>
                            </div>
                        </div>
                    <% } 
                    } else { %>
                        <div class="bg-white rounded-xl shadow-md p-8 text-center">
                            <div class="inline-block bg-gray-100 rounded-full p-3 mb-4">
                                <i class="fas fa-file-medical text-gray-400 text-xl"></i>
                            </div>
                            <p class="text-gray-500">No diagnosis records found for this patient.</p>
                        </div>
                    <% } %>
                    
                    <div class="mt-8">
                        <a href="patients" class="bg-gray-200 text-gray-700 px-4 py-2 rounded-md hover:bg-gray-300 transition flex items-center w-max">
                            <i class="fas fa-arrow-left mr-2"></i> Back to Patient List
                        </a>
                    </div>
                </div>
            <% } else { %>
                <!-- No Patient Found Message -->
                <div class="bg-white rounded-xl shadow-md p-12 text-center animate-fade-in">
                    <div class="inline-block bg-red-100 rounded-full p-5 mb-4">
                        <i class="fas fa-exclamation-triangle text-red-500 text-3xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold text-gray-800 mb-2">Patient Not Found</h3>
                    <p class="text-gray-600 max-w-md mx-auto">The patient you're looking for doesn't exist or you don't have permission to view their information.</p>
                    <a href="patients" class="mt-6 inline-block px-5 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition">
                        Return to Patient List
                    </a>
                </div>
            <% } %>
        </main>
    </div>
    
    <!-- Mobile Menu (hidden by default) -->
    <div id="mobile-menu" class="fixed inset-0 z-20 transform -translate-x-full transition-transform duration-300 ease-in-out bg-gray-900 bg-opacity-50">
        <div class="bg-gradient-to-b from-blue-800 to-blue-900 text-white h-full w-64 shadow-lg">
            <div class="p-6 flex justify-between items-center">
                <div class="flex items-center space-x-2">
                    <i class="fas fa-hospital text-2xl"></i>
                    <span class="text-xl font-bold">MBC Hospital</span>
                </div>
                <button id="close-menu" class="text-white">
                    <i class="fas fa-times text-xl"></i>
                </button>
            </div>
            
            <div class="mt-2">
                <div class="px-6 py-4 border-t border-b border-blue-900/30">
                    <div class="flex items-center space-x-4">
                        <div class="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center">
                            <i class="fas fa-user-shield text-xl"></i>
                        </div>
                        <div>
                            <p class="text-sm text-blue-100">Welcome,</p>
                            <p class="font-semibold"><%= session.getAttribute("username") %></p>
                        </div>
                    </div>
                </div>
                
                <nav class="mt-6 px-4">
                    <a href="dashboard.jsp" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                        <i class="fas fa-tachometer-alt w-6"></i>
                        <span>Dashboard</span>
                    </a>
                    <a href="users-directory" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                        <i class="fas fa-users w-6"></i>
                        <span>User directory</span>
                    </a>
                    <a href="patients" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                        <i class="fas fa-clipboard-list w-6"></i>
                        <span>Patient Results</span>
                    </a>
                    <a href="logout.jsp" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mt-8 bg-red-500/20 hover:bg-red-500/30">
                        <i class="fas fa-sign-out-alt w-6"></i>
                        <span>Logout</span>
                    </a>
                </nav>
            </div>
        </div>
    </div>

    <script>
        // Mobile menu toggle
        document.addEventListener('DOMContentLoaded', function() {
            const menuToggle = document.getElementById('menu-toggle');
            const closeMenu = document.getElementById('close-menu');
            const mobileMenu = document.getElementById('mobile-menu');
            
            if (menuToggle && mobileMenu && closeMenu) {
                menuToggle.addEventListener('click', function() {
                    mobileMenu.classList.remove('-translate-x-full');
                });
                
                closeMenu.addEventListener('click', function() {
                    mobileMenu.classList.add('-translate-x-full');
                });
            }
        });
    </script>
</body>
</html> 