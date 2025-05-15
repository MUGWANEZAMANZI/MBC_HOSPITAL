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
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
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
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <a href="nurse.jsp" class="flex items-center">
                <i class="fas fa-hospital text-white text-3xl mr-3"></i>
                <h1 class="text-2xl font-bold">MBC Hospital</h1>
            </a>
            <p class="text-sm text-blue-200 mt-1">Healthcare Management System</p>
        </div>
        
        <div class="sidebar-user">
            <div class="flex items-center space-x-3">
                <div class="h-12 w-12 rounded-full bg-white/20 flex items-center justify-center">
                    <i class="fas fa-user-nurse text-2xl"></i>
                </div>
                <div>
                    <p class="text-sm text-blue-200">Logged in as</p>
                    <p class="font-semibold"><%= session.getAttribute("username") %></p>
                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-200 text-blue-800 mt-1">
                        Nurse
                    </span>
                </div>
            </div>
        </div>
        
        <nav class="space-y-1">
            <a href="nurse.jsp" class="sidebar-link">
                <i class="fas fa-tachometer-alt w-5 h-5 mr-3"></i>
                <span>Dashboard</span>
            </a>
            <a href="create_patient.jsp" class="sidebar-link">
                <i class="fas fa-user-plus w-5 h-5 mr-3"></i>
                <span>Register Patient</span>
            </a>
            <a href="nurse-action-cases" class="sidebar-link">
                <i class="fas fa-clipboard-list w-5 h-5 mr-3"></i>
                <span>Cases Requiring Action</span>
            </a>
            <a href="nurse-referred-cases" class="sidebar-link">
                <i class="fas fa-share w-5 h-5 mr-3"></i>
                <span>Referred Cases</span>
            </a>
            <a href="nurse-completed-cases" class="sidebar-link active">
                <i class="fas fa-check-circle w-5 h-5 mr-3"></i>
                <span>Nurse-Completed Cases</span>
            </a>
            <a href="nurse-view-diagnoses" class="sidebar-link">
                <i class="fas fa-clipboard-check w-5 h-5 mr-3"></i>
                <span>All Diagnosis Results</span>
            </a>
            <div class="pt-4 mt-4 border-t border-blue-800/30">
                <a href="logout.jsp" class="sidebar-link text-red-100 bg-red-500/20 hover:bg-red-500/30">
                    <i class="fas fa-sign-out-alt w-5 h-5 mr-3"></i>
                    <span>Logout</span>
                </a>
            </div>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="flex justify-between items-center mb-6">
            <div>
                <h1 class="text-2xl font-bold text-gray-800">
                    <i class="fas fa-check-circle mr-3 text-green-600"></i>
                    Nurse-Completed Cases
                </h1>
                <p class="text-gray-600">Cases diagnosed and completed by nurses without doctor referral</p>
            </div>
            <div class="flex items-center space-x-4">
                <a href="nurse.jsp" class="btn btn-outline">
                    <i class="fas fa-arrow-left mr-2"></i>
                    Back to Dashboard
                </a>
            </div>
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
        <div class="bg-green-50 border-l-4 border-green-500 p-4 mb-6 rounded-md shadow-sm animate-fade-in">
            <div class="flex">
                <div class="flex-shrink-0">
                    <i class="fas fa-info-circle text-green-500"></i>
                </div>
                <div class="ml-3">
                    <p class="text-sm text-green-700">
                        Found <%= caseCount %> cases completed by nurses without doctor referral.
                    </p>
                </div>
            </div>
        </div>

        <!-- Cases Table -->
        <div class="bg-white rounded-xl shadow-lg overflow-hidden mt-6 animate-fade-in" style="animation-delay: 0.2s">
            <div class="p-6">
                <table class="table min-w-full bg-white">
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
                                   class="px-3 py-1 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition flex items-center text-sm w-fit">
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
                                    <div class="inline-flex h-20 w-20 rounded-full bg-green-100 text-green-600 items-center justify-center mb-4">
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
        
        <!-- Footer -->
        <footer class="mt-12 text-center text-gray-500 text-sm">
            <p>&copy; 2025 MBC Hospital System. All rights reserved.</p>
        </footer>
    </main>
</body>
</html> 