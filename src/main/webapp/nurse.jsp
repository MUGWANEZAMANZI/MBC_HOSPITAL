<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.URL"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nurse Dashboard | MBC Hospital</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
    <style>
        .dashboard-card {
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }
        .gradient-bg {
            background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);
        }
        .card-1 { border-left-color: #3b82f6; }
        .card-2 { border-left-color: #10b981; }
        .card-3 { border-left-color: #8b5cf6; }
        .card-4 { border-left-color: #f59e0b; }
        .card-5 { border-left-color: #ef4444; }
        .card-6 { border-left-color: #ec4899; }
        .card-7 { border-left-color: #6366f1; }
        .card-8 { border-left-color: #14b8a6; }
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
        .card-icon {
            transition: all 0.3s ease;
        }
        .dashboard-card:hover .card-icon {
            transform: scale(1.1);
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
                <a href="#" class="sidebar-link active flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                    <i class="fas fa-tachometer-alt w-6"></i>
                    <span>Dashboard</span>
                </a>
                
                <a href="create_patient.jsp" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                    <i class="fas fa-user-plus w-6"></i>
                    <span>new patient</span>
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
                <h1 class="text-xl font-bold text-gray-800 ml-4">Nurse Dashboard</h1>
            </div>
            
            <div class="hidden lg:block">
                <h1 class="text-xl font-bold text-gray-800">Nurse Dashboard</h1>
            </div>
            
            <div class="flex items-center space-x-4">
                <div class="relative">
                    <input type="text" placeholder="Search..." class="rounded-full pl-10 pr-4 py-2 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500 w-40 md:w-64">
                    <i class="fas fa-search absolute left-3 top-2.5 text-gray-400"></i>
                </div>
                
                
                <div class="relative">
                    <button class="flex items-center space-x-2">
                        <div class="w-8 h-8 rounded-full bg-blue-600 flex items-center justify-center text-white">
                            <i class="fas fa-user-shield"></i>
                        </div>
                        <span class="hidden md:inline text-gray-700"><%= session.getAttribute("username") %></span>
                        <i class="fas fa-chevron-down text-gray-500 text-sm"></i>
                    </button>
                </div>
            </div>
        </header>

        <!-- Dashboard Content -->
        <main class="p-6 pb-16">
            <!-- Quick Stats -->
            <%
                   java.net.URL url2 = new java.net.URL("http://localhost:8080/MBC_HOSPITAL/patient-count");
                   java.io.BufferedReader in1 = new java.io.BufferedReader(new java.io.InputStreamReader(url2.openStream()));
                   String patientCount = in1.readLine();
                   in1.close();
                 %>
               
             <%
    String referrableCaseCount = "N/A";
    try {
        java.net.URL url3 = new java.net.URL("http://localhost:8080/MBC_HOSPITAL/referrable-case-count");
        java.io.BufferedReader in3 = new java.io.BufferedReader(new java.io.InputStreamReader(url3.openStream()));
        referrableCaseCount = in3.readLine();
        in3.close();
    } catch (Exception e) {
        referrableCaseCount = "Error: " + e.getMessage();
        e.printStackTrace(); // This logs to server logs
    }
%>
<%
    java.net.URL url4 = new java.net.URL("http://localhost:8080/MBC_HOSPITAL/non-referrable-case-count");
    java.io.BufferedReader in4 = new java.io.BufferedReader(new java.io.InputStreamReader(url4.openStream()));
    String nonReferrableCaseCount = in4.readLine();
    in4.close();
%>

               
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                <div class="bg-white rounded-lg shadow-md p-6 flex items-center space-x-4 animate-fade-in" style="animation-delay: 0.1s">
                    <div class="p-3 rounded-full bg-blue-100 text-blue-600">
                        <i class="fas fa-user-md text-2xl"></i>
                    </div>
                    <div>
                        <p class="text-sm text-gray-500">Total cases</p>
                          <h3 class="text-2xl font-bold"><%=patientCount %> </h3>
                        <p class="text-xs text-green-500 flex items-center mt-1">
                            <i class="fas fa-arrow-up mr-1"></i> 8% from last month
                        </p>
                    </div>
                </div>
                
                
                <div class="bg-white rounded-lg shadow-md p-6 flex items-center space-x-4 animate-fade-in" style="animation-delay: 0.2s">
                    <div class="p-3 rounded-full bg-green-100 text-green-600">
                        <i class="fas fa-procedures text-2xl"></i>
                    </div>
                    <div>
                        <p class="text-sm text-gray-500">refferable cases</p>
        <h3 class="text-2xl font-bold"><%= referrableCaseCount %></h3>
                        <p class="text-xs text-green-500 flex items-center mt-1">
                            <i class="fas fa-arrow-up mr-1"></i> 12% from last month
                        </p>
                        
                    </div>
                </div>                
                <div class="bg-white rounded-lg shadow-md p-6 flex items-center space-x-4 animate-fade-in" style="animation-delay: 0.3s">
                    <div class="p-3 rounded-full bg-purple-100 text-purple-600">
                        <i class="fas fa-user-nurse text-2xl"></i>
                    </div>
                    <div>
                        <p class="text-sm text-gray-500">Non-Referrable Cases</p>
                        <h3 class="text-2xl font-bold"><%= nonReferrableCaseCount %></h3>                        
                        <p class="text-xs text-green-500 flex items-center mt-1">
                            <i class="fas fa-arrow-up mr-1"></i> 3% from last month
                        </p>
                    </div>
                </div>
            </div>
            
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-4">
  <div class="bg-white rounded-lg shadow-md p-4 animate-fade-in" style="animation-delay: 0.5s">
    <div class="flex justify-between items-center mb-3">
      <h2 class="text-lg font-semibold text-gray-700">Monthly Cases Overview</h2>
      <div class="flex space-x-2">
        <button class="px-3 py-1 text-xs bg-blue-50 text-blue-600 rounded-full">Monthly</button>
        <button class="px-3 py-1 text-xs text-gray-500 rounded-full">Yearly</button>
      </div>
    </div>
    
    <div class="flex items-center justify-center mb-3">
      <!-- Patient Count Circle -->
      <div class="flex items-center justify-center w-14 h-14 bg-blue-100 rounded-full">
        <span class="text-xl font-bold text-blue-600"><%=patientCount %></span>
      </div>
    </div>
    
    <!-- Chart Area -->
    <div class="w-full">
      <canvas id="casesChart" height="100"></canvas>
    </div>
  </div>
</div>
            
            <!-- Main Dashboard Cards -->
            <h2 class="text-xl font-bold text-gray-800 mb-6 mt-10 animate-fade-in" style="animation-delay: 0.7s">Administrative Functions</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <!-- Card 1 -->
                <a href="create_patient.jsp" class="dashboard-card card-1 bg-white rounded-lg shadow-md hover:shadow-lg transition p-6 animate-fade-in" style="animation-delay: 0.8s">
                    <div class="flex items-center justify-between mb-4">
                        <div class="card-icon p-3 rounded-full bg-blue-100 text-blue-600">
                            <i class="fas fa-user-md text-xl"></i>
                        </div>
                        <span class="text-xs font-medium bg-blue-100 text-blue-600 px-3 py-1 rounded-full">Staff</span>
                    </div>
                    <h2 class="text-xl font-semibold text-gray-800">Register New patient</h2>
                    <p class="text-gray-600 mt-2">Create patient profile with detailed information.</p>
                    <div class="mt-4 flex items-center text-blue-600">
                        <span class="text-sm">Access Module</span>
                        <i class="fas fa-arrow-right ml-2"></i>
                    </div>
                </a>
                
                <!-- Card 2 -->
                <a href="patients-dir" class="dashboard-card card-2 bg-white rounded-lg shadow-md hover:shadow-lg transition p-6 animate-fade-in" style="animation-delay: 0.9s">
                    <div class="flex items-center justify-between mb-4">
                        <div class="card-icon p-3 rounded-full bg-green-100 text-green-600">
                            <i class="fas fa-clipboard-list text-xl"></i>
                        </div>
                        <span class="text-xs font-medium bg-green-100 text-green-600 px-3 py-1 rounded-full">Directory</span>
                    </div>
                    <h2 class="text-xl font-semibold text-gray-800">make a diagnosis</h2>
                    <p class="text-gray-600 mt-2">Update diagnosis information for a certain patient.</p>
                    <div class="mt-4 flex items-center text-green-600">
                        <span class="text-sm">Access Module</span>
                        <i class="fas fa-arrow-right ml-2"></i>
                    </div>
                </a>
                </div>
                 <!-- Footer -->
        <footer class="bg-white border-t border-gray-200 mt-6">
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
                        <a href="#" class="text-gray-400 hover:text-gray-500">
                            <i class="fab fa-linkedin"></i>
                        </a>
                    </div>
                    <div class="mt-8 md:mt-0 md:order-1">
                        <p class="text-center text-gray-500">&copy; 2025 MBC Patient Management System. All rights reserved.</p>
                    </div>
                </div>
            </div>
        </footer>
    </div>
                       
    <!-- Mobile Sidebar Menu (hidden by default) -->
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
                    <a href="#" class="sidebar-link active flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                        <i class="fas fa-tachometer-alt w-6"></i>
                        <span>Dashboard</span>
                    </a>
                    <a href="users-directory" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                        <i class="fas fa-users w-6"></i>
                        <span>Users Management</span>
                    </a>
                    <a href="monitor_diagnosis.jsp" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                        <i class="fas fa-chart-line w-6"></i>
                        <span>Analytics</span>
                    </a>
                    
                    <a href="settings.jsp" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                        <i class="fas fa-cog w-6"></i>
                        <span>Settings</span>
                    </a>
                    <a href="logout.jsp" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mt-8 bg-red-500/20 hover:bg-red-500/30">
                        <i class="fas fa-sign-out-alt w-6"></i>
                    </nav>
                    </div>
                    </div>
                    
           