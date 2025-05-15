<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.util.*" %>


<%
    //HttpSession session = request.getSession(false);
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
        response.sendRedirect("reffered");
        return;
    } else if (userType.toLowerCase().equals(roles[1])) {
        response.sendRedirect("nurse.jsp");
        return;
    } else if (userType.toLowerCase().equals(roles[2])) {
        response.sendRedirect("patient.jsp");
        return;
    }
%>

<%
    // Get data for statistics
    java.net.URL doctorCountUrl = new java.net.URL("http://localhost:8080/MBC_HOSPITAL/doctor-count");
    java.io.BufferedReader doctorCountReader = new java.io.BufferedReader(new java.io.InputStreamReader(doctorCountUrl.openStream()));
    String doctorCount = doctorCountReader.readLine();
    doctorCountReader.close();
    
    java.net.URL patientCountUrl = new java.net.URL("http://localhost:8080/MBC_HOSPITAL/patient-count");
    java.io.BufferedReader patientCountReader = new java.io.BufferedReader(new java.io.InputStreamReader(patientCountUrl.openStream()));
    String patientCount = patientCountReader.readLine();
    patientCountReader.close();
    
    java.net.URL nurseCountUrl = new java.net.URL("http://localhost:8080/MBC_HOSPITAL/nurse-count");
    java.io.BufferedReader nurseCountReader = new java.io.BufferedReader(new java.io.InputStreamReader(nurseCountUrl.openStream()));
    String nurseCount = nurseCountReader.readLine();
    nurseCountReader.close();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | MBC Hospital</title>
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
               
                <a href="new-doctor.jsp" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                    <i class="fas fa-user-plus w-6"></i>
                    <span>Register Doctor</span>
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
                <h1 class="text-xl font-bold text-gray-800 ml-4">Admin Dashboard</h1>
            </div>
            
            <div class="hidden lg:block">
                <h1 class="text-xl font-bold text-gray-800">Admin Dashboard</h1>
            </div>
            
            <div class="flex items-center space-x-4">
                
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
            <!-- Summary Banner -->
            <div class="bg-gradient-to-r from-blue-600 to-blue-800 rounded-xl shadow-lg p-6 mb-8 animate-fade-in">
                <div class="flex items-center">
                    <div class="mr-6">
                        <h2 class="text-white text-2xl font-bold">Welcome to MBC Hospital Admin Dashboard</h2>
                        <p class="text-blue-100 mt-1">Monitor system statistics, manage users, and oversee hospital operations</p>
                    </div>
                    <div class="ml-auto hidden md:block">
                        <div class="bg-white/20 backdrop-blur-sm p-3 rounded-lg">
                            <div class="text-white text-center">
                                <div class="text-2xl font-bold" id="time">--:--</div>
                                <div class="text-xs mt-1" id="date">---</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Stats -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
                <div class="stats-card animate-fade-in" style="animation-delay: 0.1s">
                    <div class="flex justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Total Doctors</p>
                            <h3 class="text-3xl font-bold text-gray-800 mt-1"><%= (doctorCount != null) ? doctorCount : 0 %></h3>
                        </div>
                        <div class="h-12 w-12 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
                            <i class="fas fa-user-md text-xl"></i>
                        </div>
                    </div>
                    <div class="mt-4">
                        <div class="w-full h-1 bg-gray-200 rounded-full mt-2">
                            <div class="h-1 bg-blue-500 rounded-full" style="width: 75%"></div>
                        </div>
                    </div>
                </div>
                
                <div class="stats-card animate-fade-in" style="animation-delay: 0.2s">
                    <div class="flex justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Total Patients</p>
                            <h3 class="text-3xl font-bold text-gray-800 mt-1"><%= patientCount %></h3>
                        </div>
                        <div class="h-12 w-12 rounded-full bg-green-100 flex items-center justify-center text-green-600">
                            <i class="fas fa-procedures text-xl"></i>
                        </div>
                    </div>
                    <div class="mt-4">
                        <div class="w-full h-1 bg-gray-200 rounded-full mt-2">
                            <div class="h-1 bg-green-500 rounded-full" style="width: 85%"></div>
                        </div>
                    </div>
                </div>
                
                <div class="stats-card animate-fade-in" style="animation-delay: 0.3s">
                    <div class="flex justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Total Nurses</p>
                            <h3 class="text-3xl font-bold text-gray-800 mt-1"><%= nurseCount %></h3>
                        </div>
                        <div class="h-12 w-12 rounded-full bg-purple-100 flex items-center justify-center text-purple-600">
                            <i class="fas fa-user-nurse text-xl"></i>
                        </div>
                    </div>
                    <div class="mt-4">
                        <div class="w-full h-1 bg-gray-200 rounded-full mt-2">
                            <div class="h-1 bg-purple-500 rounded-full" style="width: 60%"></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Charts Row -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
                <div class="stats-card animate-fade-in" style="animation-delay: 0.5s">
                    <div class="flex justify-between items-center mb-4">
                        <h2 class="text-lg font-semibold text-gray-700">Case Resolution Trends</h2>
                        <div class="flex space-x-2">
                            <button id="refreshChartBtn" class="text-blue-500 hover:text-blue-700 text-sm">
                                <i class="fas fa-sync-alt mr-1"></i> Refresh
                            </button>
                        </div>
                    </div>
                    <div class="h-64">
                        <canvas id="casesChart"></canvas>
                    </div>
                </div>
                
                <div class="stats-card animate-fade-in" style="animation-delay: 0.6s">
                    <div class="flex justify-between items-center mb-4">
                        <h2 class="text-lg font-semibold text-gray-700">Case Resolution Comparison</h2>
                        <div class="text-sm text-gray-500">Last 30 days</div>
                    </div>
                    <div class="h-64">
                        <canvas id="resolutionChart"></canvas>
                    </div>
                </div>
            </div>
            
            <!-- Case Statistics Cards -->
            <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-3 gap-6 mb-8">
                <a href="doctor-solved-cases" class="stats-card animate-fade-in cursor-pointer hover:shadow-lg transition" style="animation-delay: 0.65s">
                    <div class="flex justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Cases Solved by Doctors</p>
                            <h3 class="text-3xl font-bold text-gray-800 mt-1" id="doctorSolvedCount">144</h3>
                        </div>
                        <div class="h-12 w-12 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
                            <i class="fas fa-user-md text-xl"></i>
                        </div>
                    </div>
                    <div class="mt-4">
                        <div class="flex items-center justify-between">
                            <span class="text-xs text-gray-500" id="doctorSolvedPercent">48% of total</span>
                            <span class="text-blue-600 text-sm flex items-center">
                                View <i class="fas fa-arrow-right ml-1"></i>
                            </span>
                        </div>
                        <div class="w-full h-1 bg-gray-200 rounded-full mt-2">
                            <div class="h-1 bg-blue-500 rounded-full" id="doctorProgressBar" style="width: 48%"></div>
                        </div>
                    </div>
                </a>
                
                <a href="patients-list" class="stats-card animate-fade-in cursor-pointer hover:shadow-lg transition" style="animation-delay: 0.75s">
                    <div class="flex justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Cases Solved by Nurses</p>
                            <h3 class="text-3xl font-bold text-gray-800 mt-1" id="nurseSolvedCount">96</h3>
                        </div>
                        <div class="h-12 w-12 rounded-full bg-purple-100 flex items-center justify-center text-purple-600">
                            <i class="fas fa-user-nurse text-xl"></i>
                        </div>
                    </div>
                    <div class="mt-4">
                        <div class="flex items-center justify-between">
                            <span class="text-xs text-gray-500" id="nurseSolvedPercent">32% of total</span>
                            <span class="text-purple-600 text-sm flex items-center">
                                View <i class="fas fa-arrow-right ml-1"></i>
                            </span>
                        </div>
                        <div class="w-full h-1 bg-gray-200 rounded-full mt-2">
                            <div class="h-1 bg-purple-500 rounded-full" id="nurseProgressBar" style="width: 32%"></div>
                        </div>
                    </div>
                </a>
                
                <div class="stats-card animate-fade-in" style="animation-delay: 0.85s">
                    <div class="flex justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Pending & Referred Cases</p>
                            <h3 class="text-3xl font-bold text-gray-800 mt-1" id="pendingCasesCount">60</h3>
                        </div>
                        <div class="h-12 w-12 rounded-full bg-amber-100 flex items-center justify-center text-amber-600">
                            <i class="fas fa-clock text-xl"></i>
                        </div>
                    </div>
                    <div class="mt-4">
                        <div class="flex items-center justify-between">
                            <span class="text-xs text-gray-500" id="pendingCasesPercent">20% of total</span>
                        </div>
                        <div class="w-full h-1 bg-gray-200 rounded-full mt-2">
                            <div class="h-1 bg-amber-500 rounded-full" id="pendingProgressBar" style="width: 20%"></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Main Dashboard Cards -->
            <h2 class="text-xl font-bold text-gray-800 mb-6 mt-6 animate-fade-in" style="animation-delay: 0.7s">Administrative Functions</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">                
                <!-- Doctors Card -->
                <a href="verified-doctors" class="dashboard-card card-1 bg-white rounded-lg shadow-md hover:shadow-lg transition p-6 animate-fade-in" style="animation-delay: 0.8s">
                    <div class="flex items-center justify-between mb-4">
                        <div class="card-icon p-3 rounded-full bg-blue-100 text-blue-600">
                            <i class="fas fa-user-md text-xl"></i>
                        </div>
                        <span class="text-xs font-medium bg-blue-100 text-blue-600 px-3 py-1 rounded-full">Medical Staff</span>
                    </div>
                    <h2 class="text-xl font-semibold text-gray-800">Manage Doctors</h2>
                    <p class="text-gray-600 mt-2">View, verify and manage doctor accounts.</p>
                    <div class="mt-4 flex items-center text-blue-600">
                        <span class="text-sm">View Doctors</span>
                        <i class="fas fa-arrow-right ml-2"></i>
                    </div>
                </a>
                
                <!-- Nurses Card -->                
                <a href="view_nurses.jsp" class="dashboard-card card-3 bg-white rounded-lg shadow-md hover:shadow-lg transition p-6 animate-fade-in" style="animation-delay: 0.9s">
                    <div class="flex items-center justify-between mb-4">
                        <div class="card-icon p-3 rounded-full bg-purple-100 text-purple-600">
                            <i class="fas fa-user-nurse text-xl"></i>
                        </div>
                        <span class="text-xs font-medium bg-purple-100 text-purple-600 px-3 py-1 rounded-full">Nursing Staff</span>
                    </div>
                    <h2 class="text-xl font-semibold text-gray-800">Manage Nurses</h2>
                    <p class="text-gray-600 mt-2">View and manage nurse accounts and assignments.</p>
                    <div class="mt-4 flex items-center text-purple-600">
                        <span class="text-sm">View Nurses</span>
                        <i class="fas fa-arrow-right ml-2"></i>
                    </div>
                </a>
                
                <!-- Patients Card -->
                <a href="all-patients.jsp" class="dashboard-card card-2 bg-white rounded-lg shadow-md hover:shadow-lg transition p-6 animate-fade-in" style="animation-delay: 1.0s">
                    <div class="flex items-center justify-between mb-4">
                        <div class="card-icon p-3 rounded-full bg-green-100 text-green-600">
                            <i class="fas fa-procedures text-xl"></i>
                        </div>
                        <span class="text-xs font-medium bg-green-100 text-green-600 px-3 py-1 rounded-full">Patients</span>
                    </div>
                    <h2 class="text-xl font-semibold text-gray-800">Patient Management</h2>
                    <p class="text-gray-600 mt-2">View patient records and medical history.</p>
                    <div class="mt-4 flex items-center text-green-600">
                        <span class="text-sm">View Patients</span>
                        <i class="fas fa-arrow-right ml-2"></i>
                    </div>
                </a>
                
                <!-- Doctor Cases Card -->
                <a href="doctors-dir" class="dashboard-card card-4 bg-white rounded-lg shadow-md hover:shadow-lg transition p-6 animate-fade-in" style="animation-delay: 1.1s">
                    <div class="flex items-center justify-between mb-4">
                        <div class="card-icon p-3 rounded-full bg-amber-100 text-amber-600">
                            <i class="fas fa-stethoscope text-xl"></i>
                        </div>
                        <span class="text-xs font-medium bg-amber-100 text-amber-600 px-3 py-1 rounded-full">Cases</span>
                    </div>
                    <h2 class="text-xl font-semibold text-gray-800">Doctor Cases</h2>
                    <p class="text-gray-600 mt-2">Track cases handled by doctors in the system.</p>
                    <div class="mt-4 flex items-center text-amber-600">
                        <span class="text-sm">View Cases</span>
                        <i class="fas fa-arrow-right ml-2"></i>
                    </div>
                </a>
                
                <!-- Nurse Cases Card -->
                <a href="patients-list" class="dashboard-card card-5 bg-white rounded-lg shadow-md hover:shadow-lg transition p-6 animate-fade-in" style="animation-delay: 1.2s">
                    <div class="flex items-center justify-between mb-4">
                        <div class="card-icon p-3 rounded-full bg-red-100 text-red-600">
                            <i class="fas fa-clipboard-list text-xl"></i>
                        </div>
                        <span class="text-xs font-medium bg-red-100 text-red-600 px-3 py-1 rounded-full">Cases</span>
                    </div>
                    <h2 class="text-xl font-semibold text-gray-800">Nurse Cases</h2>
                    <p class="text-gray-600 mt-2">Track diagnoses and cases managed by nurses.</p>
                    <div class="mt-4 flex items-center text-red-600">
                        <span class="text-sm">View Cases</span>
                        <i class="fas fa-arrow-right ml-2"></i>
                    </div>
                </a>
                
                <!-- User Management Card -->
                <a href="users-directory" class="dashboard-card card-7 bg-white rounded-lg shadow-md hover:shadow-lg transition p-6 animate-fade-in" style="animation-delay: 1.3s">
                    <div class="flex items-center justify-between mb-4">
                        <div class="card-icon p-3 rounded-full bg-indigo-100 text-indigo-600">
                            <i class="fas fa-users-cog text-xl"></i>
                        </div>
                        <span class="text-xs font-medium bg-indigo-100 text-indigo-600 px-3 py-1 rounded-full">Admin</span>
                    </div>
                    <h2 class="text-xl font-semibold text-gray-800">User Management</h2>
                    <p class="text-gray-600 mt-2">Manage all system users, permissions and roles.</p>
                    <div class="mt-4 flex items-center text-indigo-600">
                        <span class="text-sm">Manage Users</span>
                        <i class="fas fa-arrow-right ml-2"></i>
                    </div>
                </a>
            </div>
            
            <!-- Footer -->
            <footer class="mt-12 text-center text-gray-500 text-sm">
                <p>&copy; 2025 MBC Hospital System. All rights reserved.</p>
            </footer>
        </main>
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
                        <span>Users</span>
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
        // Initialize date and time
        function updateDateTime() {
            const now = new Date();
            const timeElement = document.getElementById('time');
            const dateElement = document.getElementById('date');
            
            if (timeElement && dateElement) {
                timeElement.textContent = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
                dateElement.textContent = now.toLocaleDateString([], { weekday: 'short', month: 'short', day: 'numeric' });
            }
        }
        
        // Update time every second
        setInterval(updateDateTime, 1000);
        updateDateTime();
        
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
            
            // Load chart data from the server
            fetchDiagnosisStats();
        });
        
        // Function to fetch diagnosis statistics and update charts
        function fetchDiagnosisStats() {
            fetch('diagnosis-stats')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    // Initialize charts with the fetched data
                    initializeCaseResolutionTrendChart(data);
                    initializeCaseResolutionComparisonChart(data);
                    updateStatisticsCards(data);
                })
                .catch(error => {
                    console.error('Error fetching diagnosis stats:', error);
                    // Initialize with default data if there's an error
                    initializeChartsWithDefaultData();
                });
        }
        
        // Function to initialize the Case Resolution Trend Chart
        function initializeCaseResolutionTrendChart(data) {
            const casesCtx = document.getElementById('casesChart').getContext('2d');
            const casesChart = new Chart(casesCtx, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                    datasets: [
                        {
                            label: 'Doctor Resolved Cases',
                            data: data.doctorMonthlyStats,
                            borderColor: '#3b82f6',
                            backgroundColor: 'rgba(59, 130, 246, 0.1)',
                            tension: 0.4,
                            fill: true
                        },
                        {
                            label: 'Nurse Resolved Cases',
                            data: data.nurseMonthlyStats,
                            borderColor: '#8b5cf6',
                            backgroundColor: 'rgba(139, 92, 246, 0.1)',
                            tension: 0.4,
                            fill: true
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'top',
                            labels: {
                                boxWidth: 12,
                                padding: 15
                            }
                        },
                        tooltip: {
                            mode: 'index',
                            intersect: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: {
                                drawBorder: false,
                                color: 'rgba(200, 200, 200, 0.2)'
                            },
                            ticks: {
                                precision: 0
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            }
                        }
                    },
                    interaction: {
                        mode: 'nearest',
                        axis: 'x',
                        intersect: false
                    }
                }
            });
            
            // Add refresh functionality
            if (document.getElementById('refreshChartBtn')) {
                document.getElementById('refreshChartBtn').addEventListener('click', function() {
                    this.disabled = true;
                    this.innerHTML = '<i class="fas fa-spinner fa-spin mr-1"></i> Refreshing...';
                    
                    // Refresh data from server
                    fetch('diagnosis-stats')
                        .then(response => response.json())
                        .then(newData => {
                            // Update chart data
                            casesChart.data.datasets[0].data = newData.doctorMonthlyStats;
                            casesChart.data.datasets[1].data = newData.nurseMonthlyStats;
                            casesChart.update();
                            
                            // Re-enable button
                            this.disabled = false;
                            this.innerHTML = '<i class="fas fa-sync-alt mr-1"></i> Refresh';
                        })
                        .catch(error => {
                            console.error('Error refreshing data:', error);
                            this.disabled = false;
                            this.innerHTML = '<i class="fas fa-sync-alt mr-1"></i> Refresh';
                        });
                });
            }
        }
        
        // Function to initialize the Case Resolution Comparison Chart
        function initializeCaseResolutionComparisonChart(data) {
            const resolutionCtx = document.getElementById('resolutionChart').getContext('2d');
            const resolutionChart = new Chart(resolutionCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Resolved by Doctors', 'Resolved by Nurses', 'Pending Cases', 'Referred Cases'],
                    datasets: [{
                        data: [
                            data.statusStats.resolvedByDoctors || 0,
                            data.statusStats.resolvedByNurses || 0,
                            data.statusStats.pendingCases || 0,
                            data.statusStats.referredCases || 0
                        ],
                        backgroundColor: [
                            'rgba(59, 130, 246, 0.8)',
                            'rgba(139, 92, 246, 0.8)',
                            'rgba(245, 158, 11, 0.8)',
                            'rgba(239, 68, 68, 0.8)'
                        ],
                        borderWidth: 2,
                        borderColor: '#ffffff'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                boxWidth: 12,
                                padding: 15,
                                usePointStyle: true,
                                pointStyle: 'circle'
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    const label = context.label || '';
                                    const value = context.raw || 0;
                                    const total = context.dataset.data.reduce((acc, val) => acc + val, 0);
                                    const percentage = Math.round((value / total) * 100);
                                    return `${label}: ${value} (${percentage}%)`;
                                }
                            }
                        }
                    },
                    cutout: '70%'
                }
            });
        }
        
        // Function to update the statistics cards with actual data
        function updateStatisticsCards(data) {
            // Update cases solved by doctors
            const doctorSolvedElement = document.getElementById('doctorSolvedCount');
            if (doctorSolvedElement) {
                doctorSolvedElement.textContent = data.statusStats.resolvedByDoctors || 0;
            }
            
            // Update cases solved by nurses
            const nurseSolvedElement = document.getElementById('nurseSolvedCount');
            if (nurseSolvedElement) {
                nurseSolvedElement.textContent = data.statusStats.resolvedByNurses || 0;
            }
            
            // Update pending & referred cases
            const pendingCasesElement = document.getElementById('pendingCasesCount');
            if (pendingCasesElement) {
                const pendingCount = (data.statusStats.pendingCases || 0) + (data.statusStats.referredCases || 0);
                pendingCasesElement.textContent = pendingCount;
            }
            
            // Update percentages
            const total = (data.statusStats.resolvedByDoctors || 0) + 
                          (data.statusStats.resolvedByNurses || 0) + 
                          (data.statusStats.pendingCases || 0) + 
                          (data.statusStats.referredCases || 0);
            
            const doctorPercentElement = document.getElementById('doctorSolvedPercent');
            if (doctorPercentElement && total > 0) {
                const percent = Math.round((data.statusStats.resolvedByDoctors || 0) / total * 100);
                doctorPercentElement.textContent = `${percent}% of total`;
                
                // Update progress bar
                const doctorProgressBar = document.getElementById('doctorProgressBar');
                if (doctorProgressBar) {
                    doctorProgressBar.style.width = `${percent}%`;
                }
            }
            
            const nursePercentElement = document.getElementById('nurseSolvedPercent');
            if (nursePercentElement && total > 0) {
                const percent = Math.round((data.statusStats.resolvedByNurses || 0) / total * 100);
                nursePercentElement.textContent = `${percent}% of total`;
                
                // Update progress bar
                const nurseProgressBar = document.getElementById('nurseProgressBar');
                if (nurseProgressBar) {
                    nurseProgressBar.style.width = `${percent}%`;
                }
            }
            
            const pendingPercentElement = document.getElementById('pendingCasesPercent');
            if (pendingPercentElement && total > 0) {
                const pendingCount = (data.statusStats.pendingCases || 0) + (data.statusStats.referredCases || 0);
                const percent = Math.round(pendingCount / total * 100);
                pendingPercentElement.textContent = `${percent}% of total`;
                
                // Update progress bar
                const pendingProgressBar = document.getElementById('pendingProgressBar');
                if (pendingProgressBar) {
                    pendingProgressBar.style.width = `${percent}%`;
                }
            }
        }
        
        // Fallback function to initialize charts with default data if API fails
        function initializeChartsWithDefaultData() {
            const defaultData = {
                doctorMonthlyStats: [38, 42, 35, 27, 32, 45, 55, 62, 58, 45, 48, 52],
                nurseMonthlyStats: [25, 28, 32, 24, 26, 32, 38, 42, 38, 30, 34, 36],
                statusStats: {
                    resolvedByDoctors: 142,
                    resolvedByNurses: 96,
                    pendingCases: 45,
                    referredCases: 15
                }
            };
            
            initializeCaseResolutionTrendChart(defaultData);
            initializeCaseResolutionComparisonChart(defaultData);
            updateStatisticsCards(defaultData);
        }
    </script>
</body>
</html>