<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // Redirect if not logged in
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String userType = (String) session.getAttribute("usertype");
    if (userType == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get the solved cases from the request
    @SuppressWarnings("unchecked")
    List<Map<String, Object>> solvedCases = 
        (List<Map<String, Object>>) request.getAttribute("solvedCases");
    
    // Format for dates
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cases Solved by Doctors | MBC Hospital</title>
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
        .status-positive {
            background-color: rgba(16, 185, 129, 0.1);
            color: rgb(16, 185, 129);
        }
        .status-negative {
            background-color: rgba(239, 68, 68, 0.1);
            color: rgb(239, 68, 68);
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
                <a href="verified-doctors" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                    <i class="fas fa-user-md w-6"></i>
                    <span>Doctors</span>
                </a>
                <a href="view_nurses.jsp" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                    <i class="fas fa-user-nurse w-6"></i>
                    <span>Nurses</span>
                </a>
                <a href="users-directory" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                    <i class="fas fa-users w-6"></i>
                    <span>User directory</span>
                </a>
                <a href="doctor-solved-cases" class="sidebar-link active flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                    <i class="fas fa-stethoscope w-6"></i>
                    <span>Doctor Cases</span>
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
                <h1 class="text-xl font-bold text-gray-800 ml-4">Cases Solved by Doctors</h1>
            </div>
            
            <div class="hidden lg:block">
                <h1 class="text-xl font-bold text-gray-800">Cases Solved by Doctors</h1>
            </div>
            
            <div class="flex items-center space-x-4">
                <div class="relative">
                    <a href="dashboard.jsp" class="text-blue-600 hover:text-blue-800">
                        <i class="fas fa-arrow-left mr-2"></i>Back to Dashboard
                    </a>
                </div>
            </div>
        </header>

        <!-- Main Content Area -->
        <main class="p-6 pb-16">
            <!-- Header Section -->
            <div class="bg-white rounded-xl shadow-md p-6 mb-6 animate-fade-in">
                <h2 class="text-xl font-bold text-gray-800">Cases Solved by Doctors</h2>
                <p class="text-gray-600 mt-1">View all cases that have been resolved (Positive or Negative) by doctors.</p>
            </div>
            
            <!-- Table Section -->
            <div class="bg-white rounded-xl shadow-md overflow-hidden animate-fade-in">
                <div class="p-4 border-b border-gray-200 bg-gray-50">
                    <div class="flex justify-between items-center">
                        <h3 class="text-lg font-semibold text-gray-700">Resolved Cases List</h3>
                        <div class="text-gray-500 text-sm">
                            Total: <%= solvedCases != null ? solvedCases.size() : 0 %> cases
                        </div>
                    </div>
                </div>
                
                <% if (solvedCases != null && !solvedCases.isEmpty()) { %>
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Patient</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Doctor</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Result</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <% for (Map<String, Object> caseInfo : solvedCases) { %>
                                    <tr class="hover:bg-gray-50">
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                            <%= caseInfo.get("diagnosisID") %>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            <%= caseInfo.get("patientName") %>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            <%= caseInfo.get("doctorName") %>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <% 
                                            String status = (String) caseInfo.get("status");
                                            String statusClass = status.equals("Positive") ? "status-positive" : "status-negative";
                                            %>
                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full <%= statusClass %>">
                                                <%= status %>
                                            </span>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            <%= caseInfo.get("result") %>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            <%= dateFormat.format(caseInfo.get("date")) %>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div class="text-center py-10">
                        <div class="text-gray-500">
                            <i class="fas fa-clipboard-check text-4xl mb-3"></i>
                            <p>No cases solved by doctors found.</p>
                        </div>
                    </div>
                <% } %>
            </div>
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
                    <a href="verified-doctors" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                        <i class="fas fa-user-md w-6"></i>
                        <span>Doctors</span>
                    </a>
                    <a href="doctor-solved-cases" class="sidebar-link active flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                        <i class="fas fa-stethoscope w-6"></i>
                        <span>Doctor Cases</span>
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