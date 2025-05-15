<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.util.*, com.mbc_hospital.model.Patient" %>


<%@ page import="java.util.*" %>

<%
    //HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("username") == null || !session.getAttribute("usertype").equals("Doctor")) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = (String) session.getAttribute("username");
%>

<%
    List<String> doctorList = (List<String>) session.getAttribute("doctorList");
    List<String> nurseList = (List<String>) session.getAttribute("nurseList");
    Integer doctorCount_ = (Integer) session.getAttribute("doctorCount");
    Integer nurseCount_ = (Integer) session.getAttribute("nurseCount");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard - MBC Hospital</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.tailwindcss.com"></script>
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
                        'pulse-slow': 'pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite',
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
        
        .modal-backdrop {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.6);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 50;
            backdrop-filter: blur(4px);
        }
        
        .modal-content {
            background: white;
            border-radius: 12px;
            max-width: 600px;
            width: 100%;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            transition: all 0.3s ease;
            transform: scale(0.95);
            opacity: 0;
            animation: modalFadeIn 0.3s ease forwards;
        }
        
        @keyframes modalFadeIn {
            to {
                opacity: 1;
                transform: scale(1);
            }
        }
        
        .btn {
            padding: 0.6rem 1.2rem;
            border-radius: 0.5rem;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        
        .btn-primary {
            background-color: #3b82f6;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #2563eb;
            box-shadow: 0 4px 6px rgba(37, 99, 235, 0.2);
        }
        
        .btn-outline {
            border: 1px solid #d1d5db;
            color: #4b5563;
        }
        
        .btn-outline:hover {
            background-color: #f3f4f6;
            color: #1f2937;
        }
        
        .table-container {
            overflow-x: auto;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            border: 1px solid rgba(0, 0, 0, 0.02);
        }
        
        .table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }
        
        .table th {
            background-color: #f8fafc;
            padding: 0.85rem 1.25rem;
            text-align: left;
            font-weight: 600;
            color: #475569;
            border-bottom: 1px solid #e2e8f0;
            position: relative;
        }
        
        .table th:after {
            content: '';
            position: absolute;
            left: 0;
            right: 0;
            bottom: 0;
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(59, 130, 246, 0.2), transparent);
        }
        
        .table td {
            padding: 0.85rem 1.25rem;
            border-bottom: 1px solid #e2e8f0;
            color: #1e293b;
            vertical-align: middle;
        }
        
        .table tr:last-child td {
            border-bottom: none;
        }
        
        .table tr:hover {
            background-color: #f1f5f9;
        }
        
        /* Additional responsive styles */
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
    </style>
