<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String userType = (String) session.getAttribute("usertype"); %>
<% String username = (String) session.getAttribute("username"); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diagnosis Records - MBC Hospital</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="assets/js/diagnosis.js"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: {
                            50: '#eff6ff',
                            100: '#dbeafe',
                            200: '#bfdbfe',
                            300: '#93c5fd',
                            400: '#60a5fa',
                            500: '#3b82f6',
                            600: '#2563eb',
                            700: '#1d4ed8',
                            800: '#1e40af',
                            900: '#1e3a8a',
                        }
                    },
                    animation: {
                        'fade-in': 'fadeIn 0.5s ease-out forwards',
                        'slide-up': 'slideUp 0.5s ease-out forwards',
                    },
                    keyframes: {
                        fadeIn: {
                            '0%': { opacity: '0' },
                            '100%': { opacity: '1' },
                        },
                        slideUp: {
                            '0%': { transform: 'translateY(20px)', opacity: '0' },
                            '100%': { transform: 'translateY(0)', opacity: '1' },
                        }
                    }
                },
            },
        }
    </script>
    <style>
        .sidebar {
            background: linear-gradient(135deg, #1e40af 0%, #3b82f6 100%);
            width: 280px;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            color: white;
            padding: 1.5rem 1rem;
            transition: all 0.3s ease;
            box-shadow: 0 0 25px rgba(0, 0, 0, 0.15);
            z-index: 50;
            overflow-y: auto;
        }
        
        .sidebar-header {
            padding-bottom: 1.5rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 1.5rem;
        }
        
        .sidebar-user {
            padding: 1.25rem;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.05);
        }
        
        .sidebar-link {
            display: flex;
            align-items: center;
            padding: 0.85rem 1.25rem;
            color: rgba(255, 255, 255, 0.9);
            border-radius: 8px;
            transition: all 0.2s ease;
            margin-bottom: 0.5rem;
            font-weight: 500;
            position: relative;
            overflow: hidden;
            text-decoration: none;
        }
        
        .sidebar-link:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            transform: translateX(5px);
        }
        
        .sidebar-link.active {
            background: white;
            color: #2563eb;
            font-weight: 600;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
        }
        
        .sidebar-link.active::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            width: 4px;
            background: #1e40af;
        }
        
        .main-content {
            margin-left: 280px;
            padding: 2rem;
            min-height: 100vh;
            background-color: #f1f5f9;
        }
        
        .diagnosis-card {
            transition: all 0.3s ease;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            border: 1px solid rgba(0, 0, 0, 0.02);
        }
        
        .diagnosis-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
        
        .stats-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            border: 1px solid rgba(0, 0, 0, 0.02);
            height: 100%;
        }
        
        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
        
        .table-container {
            overflow-x: auto;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            border: 1px solid rgba(0, 0, 0, 0.02);
        }
        
        /* Responsive styles */
        @media (max-width: 1024px) {
            .main-content {
                margin-left: 0;
                padding: 1rem;
            }
            
            .sidebar {
                transform: translateX(-100%);
            }
            
            .sidebar.active {
                transform: translateX(0);
            }
            
            .mobile-menu-btn {
                display: block;
            }
        }
        
        @media print {
            .sidebar, .no-print {
                display: none !important;
            }
            
            .main-content {
                margin-left: 0;
                padding: 0;
            }
            
            body {
                background-color: white;
            }
        }
    </style>
</head>
<body class="bg-gray-100">
<%
    String message = (String) session.getAttribute("message");
    String error = (String) session.getAttribute("error");
%>

