<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.URL"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.util.Enumeration" %>

<% 
// Debug information
if (session != null) {
    out.println("<!-- Session attributes: -->");
    Enumeration<String> attributeNames = session.getAttributeNames();
    while (attributeNames.hasMoreElements()) {
        String name = attributeNames.nextElement();
        Object value = session.getAttribute(name);
        out.println("<!-- " + name + " = " + value + " -->");
    }
    
    // Specifically check for usertype
    String usertype = (String) session.getAttribute("usertype");
    out.println("<!-- usertype = " + usertype + " -->");
    
    // Validate nurse session
    if (usertype == null || !"nurse".equalsIgnoreCase(usertype)) {
        response.sendRedirect("login.jsp");
        return;
    }
} else {
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nurse Dashboard | MBC Hospital</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
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
            <a href="nurse.jsp" class="sidebar-link active">
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
            <a href="nurse-completed-cases" class="sidebar-link">
                <i class="fas fa-check-circle w-5 h-5 mr-3"></i>
                <span>Nurse-Completed Cases</span>
            </a>
            <a href="nurse-view-diagnoses" class="sidebar-link">
                <i class="fas fa-clipboard-check w-5 h-5 mr-3"></i>
                <span>View Diagnosed Cases</span>
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
        <!-- Header -->
        <div class="flex justify-between items-center mb-6">
            <div>
                <h1 class="text-2xl font-bold text-gray-800">Nurse Dashboard</h1>
                <p class="text-gray-600">Welcome back, <%= session.getAttribute("username") %>. Here's an overview of your activities.</p>
            </div>
            <div class="flex items-center space-x-4">
                <button id="refreshDataBtn" class="btn btn-outline">
                    <i class="fas fa-sync-alt mr-2"></i>
                    Refresh Data
                </button>
            </div>
        </div>
        
        <!-- Stats Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-6">
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
                    e.printStackTrace();
                }
            %>
            
            <%
                java.net.URL url4 = new java.net.URL("http://localhost:8080/MBC_HOSPITAL/action-required-case-count");
                java.io.BufferedReader in4 = new java.io.BufferedReader(new java.io.InputStreamReader(url4.openStream()));
                String actionRequiredCaseCount = in4.readLine();
                in4.close();
            %>
            
            <!-- Total Cases -->
            <div class="stats-card animate-fade-in" style="animation-delay: 0.1s">
                <div class="flex justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-500">Total Patients</p>
                        <h3 class="text-3xl font-bold text-gray-800 mt-1"><%=patientCount %></h3>
                    </div>
                    <div class="h-12 w-12 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
                        <i class="fas fa-users text-xl"></i>
                    </div>
                </div>
                <div class="mt-4">
                    <div class="flex items-center">
                        <span class="text-gray-500 text-sm">Total registered patients</span>
                    </div>
                    <div class="w-full h-1 bg-gray-200 rounded-full mt-2">
                        <div class="h-1 bg-blue-500 rounded-full" style="width: 100%"></div>
                    </div>
                </div>
            </div>
            
            <!-- Referrable Cases -->
            <div class="stats-card animate-fade-in" style="animation-delay: 0.2s">
                <div class="flex justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-500">Referrable Cases</p>
                        <h3 class="text-3xl font-bold text-gray-800 mt-1"><%= referrableCaseCount %></h3>
                    </div>
                    <div class="h-12 w-12 rounded-full bg-amber-100 flex items-center justify-center text-amber-600">
                        <i class="fas fa-share text-xl"></i>
                    </div>
                </div>
                <div class="mt-4">
                    <div class="flex items-center">
                        <span class="text-gray-500 text-sm">Cases referred to doctors</span>
                    </div>
                    <div class="w-full h-1 bg-gray-200 rounded-full mt-2">
                        <div class="h-1 bg-amber-500 rounded-full" style="width: 100%"></div>
                    </div>
                </div>
            </div>
            
            <!-- Action Required Cases -->
            <div class="stats-card animate-fade-in" style="animation-delay: 0.3s">
                <div class="flex justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-500">Action Required Cases</p>
                        <h3 class="text-3xl font-bold text-gray-800 mt-1"><%= actionRequiredCaseCount %></h3>
                    </div>
                    <div class="h-12 w-12 rounded-full bg-red-100 flex items-center justify-center text-red-600">
                        <i class="fas fa-exclamation-circle text-xl"></i>
                    </div>
                </div>
                <div class="mt-4">
                    <div class="flex items-center">
                        <a href="nurse-action-cases" class="text-blue-600 hover:text-blue-800 text-sm font-medium">
                            View cases requiring action <i class="fas fa-arrow-right ml-1"></i>
                        </a>
                    </div>
                    <div class="w-full h-1 bg-gray-200 rounded-full mt-2">
                        <div class="h-1 bg-red-500 rounded-full" style="width: 100%"></div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Chart & Recent Activity -->
        <div class="mb-6">
            <div class="stats-card animate-fade-in" style="animation-delay: 0.4s">
                <h2 class="text-lg font-semibold text-gray-700 mb-4">Monthly Cases Overview</h2>
                <div class="h-64">
                    <canvas id="casesChart"></canvas>
                </div>
            </div>
        </div>
        
        <!-- Quick Access Cards -->
        <h2 class="text-lg font-semibold text-gray-800 mb-4 mt-4">Quick Access</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <a href="create_patient.jsp" class="stats-card flex items-center animate-fade-in" style="animation-delay: 0.6s">
                <div class="h-12 w-12 rounded-full bg-blue-100 flex items-center justify-center text-blue-600 mr-4">
                    <i class="fas fa-user-plus text-xl"></i>
                </div>
                <div>
                    <h3 class="font-semibold text-gray-800">Register Patient</h3>
                    <p class="text-gray-500 text-sm">Add new patients to the system</p>
                </div>
            </a>
            
            <a href="nurse-action-cases" class="stats-card flex items-center animate-fade-in" style="animation-delay: 0.7s">
                <div class="h-12 w-12 rounded-full bg-green-100 flex items-center justify-center text-green-600 mr-4">
                    <i class="fas fa-clipboard-list text-xl"></i>
                </div>
                <div>
                    <h3 class="font-semibold text-gray-800">Cases Requiring Action</h3>
                    <p class="text-gray-500 text-sm">Review and diagnose new cases</p>
                </div>
            </a>
            
            <a href="nurse-referred-cases" class="stats-card flex items-center animate-fade-in" style="animation-delay: 0.8s">
                <div class="h-12 w-12 rounded-full bg-amber-100 flex items-center justify-center text-amber-600 mr-4">
                    <i class="fas fa-share text-xl"></i>
                </div>
                <div>
                    <h3 class="font-semibold text-gray-800">Referred Cases</h3>
                    <p class="text-gray-500 text-sm">Track referred patient cases</p>
                </div>
            </a>
            
            <a href="nurse-completed-cases" class="stats-card flex items-center animate-fade-in" style="animation-delay: 0.9s">
                <div class="h-12 w-12 rounded-full bg-purple-100 flex items-center justify-center text-purple-600 mr-4">
                    <i class="fas fa-check-circle text-xl"></i>
                </div>
                <div>
                    <h3 class="font-semibold text-gray-800">Completed Cases</h3>
                    <p class="text-gray-500 text-sm">View nurse-completed diagnoses</p>
                </div>
            </a>
        </div>
        
        <!-- Footer -->
        <footer class="mt-12 text-center text-gray-500 text-sm">
            <p>&copy; 2025 MBC Hospital System. All rights reserved.</p>
        </footer>
    </main>
    
    <!-- Mobile Menu Overlay (hidden by default) -->
    <div id="mobile-menu-overlay" class="fixed inset-0 bg-black bg-opacity-50 z-40 hidden lg:hidden"></div>
    
    <script>
        // Chart initialization
        document.addEventListener('DOMContentLoaded', function() {
            let casesChart = null;
            
            // Function to load chart data
            function loadChartData() {
                const chartContainer = document.getElementById('casesChart').parentNode;
                chartContainer.innerHTML = `
                    <div class="flex items-center justify-center h-64">
                        <div class="animate-pulse-slow text-blue-500">
                            <i class="fas fa-spinner fa-spin text-2xl"></i>
                            <p class="text-sm text-gray-500 mt-2">Loading chart data...</p>
                        </div>
                    </div>
                `;
                
                // Recreate the canvas
                chartContainer.innerHTML = '<canvas id="casesChart" height="250"></canvas>';
                
                // Fetch chart data
                fetch('/MBC_HOSPITAL/monthly-cases-data')
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network response was not ok');
                        }
                        return response.json();
                    })
                    .then(data => {
                        // Validate data structure
                        if (!data || !data.labels || !data.totalCases || !data.referredCases) {
                            throw new Error('Invalid data format received from server');
                        }
                        
                        const ctx = document.getElementById('casesChart').getContext('2d');
                        casesChart = new Chart(ctx, {
                            type: 'line',
                            data: {
                                labels: data.labels,
                                datasets: [
                                    {
                                        label: 'Total Cases',
                                        data: data.totalCases,
                                        borderColor: '#3b82f6',
                                        backgroundColor: 'rgba(59, 130, 246, 0.1)',
                                        tension: 0.4,
                                        fill: true
                                    },
                                    {
                                        label: 'Referred Cases',
                                        data: data.referredCases,
                                        borderColor: '#f59e0b',
                                        backgroundColor: 'rgba(245, 158, 11, 0.1)',
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
                                    }
                                },
                                scales: {
                                    y: {
                                        beginAtZero: true,
                                        grid: {
                                            drawBorder: false
                                        }
                                    },
                                    x: {
                                        grid: {
                                            display: false
                                        }
                                    }
                                }
                            }
                        });
                    })
                    .catch(error => {
                        console.error('Error fetching chart data:', error);
                        document.getElementById('casesChart').parentNode.innerHTML = 
                            '<div class="flex items-center justify-center h-full">' +
                            '<p class="text-gray-500">Failed to load chart data: ' + error.message + '</p>' +
                            '</div>';
                    });
            }
            
            // Function to refresh card data
            function refreshCardData() {
                // Refresh patient count
                fetch('/MBC_HOSPITAL/patient-count')
                    .then(response => response.text())
                    .then(count => {
                        document.querySelector('.stats-card:nth-child(1) h3').textContent = count;
                    })
                    .catch(error => {
                        console.error('Error fetching patient count:', error);
                    });
                
                // Refresh referrable case count
                fetch('/MBC_HOSPITAL/referrable-case-count')
                    .then(response => response.text())
                    .then(count => {
                        document.querySelector('.stats-card:nth-child(2) h3').textContent = count;
                    })
                    .catch(error => {
                        console.error('Error fetching referrable case count:', error);
                    });
                
                // Refresh action required case count
                fetch('/MBC_HOSPITAL/action-required-case-count')
                    .then(response => response.text())
                    .then(count => {
                        document.querySelector('.stats-card:nth-child(3) h3').textContent = count;
                    })
                    .catch(error => {
                        console.error('Error fetching action required case count:', error);
                    });
            }
            
            // Initial data loading
            loadChartData();
            
            // Refresh data functionality
            document.getElementById('refreshDataBtn').addEventListener('click', function() {
                this.disabled = true;
                this.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i> Refreshing...';
                
                // Refresh all data
                refreshCardData();
                loadChartData();
                
                // Re-enable button after a delay
                setTimeout(() => {
                    this.disabled = false;
                    this.innerHTML = '<i class="fas fa-sync-alt mr-2"></i> Refresh Data';
                }, 1000);
            });
            
            // Mobile menu toggle
            const menuToggle = document.getElementById('menu-toggle');
            const sidebar = document.querySelector('.sidebar');
            const overlay = document.getElementById('mobile-menu-overlay');
            
            if (menuToggle) {
                menuToggle.addEventListener('click', function() {
                    sidebar.classList.toggle('active');
                    overlay.classList.toggle('hidden');
                });
            }
            
            if (overlay) {
                overlay.addEventListener('click', function() {
                    sidebar.classList.remove('active');
                    overlay.classList.add('hidden');
                });
            }
        });
    </script>
</body>
</html>
           