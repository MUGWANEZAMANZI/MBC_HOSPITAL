<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.util.*, com.mbc_hospital.model.Patient" %>

<%
    if (session == null || session.getAttribute("username") == null || !session.getAttribute("usertype").equals("Doctor")) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = (String) session.getAttribute("username");
    String currentPage = (String) request.getAttribute("currentPage");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirmed Cases - MBC Hospital</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
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
                    }
                }
            }
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
        
        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        
        .status-positive {
            background-color: #dcfce7;
            color: #166534;
        }
        
        .status-negative {
            background-color: #fee2e2;
            color: #991b1b;
        }
        
        /* Mobile responsive */
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
            <a href="reffered" class="sidebar-link">
                <i class="fas fa-tachometer-alt w-6"></i>
                <span>Dashboard</span>
            </a>
            
            <p class="text-xs uppercase text-blue-300/70 font-semibold px-3 py-2 mt-4">Staff Management</p>
            <a href="view_nurses.jsp" class="sidebar-link">
                <i class="fas fa-clipboard-list w-6"></i>
                <span>Registered Nurses</span>
            </a>
            
            <p class="text-xs uppercase text-blue-300/70 font-semibold px-3 py-2 mt-4">Patient Care</p>
            <a href="referred-diagnoses" class="sidebar-link">
                <i class="fas fa-clipboard-check w-6"></i>
                <span>Awaiting Diagnosis</span>
            </a>
            <a href="confirmed-cases" class="sidebar-link active">
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
        <!-- Page Header -->
        <header class="flex justify-between items-center mb-8">
            <div>
                <h1 class="text-2xl font-bold text-gray-800">Confirmed Cases</h1>
                <p class="text-gray-600 mt-1">Patients with positive or negative diagnosis results</p>
            </div>
            <div class="flex items-center space-x-3">
                <div class="relative">
                    <input type="text" placeholder="Search patients..." class="pl-10 pr-4 py-2 border border-gray-300 rounded-full focus:outline-none focus:ring-2 focus:ring-primary-500 w-64">
                    <i class="fas fa-search absolute left-3 top-2.5 text-gray-400"></i>
                </div>
                <a href="dashboard" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition flex items-center">
                    <i class="fas fa-arrow-left mr-2"></i>
                    Back to Dashboard
                </a>
            </div>
        </header>

        <!-- Content -->
        <div class="bg-white rounded-xl shadow-sm p-6 mb-6">
            <div class="flex justify-between items-center mb-6">
                <div>
                    <h2 class="text-xl font-semibold text-gray-800 flex items-center">
                        <i class="fas fa-clipboard-check text-green-600 mr-2"></i>
                        Confirmed Diagnosis Records
                    </h2>
                    <p class="text-sm text-gray-500 mt-1">
                        These patients have received a final diagnosis. Click "View Full Diagnosis" for detailed medical reports.
                    </p>
                </div>
                <div class="flex space-x-2">
                    <span class="px-3 py-1 bg-green-100 text-green-800 rounded-full text-sm font-medium">
                        <i class="fas fa-check-circle mr-1"></i>
                        <%= request.getAttribute("confirmedCasesCount") %> Confirmed Case(s)
                    </span>
                </div>
            </div>

            <!-- Information banner -->
            <div class="bg-blue-50 border-l-4 border-blue-500 p-4 mb-6 rounded-r-md">
                <div class="flex">
                    <div class="flex-shrink-0">
                        <i class="fas fa-info-circle text-blue-500 mt-0.5"></i>
                    </div>
                    <div class="ml-3">
                        <p class="text-sm text-blue-700">
                            Click <strong>"View Full Diagnosis"</strong> to see complete patient diagnosis details, including prescribed medications, follow-up appointments, and doctor's notes.
                        </p>
                    </div>
                </div>
            </div>
            
            <!-- Table of confirmed cases -->
            <div class="table-container bg-white">
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Patient</th>
                            <th>Contact</th>
                            <th>Diagnosis Status</th>
                            <th>Diagnosis Result</th>
                            <th>Registered By</th>
                            <th class="text-center">Medical Records</th>
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
                                        <div>
                                            <div class="flex items-center">
                                                <i class="fas fa-phone text-gray-400 mr-2"></i>
                                                <%= p.getTelephone() %>
                                            </div>
                                            <div class="flex items-center mt-1 text-xs text-gray-500">
                                                <i class="fas fa-envelope text-gray-400 mr-2"></i>
                                                <%= p.getEmail() %>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="status-badge <%= "Positive".equals(p.getDiagnosisStatus()) ? "status-positive" : "status-negative" %>">
                                            <i class="fas <%= "Positive".equals(p.getDiagnosisStatus()) ? "fa-plus-circle" : "fa-minus-circle" %> mr-1"></i>
                                            <%= p.getDiagnosisStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="max-w-xs truncate">
                                            <%= p.getDiagnosisResult() %>
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
                                        <a href="view-diagnosis?id=<%= p.getDiagnosisID() %>" 
                                           class="px-3 py-1.5 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition flex items-center justify-center w-full">
                                            <i class="fas fa-file-medical-alt mr-1.5"></i> View Full Diagnosis
                                        </a>
                                    </td>
                                </tr>
                        <% } 
                        } else { %>
                            <tr>
                                <td colspan="7" class="py-8 text-center text-gray-500">
                                    <div class="flex flex-col items-center justify-center">
                                        <i class="fas fa-clipboard-check text-gray-300 text-5xl mb-3"></i>
                                        <p>No confirmed cases found at the moment.</p>
                                        <p class="text-sm text-gray-400 mt-1">Completed diagnoses will appear here.</p>
                                        <a href="dashboard" class="mt-3 text-primary-600 hover:text-primary-800 flex items-center">
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
    </div>

    <script>
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
    </script>
</body>
</html> 