<!-- Sidebar Navigation -->
<aside class="sidebar">
    <div class="sidebar-header">
        <a href="/reffered" class="flex items-center">
            <i class="fas fa-hospital text-white text-3xl mr-3"></i>
            <h1 class="text-2xl font-bold">MBC Hospital</h1>
        </a>
        <p class="text-sm text-blue-200 mt-1">Healthcare Management System</p>
    </div>

    <div class="sidebar-user">
        <div class="flex items-center space-x-3">
            <div class="w-12 h-12 rounded-full bg-white/20 flex items-center justify-center">
                <i class="fas fa-user-md text-xl"></i>
            </div>
            <div>
                <p class="text-sm text-blue-100">Welcome,</p>
                <p class="font-semibold"><%= username != null ? username : "doctor1" %></p>
                <span class="inline-block mt-1 text-xs bg-blue-800/40 rounded-full px-2 py-0.5">
                    <%= userType != null ? userType : "Doctor" %>
                </span>
            </div>
        </div>
        
    </div>

    <nav class="space-y-1">
        <p class="text-xs uppercase text-blue-300/70 font-semibold px-3 py-2">Main Navigation</p>
        <a href="reffered" class="sidebar-link">
            <i class="fas fa-tachometer-alt w-6"></i>
            <span>Dashboard</span>
        </a>
        
        <p class="text-xs uppercase text-blue-300/70 font-semibold px-3 py-2 mt-4">Staff Management</p>
        <a href="register-nurse" class="sidebar-link">
            <i class="fas fa-user-nurse w-6"></i>
            <span>Register a Nurse</span>
        </a>
        
        <a href="view_nurses.jsp" class="sidebar-link">
            <i class="fas fa-clipboard-list w-6"></i>
            <span>Registered Nurses</span>
        </a>
        
        <p class="text-xs uppercase text-blue-300/70 font-semibold px-3 py-2 mt-4">Patient Care</p>
        <a href="reffered" class="sidebar-link">
            <i class="fas fa-clipboard-check w-6"></i>
            <span>Awaiting Diagnosis</span>
        </a>
        
        <a href="confirmed-cases" class="sidebar-link">
            <i class="fas fa-check-circle w-6"></i>
            <span>Confirmed Cases</span>
        </a>
        
        <a href="all-patients" class="sidebar-link">
            <i class="fas fa-users w-6"></i>
            <span>All Patients</span>
        </a>
        
        <a href="DiagnosisViewServlet" class="sidebar-link active">
            <i class="fas fa-stethoscope w-6"></i>
            <span>Diagnosis Records</span>
        </a>
        
        <div class="pt-4 mt-6 border-t border-blue-700/30">
            <a href="logout.jsp" class="sidebar-link bg-red-500/20 hover:bg-red-500/30">
                <i class="fas fa-sign-out-alt w-6"></i>
                <span>Logout</span>
            </a>
        </div>
    </nav>
</aside>