</head>
<body class="antialiased bg-gray-50">
    <!-- Modal for diagnosis submission -->
    <div id="diagnosisModal" class="modal-backdrop hidden">
        <div class="modal-content animate-slide-up max-w-2xl">
            <div class="p-6 border-b border-gray-200 bg-gradient-to-r from-blue-50 to-blue-100">
                <div class="flex justify-between items-center">
                    <h3 class="text-xl font-semibold text-gray-800 flex items-center">
                        <i class="fas fa-stethoscope text-blue-600 mr-2"></i>
                        Patient Diagnosis: <span id="patientName" class="text-primary-600 ml-1"></span>
                    </h3>
                    <button onclick="closeDiagnosisModal('diagnosisModal')" class="text-gray-500 hover:text-gray-700 bg-white rounded-full h-8 w-8 flex items-center justify-center transition-colors">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>
            
            <div class="p-6">
                <form id="diagnosisForm" class="space-y-4" method="post" action="update-diagnosis">
                    <input type="hidden" name="patientID" id="patientID" value="">
                    <input type="hidden" name="diagnosisID" id="diagnosisID" value="">
                    
                    <div class="bg-blue-50 p-4 rounded-lg mb-6 border border-blue-200">
                        <div class="flex items-start">
                            <div class="flex-shrink-0 mt-0.5 h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
                                <i class="fas fa-clipboard-list"></i>
                            </div>
                            <div class="ml-3">
                                <h3 class="text-sm font-medium text-blue-800">Nurse's Initial Assessment</h3>
                                <div class="mt-2 text-sm text-blue-700 bg-white p-3 rounded border border-blue-100">
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label class="block text-sm font-medium text-gray-700 mb-2">Diagnosis Decision</label>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <label class="flex p-4 border border-gray-200 rounded-lg cursor-pointer hover:bg-gray-50 transition-colors">
                                <input type="radio" name="diagnoStatus" value="Positive" class="form-radio h-5 w-5 text-primary-600 mt-0.5">
                                <div class="ml-3">
                                    <span class="block font-medium text-gray-900">Positive</span>
                                    <span class="text-sm text-gray-500">Patient requires treatment</span>
                                </div>
                            </label>
                            <label class="flex p-4 border border-gray-200 rounded-lg cursor-pointer hover:bg-gray-50 transition-colors">
                                <input type="radio" name="diagnoStatus" value="Negative" class="form-radio h-5 w-5 text-primary-600 mt-0.5">
                                <div class="ml-3">
                                    <span class="block font-medium text-gray-900">Negative</span>
                                    <span class="text-sm text-gray-500">Patient is healthy</span>
                                </div>
                            </label>
                        </div>
                    </div>
                    
                    <div class="mb-6">
                        <label for="result" class="block text-sm font-medium text-gray-700 mb-2">Diagnosis Results & Notes</label>
                        <textarea id="result" name="result" rows="4" 
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition duration-200"
                            placeholder="Enter detailed diagnosis results and any instructions for the patient..."></textarea>
                    </div>
                    
                    <div class="mb-4">
                        <label for="medicationsPrescribed" class="block text-sm font-medium text-gray-700 mb-2">
                            <i class="fas fa-pills text-blue-500 mr-1"></i> Medications Prescribed (if any)
                        </label>
                        <input type="text" id="medicationsPrescribed" name="medicationsPrescribed" 
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                               placeholder="e.g., Amoxicillin 500mg, 3 times daily for 7 days">
                    </div>
                    
                    <div class="mb-4">
                        <label for="followUpDate" class="block text-sm font-medium text-gray-700 mb-2">
                            <i class="fas fa-calendar-check text-blue-500 mr-1"></i> Follow-up Date (if required)
                        </label>
                        <input type="date" id="followUpDate" name="followUpDate" 
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500">
                    </div>
                    
                    <div class="flex justify-end space-x-3 mt-6 pt-4 border-t border-gray-100">
                        <button type="button" onclick="closeDiagnosisModal('diagnosisModal')" 
                            class="btn btn-outline">
                            <i class="fas fa-times mr-2"></i>
                            Cancel
                        </button>
                        <button type="submit" id="diagnosisSubmitBtn"
                            class="btn btn-primary">
                            <i class="fas fa-paper-plane mr-2"></i>
                            Submit Diagnosis
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <a href="dashboard" class="flex items-center">
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
                    <p class="font-semibold"><%= username %></p>
                    <span class="inline-block mt-1 text-xs bg-blue-800/40 rounded-full px-2 py-0.5">Doctor</span>
                </div>
            </div>
        </div>

        <nav class="space-y-1">
            <p class="text-xs uppercase text-blue-300/70 font-semibold px-3 py-2">Main Navigation</p>
            <a href="#" class="sidebar-link active">
                <i class="fas fa-tachometer-alt w-6"></i>
                <span>Dashboard</span>
            </a>
            
            <p class="text-xs uppercase text-blue-300/70 font-semibold px-3 py-2 mt-4">Staff Management</p>
            <a href="view_nurses.jsp" class="sidebar-link">
                <i class="fas fa-user-nurse w-6"></i>
                <span>Registered Nurses</span>
            </a>
            <a href="unverified_nurses.jsp" class="sidebar-link">
                <i class="fas fa-user-check w-6"></i>
                <span>Verify Nurses</span>
            </a>
            
            <p class="text-xs uppercase text-blue-300/70 font-semibold px-3 py-2 mt-4">Patient Care</p>
            <a href="referred-diagnoses" class="sidebar-link">
                <i class="fas fa-clipboard-check w-6"></i>
                <span>Awaiting Diagnosis</span>
            </a>
            <a href="confirmed-cases" class="sidebar-link">
                <i class="fas fa-check-circle w-6"></i>
                <span>Confirmed Cases</span>
            </a>
            <a href="all-patients" class="sidebar-link">
                <i class="fas fa-hospital-user w-6"></i>
                <span>All Patients</span>
            </a>
            
            <a href="DiagnosisViewServlet" class="sidebar-link">
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

    <!-- Main Content -->
    <div class="main-content">
        <!-- Header with search and notification -->
        <header class="flex justify-between items-center mb-8 bg-white p-4 rounded-xl shadow-sm">
            <div class="flex items-center">
                <button id="mobile-menu-btn" class="lg:hidden mr-3 text-gray-600">
                    <i class="fas fa-bars text-xl"></i>
                </button>
                <h1 class="text-2xl font-bold text-gray-800">Doctor Dashboard</h1>
            </div>
            <div class="flex items-center">
                <div class="h-8 w-8 bg-blue-100 rounded-full flex items-center justify-center text-blue-600">
                    <i class="fas fa-user-md"></i>
                </div>
            </div>
        </header>

        <!-- Dashboard Content -->
        <main class="space-y-8">
            <%
                java.net.URL nurseUrl = new java.net.URL("http://localhost:8080/MBC_HOSPITAL/nurse-count");
                java.io.BufferedReader nurseIn = new java.io.BufferedReader(new java.io.InputStreamReader(nurseUrl.openStream()));
                String nurseCount = nurseIn.readLine();
                nurseIn.close();
                
                java.net.URL url2 = new java.net.URL("http://localhost:8080/MBC_HOSPITAL/patient-count");
                java.io.BufferedReader in1 = new java.io.BufferedReader(new java.io.InputStreamReader(url2.openStream()));
                String patientCount = in1.readLine();
                in1.close();
            %>
            
            <!-- Stats Cards -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <div class="stats-card animate-fade-in" style="animation-delay: 0.1s">
                    <div class="flex items-center space-x-4">
                        <div class="p-3 rounded-full bg-blue-100 text-blue-600">
                            <i class="fas fa-user-nurse text-2xl"></i>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500 font-medium">Registered Nurses</p>
                            <div class="flex items-end">
                                <h3 class="text-2xl font-bold text-gray-800"><%= nurseCount %></h3>
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
                                <h3 class="text-2xl font-bold text-gray-800">
                                    <%
                                        java.net.URL pendingUrl = new java.net.URL("http://localhost:8080/MBC_HOSPITAL/pending-cases-count");
                                        java.io.BufferedReader pendingIn = new java.io.BufferedReader(new java.io.InputStreamReader(pendingUrl.openStream()));
                                        String pendingCasesCount = pendingIn.readLine();
                                        pendingIn.close();
                                        out.print(pendingCasesCount != null ? pendingCasesCount : "NaN");
                                    %>
                                </h3>
                                <span class="text-xs text-amber-600 font-semibold ml-2 mb-1 flex items-center">
                                    <i class="fas fa-clock mr-1"></i>Needs Review
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="mt-4 pt-3 border-t border-gray-100">
                        <a href="referred-diagnoses" class="text-sm text-blue-600 hover:text-blue-700 flex items-center">
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
                                <h3 class="text-2xl font-bold text-gray-800">
                                    <%
                                        java.net.URL confirmedUrl = new java.net.URL("http://localhost:8080/MBC_HOSPITAL/confirmed-cases-count");
                                        java.io.BufferedReader confirmedIn = new java.io.BufferedReader(new java.io.InputStreamReader(confirmedUrl.openStream()));
                                        String confirmedCasesCount = confirmedIn.readLine();
                                        confirmedIn.close();
                                        out.print(confirmedCasesCount != null ? confirmedCasesCount : "NaN");
                                    %>
                                </h3>
                                <span class="text-xs text-green-600 font-semibold ml-2 mb-1 flex items-center">
                                    <i class="fas fa-arrow-up mr-1"></i>5%
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
                            <i class="fas fa-hospital-user text-2xl"></i>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500 font-medium">Total Patients</p>
                            <div class="flex items-end">
                                <h3 class="text-2xl font-bold text-gray-800"><%= patientCount %></h3>
                                <span class="text-xs text-indigo-600 font-semibold ml-2 mb-1 flex items-center">
                                    <i class="fas fa-chart-line mr-1"></i>Today
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
            
            <!-- Recent Transferred Cases Section -->
            <div class="animate-fade-in" style="animation-delay: 0.6s">
                <div class="bg-white rounded-xl shadow-sm p-6 mb-6">
                    <div class="flex justify-between items-center mb-6">
                        <div>
                            <h2 class="text-xl font-semibold text-gray-800">Recent Transferred Cases</h2>
                            <p class="text-sm text-gray-500 mt-1">Cases requiring your diagnosis and treatment decision</p>
                        </div>
                        <div class="flex space-x-2">
                            <button id="openTransferredCasesBtn" class="btn btn-primary">
                                <i class="fas fa-clipboard-list mr-2"></i>
                                View All Cases
                            </button>
                            <a href="DiagnosisViewServlet" class="btn btn-outline">
                                <i class="fas fa-stethoscope mr-2"></i>
                                Diagnosis Records
                            </a>
                        </div>
                    </div>
                    
                    <!-- Table of patients -->
                    <div class="table-container bg-white">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Patient Name</th>
                                    <th>Contact</th>
                                    <th>Email</th>
                                    <th>Address</th>
                                    <th>Registered By</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                List<Patient> patients = (List<Patient>) request.getAttribute("patients");
                                if (patients != null && !patients.isEmpty()) { 
                                    for (Patient p : patients) { %>
                                        <tr>
                                            <td><%= p.getPatientID() %></td>
                                            <td>
                                                <div class="flex items-center">
                                                    <div class="h-9 w-9 bg-primary-100 rounded-full flex items-center justify-center mr-3">
                                                        <i class="fas fa-user text-primary-600"></i>
                                                    </div>
                                                    <div>
                                                        <span class="font-medium text-gray-900"><%= p.getFirstName() + " " + p.getLastName() %></span>
                                                        <p class="text-xs text-gray-500">Patient ID: #<%= p.getPatientID() %></p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="flex items-center">
                                                    <i class="fas fa-phone text-gray-400 mr-2"></i>
                                                    <%= p.getTelephone() %>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="flex items-center">
                                                    <i class="fas fa-envelope text-gray-400 mr-2"></i>
                                                    <%= p.getEmail() %>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="flex items-center">
                                                    <i class="fas fa-map-marker-alt text-gray-400 mr-2"></i>
                                                    <%= p.getAddress() %>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="flex items-center">
                                                    <div class="h-7 w-7 bg-green-100 rounded-full flex items-center justify-center mr-2">
                                                        <i class="fas fa-user-nurse text-green-600"></i>
                                                    </div>
                                                    <div>
                                                        <span class="font-medium"><%= p.getRegisteredByName() %></span>
                                                        <p class="text-xs text-gray-500">Nurse</p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <button 
                                                    data-diagnose
                                                    data-patient-id="<%= p.getPatientID() %>"
                                                    data-patient-name="<%= p.getFirstName() %> <%= p.getLastName() %>"
                                                    data-target-modal="diagnosisModal"
                                                    class="btn btn-primary py-1 px-3 text-sm">
                                                    <i class="fas fa-stethoscope mr-1"></i> Diagnose
                                                </button>
                                            </td>
                                        </tr>
                                <% } 
                                } else { %>
                                    <tr>
                                        <td colspan="7" class="py-8 text-center text-gray-500">
                                            <div class="flex flex-col items-center justify-center">
                                                <i class="fas fa-folder-open text-gray-300 text-5xl mb-3"></i>
                                                <p>No pending cases found at the moment.</p>
                                                <p class="text-sm text-gray-400 mt-1">You're all caught up!</p>
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
                    
                    <% if (patients != null && !patients.isEmpty() && patients.size() > 5) { %>
                        <div class="mt-4 flex justify-center">
                            <button class="text-blue-600 hover:text-blue-800 flex items-center">
                                <span>View All Patients</span>
                                <i class="fas fa-chevron-down ml-1"></i>
                            </button>
                        </div>
                    <% } %>
                </div>
                
                <!-- Quick Actions Section -->
                <div class="grid grid-cols-1 gap-6 mb-8">
                    <!-- Quick Actions -->
                    <div class="bg-white rounded-xl shadow-sm p-6">
                        <h3 class="font-semibold text-gray-800 mb-4">Quick Actions</h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <a href="all-patients" class="flex items-center p-4 bg-green-50 rounded-lg hover:bg-green-100 transition">
                                <div class="w-10 h-10 rounded-full bg-green-200 flex items-center justify-center text-green-700 mr-3">
                                    <i class="fas fa-search"></i>
                                </div>
                                <span class="font-medium">Find Patient Records</span>
                            </a>
                            <a href="referred-diagnoses" class="flex items-center p-4 bg-yellow-50 rounded-lg hover:bg-yellow-100 transition">
                                <div class="w-10 h-10 rounded-full bg-yellow-200 flex items-center justify-center text-yellow-700 mr-3">
                                    <i class="fas fa-tasks"></i>
                                </div>
                                <span class="font-medium">Review Pending Cases</span>
                            </a>
                            <a href="confirmed-cases" class="flex items-center p-4 bg-blue-50 rounded-lg hover:bg-blue-100 transition">
                                <div class="w-10 h-10 rounded-full bg-blue-200 flex items-center justify-center text-blue-700 mr-3">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <span class="font-medium">View Confirmed Cases</span>
                            </a>
                            <a href="DiagnosisViewServlet" class="flex items-center p-4 bg-purple-50 rounded-lg hover:bg-purple-100 transition">
                                <div class="w-10 h-10 rounded-full bg-purple-200 flex items-center justify-center text-purple-700 mr-3">
                                    <i class="fas fa-stethoscope"></i>
                                </div>
                                <span class="font-medium">Diagnosis Records</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <footer class="mt-8 pt-6 border-t border-gray-200 text-center text-gray-500 text-sm">
            <div class="flex items-center justify-center mb-2">
                <i class="fas fa-hospital-alt text-blue-500 mr-2"></i>
                <span class="font-semibold text-gray-600">MBC Hospital</span>
            </div>
            <p>&copy; 2025 MBC Hospital Healthcare Management System. All rights reserved.</p>
        </footer>
    </div>

    <script>
        // Event listener for the "View Transferred Cases" button
        document.getElementById('openTransferredCasesBtn').addEventListener('click', function() {
            window.location.href = 'referred-diagnoses';
        });
        
        // Setup form submission
        document.addEventListener('DOMContentLoaded', function() {
            const diagnosisForm = document.getElementById('diagnosisForm');
            
            diagnosisForm.addEventListener('submit', function(e) {
                e.preventDefault();
                submitDiagnosis(this, 'referred-diagnoses');
            });
            
            // Add event listeners to all diagnose buttons
            const diagnoseButtons = document.querySelectorAll('[data-diagnose]');
            diagnoseButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const patientId = this.getAttribute('data-patient-id');
                    const patientName = this.getAttribute('data-patient-name');
                    const targetModal = this.getAttribute('data-target-modal');
                    
                    // Set the patient ID in the form
                    document.getElementById('patientID').value = patientId;
                    
                    // Set the patient name in the modal
                    document.getElementById('patientName').textContent = patientName;
                    
                    // Fetch the nurse assessment for this patient
                    fetchNurseAssessment(patientId);
                    
                    // Show the modal
                    document.getElementById(targetModal).classList.remove('hidden');
                });
            });
        });
        
        // Function to fetch nurse assessment for a patient
        function fetchNurseAssessment(patientId) {
            const nurseAssessmentElement = document.getElementById('nurseAssessment');
            nurseAssessmentElement.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i> Loading assessment...';
            
            fetch(`getNurseAssessment?patientId=${patientId}`)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.text();
                })
                .then(data => {
                    if (data && data.trim() !== '') {
                        nurseAssessmentElement.textContent = data;
                    } else {
                        nurseAssessmentElement.innerHTML = '<i class="fas fa-info-circle text-blue-500 mr-2"></i> No nurse assessment available for this patient.';
                    }
                })
                .catch(error => {
                    console.error('Error fetching nurse assessment:', error);
                    nurseAssessmentElement.innerHTML = '<i class="fas fa-exclamation-triangle text-amber-500 mr-2"></i> Unable to load nurse assessment.';
                });
        }
        
        // Function to close the diagnosis modal
        function closeDiagnosisModal(modalId) {
            const modal = document.getElementById(modalId);
            if (modal) {
                modal.classList.add('hidden');
                // Reset the form
                const form = modal.querySelector('form');
                if (form) form.reset();
                // Clear patient name and assessment
                document.getElementById('patientName').textContent = '';
                document.getElementById('nurseAssessment').textContent = 'Please select a patient to view their assessment';
            }
        }
        
        // Function to submit diagnosis form
        function submitDiagnosis(form, redirectPage) {
            const formData = new FormData(form);
            const patientID = formData.get('patientID');
            const diagnoStatus = formData.get('diagnoStatus');
            const result = formData.get('result');
            const medicationsPrescribed = formData.get('medicationsPrescribed');
            const followUpDate = formData.get('followUpDate');
            
            // Basic validation
            if (!diagnoStatus) {
                alert('Please select a diagnosis status');
                return false;
            }
            
            if (!result || result.trim() === '') {
                alert('Please provide diagnosis results');
                return false;
            }
            
            // Create URL-encoded form data for submission
            const params = new URLSearchParams();
            params.append('patientID', patientID);
            params.append('diagnoStatus', diagnoStatus);
            params.append('result', result);
            params.append('medicationsPrescribed', medicationsPrescribed || '');
            params.append('followUpDate', followUpDate || '');
            
            // Submit the form via AJAX
            fetch('update-diagnosis', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params.toString()
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.text();
            })
            .then(data => {
                // Close the modal
                closeDiagnosisModal('diagnosisModal');
                
                // Show success message
                alert('Diagnosis submitted successfully');
                
                // Redirect to the specified page
                if (redirectPage) {
                    window.location.href = redirectPage;
                }
            })
            .catch(error => {
                console.error('Error submitting diagnosis:', error);
                alert('Failed to submit diagnosis. Please try again.');
            });
            
            return false;
        }
        
        // Mobile sidebar toggle
        document.addEventListener('DOMContentLoaded', function() {
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
        });
        
        // Statistics counter animation
        document.addEventListener('DOMContentLoaded', function() {
            const counters = document.querySelectorAll('.stats-card h3');
            counters.forEach(counter => {
                const target = parseInt(counter.innerText);
                let count = 0;
                const duration = 2000; // 2 seconds
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
        });
    </script>
</body>
</html>
