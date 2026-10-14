<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.mbc_hospital.model.Patient" %>
<%
    //HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("username") == null || !session.getAttribute("usertype").equals("Doctor")) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = (String) session.getAttribute("username");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Patients - MBC Hospital</title>
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
            <a href="reffered" class="flex items-center">
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
            <a href="confirmed-cases" class="sidebar-link">
                <i class="fas fa-check-circle w-6"></i>
                <span>Confirmed Cases</span>
            </a>
            <a href="all-patients" class="sidebar-link active">
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
                <h1 class="text-2xl font-bold text-gray-800">All Patients</h1>
            </div>
            <div class="flex items-center">
                <div class="h-8 w-8 bg-blue-100 rounded-full flex items-center justify-center text-blue-600">
                    <i class="fas fa-user-md"></i>
                </div>
            </div>
        </header>

        <!-- Patients List Card -->
        <div class="bg-white rounded-xl shadow-sm p-6 mb-8 animate-fade-in">
            <div class="flex justify-between items-center mb-6">
                <div>
                    <h2 class="text-xl font-semibold text-gray-800 flex items-center">
                        <i class="fas fa-users text-blue-600 mr-2"></i>
                        Patient Records
                    </h2>
                    <p class="text-sm text-gray-500 mt-1">Complete list of all registered patients in the system</p>
                </div>
                <div>
                    <span class="bg-yellow-100 text-yellow-800 text-sm px-3 py-1.5 rounded-full font-medium flex items-center">
                        <i class="fas fa-exclamation-circle mr-1.5"></i> Read-Only Directory
                    </span>
                </div>
            </div>
            
            <!-- Read-only Notice Banner -->
            <div class="bg-blue-50 border-l-4 border-blue-500 text-blue-700 p-4 mb-6 rounded-md">
                <div class="flex">
                    <div class="flex-shrink-0">
                        <i class="fas fa-info-circle text-blue-500 mt-0.5"></i>
                    </div>
                    <div class="ml-3">
                        <p class="text-sm font-medium">This is a read-only view of all patients. No modifications can be made from this screen.</p>
                    </div>
                </div>
            </div>
            
            <%
                List<Patient> patients = (List<Patient>) request.getAttribute("patients");
                if (patients == null || patients.isEmpty()) {
            %>
                <div class="py-12 text-center">
                    <div class="flex flex-col items-center justify-center">
                        <div class="h-24 w-24 rounded-full bg-blue-100 flex items-center justify-center mb-4">
                            <i class="fas fa-user-slash text-blue-400 text-4xl"></i>
                        </div>
                        <h3 class="text-xl font-medium text-gray-700 mb-2">No patients found</h3>
                        <p class="text-gray-500 max-w-md mx-auto">
                            There are no patients registered in the system yet.
                        </p>
                    </div>
                </div>
            <% } else { %>
                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Patient Name</th>
                                <th>Contact</th>
                                <th>Email</th>
                                <th>Address</th>
                                <th>Image</th>
                                <th>Registered By</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Patient patient : patients) { %>
                                <tr class="hover:bg-gray-50 transition duration-150">
                                    <td>
                                        <div class="flex items-center">
                                            <div class="h-8 w-8 bg-primary-100 rounded-full flex items-center justify-center text-primary-600 mr-3">
                                                <i class="fas fa-user-circle"></i>
                                            </div>
                                            <span class="font-medium">#<%= patient.getPatientID() %></span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="font-medium"><%= patient.getFirstName() %> <%= patient.getLastName() %></div>
                                    </td>
                                    <td>
                                        <div class="flex items-center">
                                            <i class="fas fa-phone text-gray-400 mr-2"></i>
                                            <%= patient.getTelephone() %>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="flex items-center">
                                            <i class="fas fa-envelope text-gray-400 mr-2"></i>
                                            <%= patient.getEmail() %>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="flex items-center">
                                            <i class="fas fa-map-marker-alt text-gray-400 mr-2"></i>
                                            <%= patient.getAddress() %>
                                        </div>
                                    </td>
                                    <td>
                                        <% if (patient.getImageLink() != null && !patient.getImageLink().isEmpty()) { %>
                                            <img src="<%= patient.getImageLink() %>" alt="Patient Image" class="h-10 w-10 rounded-full object-cover border border-gray-200">
                                        <% } else { %>
                                            <div class="h-10 w-10 rounded-full bg-gray-200 flex items-center justify-center text-gray-500">
                                                <i class="fas fa-user"></i>
                                            </div>
                                        <% } %>
                                    </td>
                                    <td>
                                        <div class="flex items-center">
                                            <div class="h-7 w-7 bg-green-100 rounded-full flex items-center justify-center text-green-600 mr-2">
                                                <i class="fas fa-user-nurse"></i>
                                            </div>
                                            <span><%= patient.getRegisteredBy() %></span>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <div class="mt-6 flex justify-between items-center">
                    <div class="text-sm text-gray-500">
                        Showing <%= patients.size() %> patients
                    </div>
                    <div class="flex items-center space-x-2">
                        <button class="px-4 py-2 bg-gray-100 rounded-lg hover:bg-gray-200 transition">
                            <i class="fas fa-chevron-left"></i>
                        </button>
                        <span class="text-gray-600">Page 1 of 1</span>
                        <button class="px-4 py-2 bg-gray-100 rounded-lg hover:bg-gray-200 transition">
                            <i class="fas fa-chevron-right"></i>
                        </button>
                    </div>
                </div>
            <% } %>
        </div>
        
        <!-- Footer -->
        <footer class="mt-8 pt-6 border-t border-gray-200 text-center text-gray-500 text-sm">
            <div class="flex items-center justify-center mb-2">
                <i class="fas fa-hospital-alt text-blue-500 mr-2"></i>
                <span class="font-semibold text-gray-600">MBC Hospital</span>
            </div>
            <p>&copy; <%= new java.util.Date().getYear() + 1900 %> MBC Hospital Healthcare Management System. All rights reserved.</p>
        </footer>
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