<!-- Main Content Area -->
<div class="main-content">
    <!-- Notification messages -->
    <% if (message != null) { %>
        <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6 rounded shadow-sm animate-fade-in" role="alert">
            <div class="flex">
                <div class="flex-shrink-0">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="ml-3">
                    <p class="font-medium"><%= message %></p>
                </div>
                <button class="ml-auto" onclick="this.parentNode.parentNode.style.display='none'">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>
    <% session.removeAttribute("message"); } %>

    <% if (error != null) { %>
        <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded shadow-sm animate-fade-in" role="alert">
            <div class="flex">
                <div class="flex-shrink-0">
                    <i class="fas fa-exclamation-circle"></i>
                </div>
                <div class="ml-3">
                    <p class="font-medium"><%= error %></p>
                </div>
                <button class="ml-auto" onclick="this.parentNode.parentNode.style.display='none'">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>
    <% session.removeAttribute("error"); } %>

    <!-- Page header -->
    <header class="flex justify-between items-center mb-6 bg-white p-4 rounded-xl shadow-sm">
        <div class="flex items-center">
            <button id="mobile-menu-btn" class="lg:hidden mr-3 text-gray-600">
                <i class="fas fa-bars text-xl"></i>
            </button>
            <h1 class="text-2xl font-bold text-gray-800">
                <i class="fas fa-clipboard-check text-blue-600 mr-2"></i>
                Diagnosis Records
            </h1>
        </div>
        <div class="flex space-x-3">
            <a href="reffered" class="px-4 py-2 bg-gray-100 rounded-lg flex items-center text-gray-700 hover:bg-gray-200 transition shadow-sm">
                <i class="fas fa-clipboard-check mr-2"></i> Awaiting Diagnosis
            </a>
            <button onclick="printPage()" class="px-4 py-2 bg-blue-600 text-white rounded-lg flex items-center hover:bg-blue-700 transition shadow-sm">
                <i class="fas fa-print mr-2"></i> Print Report
            </button>
        </div>
    </header>

    <!-- Statistics Cards -->
    <%
        java.util.List<com.mbc_hospital.model.Diagnosis> diagnosisList =
        (java.util.List<com.mbc_hospital.model.Diagnosis>) request.getAttribute("diagnosisList");
        java.util.Map<Integer, String> patientNames = 
        (java.util.Map<Integer, String>) request.getAttribute("patientNames");
        
        int totalCount = diagnosisList != null ? diagnosisList.size() : 0;
        int pendingCount = 0;
        int completedCount = 0;
        
        if (diagnosisList != null) {
            for (com.mbc_hospital.model.Diagnosis d : diagnosisList) {
                if ("Referrable".equalsIgnoreCase(d.getStatus()) || 
                    "Action Required".equalsIgnoreCase(d.getStatus()) ||
                    "Pending".equals(d.getResult())) {
                    pendingCount++;
                } else {
                    completedCount++;
                }
            }
        }
    %>
    
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <div class="stats-card animate-fade-in" style="animation-delay: 0.1s">
            <div class="flex items-center space-x-4">
                <div class="p-3 rounded-full bg-blue-100 text-blue-600">
                    <i class="fas fa-user-nurse text-2xl"></i>
                </div>
                <div>
                    <p class="text-sm text-gray-500 font-medium">Registered Nurses</p>
                    <div class="flex items-end">
                        <h3 class="text-2xl font-bold text-gray-800">5</h3>
                        <span class="text-xs text-green-600 font-semibold ml-2 mb-1 flex items-center">
                            <i class="fas fa-arrow-up mr-1"></i>2%
                        </span>
                    </div>
                </div>
            </div>
            <div class="mt-4 pt-3 border-t border-gray-100">
                <a href="view_nurses.jsp" class="text-sm text-blue-600 hover:text-blue-700 flex items-center">
                    View Details <i class="fas fa-arrow-right ml-1"></i>
                </a>
            </div>
        </div>
        
        <div class="stats-card animate-fade-in" style="animation-delay: 0.2s">
            <div class="flex items-center space-x-4">
                <div class="p-3 rounded-full bg-amber-100 text-amber-600">
                    <i class="fas fa-clipboard-check text-2xl"></i>
                </div>
                <div>
                    <p class="text-sm text-gray-500 font-medium">Awaiting Diagnosis</p>
                    <div class="flex items-end">
                        <h3 class="text-2xl font-bold text-gray-800"><%= pendingCount %></h3>
                        <% if (pendingCount > 0) { %>
                            <span class="text-xs text-amber-600 font-semibold ml-2 mb-1 flex items-center">
                                <i class="fas fa-clock mr-1"></i>Needs Review
                            </span>
                        <% } %>
                    </div>
                </div>
            </div>
            <div class="mt-4 pt-3 border-t border-gray-100">
                <a href="reffered" class="text-sm text-blue-600 hover:text-blue-700 flex items-center">
                    View Cases <i class="fas fa-arrow-right ml-1"></i>
                </a>
            </div>
        </div>
        
        <div class="stats-card animate-fade-in" style="animation-delay: 0.3s">
            <div class="flex items-center space-x-4">
                <div class="p-3 rounded-full bg-green-100 text-green-600">
                    <i class="fas fa-check-circle text-2xl"></i>
                </div>
                <div>
                    <p class="text-sm text-gray-500 font-medium">Confirmed Cases</p>
                    <div class="flex items-end">
                        <h3 class="text-2xl font-bold text-gray-800"><%= completedCount %></h3>
                        <span class="text-xs text-green-600 font-semibold ml-2 mb-1 flex items-center">
                            <i class="fas fa-chart-line mr-1"></i>Total
                        </span>
                    </div>
                </div>
            </div>
            <div class="mt-4 pt-3 border-t border-gray-100">
                <a href="confirmed-cases" class="text-sm text-blue-600 hover:text-blue-700 flex items-center">
                    View Details <i class="fas fa-arrow-right ml-1"></i>
                </a>
            </div>
        </div>
        
        <div class="stats-card animate-fade-in" style="animation-delay: 0.4s">
            <div class="flex items-center space-x-4">
                <div class="p-3 rounded-full bg-indigo-100 text-indigo-600">
                    <i class="fas fa-users text-2xl"></i>
                </div>
                <div>
                    <p class="text-sm text-gray-500 font-medium">Total Patients</p>
                    <div class="flex items-end">
                        <h3 class="text-2xl font-bold text-gray-800">31</h3>
                        <span class="text-xs text-indigo-600 font-semibold ml-2 mb-1 flex items-center">
                            <i class="fas fa-database mr-1"></i>System
                        </span>
                    </div>
                </div>
            </div>
            <div class="mt-4 pt-3 border-t border-gray-100">
                <a href="all-patients" class="text-sm text-blue-600 hover:text-blue-700 flex items-center">
                    View Details <i class="fas fa-arrow-right ml-1"></i>
                </a>
            </div>
        </div>
    </div>

    <!-- Diagnosis Table -->
    <div class="bg-white rounded-xl shadow-md overflow-hidden mb-10 animate-fade-in" style="animation-delay: 0.5s">
        <div class="bg-gradient-to-r from-blue-50 to-white px-6 py-4 border-b border-gray-200">
            <h2 class="text-lg font-semibold text-gray-800 flex items-center">
                <i class="fas fa-table text-blue-600 mr-2"></i>
                All Diagnosis Records
                <span class="ml-2 text-xs bg-blue-100 text-blue-800 px-2 py-1 rounded-full font-normal">
                    <%= totalCount %> Records
                </span>
            </h2>
        </div>
    <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Diagnosis ID
                        </th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Patient
                        </th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Staff
                        </th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Status
                        </th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Result
                        </th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                            Date & Follow-up
                        </th>
                </tr>
            </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                <%
                    if (diagnosisList != null && !diagnosisList.isEmpty()) {
                        for (com.mbc_hospital.model.Diagnosis d : diagnosisList) {
                            String status = d.getStatus();
                            String patientName = patientNames != null ? patientNames.get(d.getPatientId()) : "Patient #" + d.getPatientId();
                    %>
                        <tr class="hover:bg-gray-50 transition duration-150">
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="flex items-center">
                                    <div class="h-7 w-7 rounded-full bg-blue-100 flex items-center justify-center text-blue-600 mr-2">
                                        <i class="fas fa-file-medical"></i>
                                    </div>
                                    <div class="text-sm font-medium text-gray-900">#<%= d.getDiagnosisId() %></div>
                                </div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="flex items-center">
                                    <div class="flex-shrink-0 h-10 w-10 bg-blue-100 rounded-full flex items-center justify-center text-blue-600">
                                        <i class="fas fa-user"></i>
                                    </div>
                                    <div class="ml-4">
                                        <div class="text-sm font-medium text-gray-900"><%= patientName %></div>
                                        <div class="text-xs text-gray-500">ID: <%= d.getPatientId() %></div>
                                    </div>
                                </div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="text-sm text-gray-900">
                                    <div class="flex items-center">
                                        <div class="h-6 w-6 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-600 mr-1">
                                            <i class="fas fa-user-md text-xs"></i>
                                        </div>
                                        <span>Dr. ID: <%= d.getDoctorId() %></span>
                                    </div>
                                </div>
                                <div class="text-sm text-gray-500 mt-1">
                                    <div class="flex items-center">
                                        <div class="h-6 w-6 rounded-full bg-green-100 flex items-center justify-center text-green-600 mr-1">
                                            <i class="fas fa-user-nurse text-xs"></i>
                                        </div>
                                        <span>Nurse ID: <%= d.getNurseId() %></span>
                                    </div>
                                </div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <% 
                                    String statusColor = "gray";
                                    String statusIcon = "fa-question-circle";
                                    String displayStatus = status;
                                    if ("referrable".equalsIgnoreCase(status)) {
                                        statusColor = "amber";
                                        statusIcon = "fa-clipboard-check";
                                    } else if ("positive".equalsIgnoreCase(status)) {
                                        statusColor = "red";
                                        statusIcon = "fa-exclamation-circle";
                                    } else if ("negative".equalsIgnoreCase(status)) {
                                        statusColor = "green";
                                        statusIcon = "fa-check-circle";
                                    }
                                %>
                                <span class="px-3 py-1.5 inline-flex items-center text-xs leading-5 font-semibold rounded-full bg-<%= statusColor %>-100 text-<%= statusColor %>-800">
                                    <i class="fas <%= statusIcon %> mr-1"></i>
                                    <%= displayStatus %>
                                </span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="text-sm text-gray-900 font-medium"><%= d.getResult() %></div>
                                <% if (d.getMedicationsPrescribed() != null && !d.getMedicationsPrescribed().isEmpty()) { %>
                                    <div class="text-xs text-gray-500 mt-1 bg-blue-50 px-2 py-1 rounded flex items-center">
                                        <i class="fas fa-pills mr-1 text-blue-500"></i> <%= d.getMedicationsPrescribed() %>
                                    </div>
                                <% } %>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                <div class="flex items-center text-gray-700">
                                    <i class="far fa-calendar-alt mr-1 text-blue-500"></i>
                                    <%= d.getDiagnosisDate() != null ? d.getDiagnosisDate() : "Not recorded" %>
                                </div>
                                <% if (d.getFollowUpDate() != null) { %>
                                    <div class="mt-1 text-indigo-600 bg-indigo-50 px-2 py-1 rounded text-xs flex items-center">
                                        <i class="fas fa-calendar-check mr-1"></i> Follow-up: <%= d.getFollowUpDate() %>
                                    </div>
                                <% } %>
                            </td>
                        </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                            <td colspan="6" class="px-6 py-10 text-center text-gray-500">
                                <div class="flex flex-col items-center justify-center">
                                    <i class="fas fa-clipboard-list text-gray-300 text-5xl mb-3"></i>
                                    <p>No diagnosis records found</p>
                                    <a href="/reffered" class="mt-3 text-primary-600 hover:text-primary-800 flex items-center">
                                        <i class="fas fa-arrow-left mr-1"></i> Return to Dashboard
                                    </a>
                                </div>
                            </td>
                </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- Already Diagnosed Patients Section -->
    <div class="mb-8 animate-fade-in" style="animation-delay: 0.7s">
        <div class="flex justify-between items-center mb-4">
            <h2 class="text-xl font-semibold text-gray-800 flex items-center">
                <i class="fas fa-user-check text-green-600 mr-2"></i>
                Patients with Completed Diagnosis
            </h2>
            <div class="flex space-x-2">
                <button onclick="printPage()" class="no-print text-sm bg-gray-100 text-gray-700 px-3 py-1.5 rounded flex items-center hover:bg-gray-200 transition">
                    <i class="fas fa-print mr-1"></i> Print Summaries
                </button>
                <button id="viewToggle" class="no-print text-sm bg-blue-100 text-blue-700 px-3 py-1.5 rounded flex items-center hover:bg-blue-200 transition">
                    <i class="fas fa-th-large mr-1"></i> <span id="viewToggleText">Compact View</span>
                </button>
            </div>
        </div>
        
        <%
            // Filter out patients with completed diagnosis
            java.util.List<com.mbc_hospital.model.Diagnosis> completedDiagnoses = new java.util.ArrayList<>();
            if (diagnosisList != null) {
                for (com.mbc_hospital.model.Diagnosis d : diagnosisList) {
                    if (!"Pending".equals(d.getResult()) && 
                        !"Action Required".equalsIgnoreCase(d.getStatus()) && 
                        !"Referrable".equalsIgnoreCase(d.getStatus())) {
                        completedDiagnoses.add(d);
                    }
                }
            }
            
            if (completedDiagnoses.isEmpty()) {
        %>
            <div class="bg-gray-50 p-6 rounded-lg border border-gray-200 text-center">
                <i class="fas fa-info-circle text-blue-500 text-xl mb-2"></i>
                <p class="text-gray-500">No diagnosed patients found in the system.</p>
                <p class="text-sm text-gray-400 mt-1">Completed diagnoses will appear here when available.</p>
            </div>
        <%
            } else {
        %>
            <div id="diagnosisCards" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <% for (com.mbc_hospital.model.Diagnosis d : completedDiagnoses) { 
                    String patientName = patientNames != null ? patientNames.get(d.getPatientId()) : "Unknown Patient";
                    boolean isPositive = "Positive".equalsIgnoreCase(d.getStatus());
                %>
                    <div class="diagnosis-card overflow-hidden">
                        <div class="bg-gradient-to-r <%= isPositive ? "from-red-600 to-red-700" : "from-green-600 to-green-700" %> text-white px-4 py-3 font-semibold flex justify-between items-center">
                            <span class="flex items-center">
                                <i class="fas fa-user-circle mr-2"></i>
                                <%= patientName %>
                            </span>
                            <span class="text-xs bg-white <%= isPositive ? "text-red-600" : "text-green-600" %> px-2 py-1 rounded-full">
                                <%= isPositive ? "Positive" : "Negative" %>
                            </span>
                        </div>
                        <div class="p-4">
                            <div class="mb-4">
                                <div class="flex justify-between items-center mb-3">
                                    <p class="text-sm text-gray-500 font-medium">Patient ID:</p> 
                                    <span class="px-2 py-1 rounded text-xs font-semibold bg-gray-100 text-gray-700">
                                        #<%= d.getPatientId() %>
                                    </span>
                                </div>
                                
                                <div class="mt-1 mb-3 pb-3 border-b border-gray-100">
                                    <p class="text-sm text-gray-500 font-medium">Diagnosis Date:</p>
                                    <p class="font-medium flex items-center">
                                        <i class="far fa-calendar-alt text-blue-500 mr-2"></i>
                                        <%= d.getDiagnosisDate() != null ? d.getDiagnosisDate() : "Unknown" %>
                                    </p>
                                </div>
                                
                                <div class="mt-2 mb-3">
                                    <p class="text-sm text-gray-500 font-medium">Diagnosis Result:</p>
                                    <p class="font-medium bg-gray-50 p-2 rounded border border-gray-100 mt-1">
                                        <%= d.getResult() %>
                                    </p>
                                </div>
                                
                                <% if (d.getMedicationsPrescribed() != null && !d.getMedicationsPrescribed().isEmpty()) { %>
                                    <div class="mt-2 mb-3 pb-3 border-b border-gray-100">
                                        <p class="text-sm text-gray-500 font-medium mb-1">Medications:</p>
                                        <p class="font-medium flex items-center bg-blue-50 p-2 rounded border border-blue-100">
                                            <i class="fas fa-pills text-blue-500 mr-2"></i>
                                            <%= d.getMedicationsPrescribed() %>
                                        </p>
                                    </div>
                                <% } %>
                                
                                <% if (d.getFollowUpDate() != null) { %>
                                    <div class="mt-2 text-indigo-700 bg-indigo-50 p-2 rounded flex items-center border border-indigo-100">
                                        <i class="fas fa-calendar-check mr-2"></i>
                                        <div>
                                            <p class="text-xs font-medium">Follow-up Appointment:</p>
                                            <p class="font-semibold"><%= d.getFollowUpDate() %></p>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                            
                            <div class="flex justify-between text-xs text-gray-500 mt-3 pt-3 border-t border-gray-100">
                                <span class="flex items-center">
                                    <i class="fas fa-user-md text-blue-500 mr-1"></i> 
                                    Doctor #<%= d.getDoctorId() %>
                                </span>
                                <span class="flex items-center">
                                    <i class="fas fa-user-nurse text-green-500 mr-1"></i>
                                    Nurse #<%= d.getNurseId() %>
                                </span>
                            </div>
                        </div>
                    </div>
                <% } %>
    </div>

            <% if (completedDiagnoses.size() > 6) { %>
                <div class="flex justify-center mt-6">
                    <button id="loadMoreBtn" class="bg-blue-50 text-blue-600 hover:bg-blue-100 px-4 py-2 rounded-lg transition flex items-center">
                        <i class="fas fa-chevron-down mr-2"></i> Load More Records
                    </button>
                </div>
            <% } %>
        <% } %>
    </div>

    <!-- Footer -->
    <footer class="mt-8 pt-8 border-t border-gray-200 text-center text-gray-500 text-sm">
        <div class="flex items-center justify-center mb-2">
            <i class="fas fa-hospital-alt text-blue-500 mr-2"></i>
            <span class="font-semibold text-gray-600">MBC Hospital</span>
        </div>
        <p>&copy; <%= new java.util.Date().getYear() + 1900 %> MBC Hospital. All rights reserved.</p>
        <p class="mt-1">Healthcare Management System</p>
    </footer>

</div>

<!-- Print functionality and responsive JavaScript -->
<script>
    function printPage() {
        window.print();
    }
    
    // Mobile menu toggle
    document.addEventListener('DOMContentLoaded', function() {
        // Mobile menu toggle
        const mobileMenuBtn = document.getElementById('mobile-menu-btn');
        if (mobileMenuBtn) {
            mobileMenuBtn.addEventListener('click', function() {
                const sidebar = document.querySelector('.sidebar');
                sidebar.classList.toggle('active');
                
                // Add overlay when sidebar is open
                let overlay = document.querySelector('.sidebar-overlay');
                if (!overlay && sidebar.classList.contains('active')) {
                    overlay = document.createElement('div');
                    overlay.className = 'sidebar-overlay fixed inset-0 bg-gray-800/50 z-40 lg:hidden';
                    document.body.appendChild(overlay);
                    
                    overlay.addEventListener('click', function() {
                        sidebar.classList.remove('active');
                        overlay.remove();
                    });
                } else if (overlay && !sidebar.classList.contains('active')) {
                    overlay.remove();
                }
            });
        }
        
        // Toggle view between grid and list for diagnosed patients
        const viewToggleBtn = document.getElementById('viewToggle');
        const viewToggleText = document.getElementById('viewToggleText');
        const diagnosisCards = document.getElementById('diagnosisCards');
        
        if (viewToggleBtn && diagnosisCards) {
            viewToggleBtn.addEventListener('click', function() {
                const isCompact = diagnosisCards.classList.contains('lg:grid-cols-3');
                
                if (isCompact) {
                    // Switch to expanded view
                    diagnosisCards.classList.remove('md:grid-cols-2', 'lg:grid-cols-3');
                    diagnosisCards.classList.add('md:grid-cols-1', 'lg:grid-cols-2');
                    viewToggleText.textContent = 'Expanded View';
                    viewToggleBtn.querySelector('i').classList.remove('fa-th-large');
                    viewToggleBtn.querySelector('i').classList.add('fa-th-list');
                } else {
                    // Switch to compact view
                    diagnosisCards.classList.remove('md:grid-cols-1', 'lg:grid-cols-2');
                    diagnosisCards.classList.add('md:grid-cols-2', 'lg:grid-cols-3');
                    viewToggleText.textContent = 'Compact View';
                    viewToggleBtn.querySelector('i').classList.remove('fa-th-list');
                    viewToggleBtn.querySelector('i').classList.add('fa-th-large');
                }
            });
        }
        
        // Load more functionality
        const loadMoreBtn = document.getElementById('loadMoreBtn');
        if (loadMoreBtn) {
            loadMoreBtn.addEventListener('click', function() {
                // This would typically load more records from the server
                // For demo purposes, we'll just toggle the button text
                if (loadMoreBtn.innerText.includes('Load More')) {
                    loadMoreBtn.innerHTML = '<i class="fas fa-chevron-up mr-2"></i> Show Less Records';
                } else {
                    loadMoreBtn.innerHTML = '<i class="fas fa-chevron-down mr-2"></i> Load More Records';
                }
            });
        }
        
        // Statistics counter animation
        const counters = document.querySelectorAll('.stats-card h3');
        counters.forEach(counter => {
            const target = parseInt(counter.innerText);
            let count = 0;
            const duration = 1500; // 1.5 seconds
            const increment = target / (duration / 16); // 60fps
            
            const timer = setInterval(() => {
                count += increment;
                if (count >= target) {
                    counter.innerText = target;
                    clearInterval(timer);
                } else {
                    counter.innerText = Math.floor(count);
                }
            }, 16);
        });
        
        // Highlight follow-up dates
        const today = new Date().toISOString().slice(0, 10);
        const followUpDates = document.querySelectorAll('[data-followup]');
        followUpDates.forEach(date => {
            if (date.getAttribute('data-followup') === today) {
                date.classList.add('bg-green-100');
                date.classList.add('font-bold');
            }
        });
        
        // Auto-dismiss alerts after 5 seconds
        const alerts = document.querySelectorAll('[role="alert"]');
        alerts.forEach(alert => {
            setTimeout(() => {
                alert.style.opacity = '0';
                setTimeout(() => alert.style.display = 'none', 500);
            }, 5000);
        });
    });
</script>

</body>
</html>
