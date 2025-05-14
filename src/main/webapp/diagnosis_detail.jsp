<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    String username = (String) session.getAttribute("username");
    String userType = (String) session.getAttribute("usertype");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diagnosis Details - MBC Hospital</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
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
                        },
                        amber: {
                            50: '#fffbeb',
                            100: '#fef3c7',
                            200: '#fde68a',
                            300: '#fcd34d',
                            400: '#fbbf24',
                            500: '#f59e0b',
                            600: '#d97706',
                            700: '#b45309',
                            800: '#92400e',
                            900: '#78350f',
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
<body class="bg-gray-50">
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
            <a href="dashboard" class="sidebar-link">
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
    
    <div class="main-content">
        <!-- Page Header -->
        <div class="mb-8">
            <div class="flex flex-col md:flex-row md:justify-between md:items-center mb-2">
                <h1 class="text-2xl font-bold text-gray-800 mb-2 md:mb-0">Diagnosis Details</h1>
                <c:choose>
                    <c:when test="${diagnosis.status eq 'Referrable'}">
                        <a href="referred-diagnoses" class="text-blue-600 hover:text-blue-800 flex items-center no-print">
                            <i class="fas fa-arrow-left mr-2"></i> Back to Awaiting Diagnosis
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="confirmed-cases" class="text-blue-600 hover:text-blue-800 flex items-center no-print">
                            <i class="fas fa-arrow-left mr-2"></i> Back to Confirmed Cases
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
            <p class="text-gray-600 text-sm">
                <a href="/reffered" class="text-blue-600 hover:underline">Dashboard</a> / 
                <c:choose>
                    <c:when test="${diagnosis.status eq 'Referrable'}">
                        <a href="referred-diagnoses" class="text-blue-600 hover:underline">Awaiting Diagnosis</a>
                    </c:when>
                    <c:otherwise>
                        <a href="confirmed-cases" class="text-blue-600 hover:underline">Confirmed Cases</a>
                    </c:otherwise>
                </c:choose>
                / Details
            </p>
        </div>
        
        <c:if test="${not empty error}">
            <div class="bg-red-50 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-md">
                <div class="flex">
                    <div class="flex-shrink-0">
                        <i class="fas fa-exclamation-circle"></i>
                    </div>
                    <div class="ml-3">
                        <p class="text-sm font-medium">${error}</p>
                    </div>
                </div>
            </div>
        </c:if>
        
        <c:if test="${not empty message}">
            <div class="bg-green-50 border-l-4 border-green-500 text-green-700 p-4 mb-6 rounded-md">
                <div class="flex">
                    <div class="flex-shrink-0">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="ml-3">
                        <p class="text-sm font-medium">${message}</p>
                    </div>
                </div>
            </div>
        </c:if>
        
        <div class="bg-white rounded-xl shadow-sm overflow-hidden mb-8 animate-fade-in">
            <div class="bg-gradient-to-r from-blue-50 to-white px-6 py-4 border-b border-gray-200 flex justify-between items-center">
                <h2 class="text-lg font-semibold text-gray-800 flex items-center">
                    <i class="fas fa-file-medical text-blue-600 mr-2"></i>
                    Diagnosis #${diagnosis.diagnosisId}
                </h2>
                <c:choose>
                    <c:when test="${diagnosis.status eq 'Referrable'}">
                        <span class="px-3 py-1 bg-amber-50 text-amber-800 rounded-full text-sm font-medium flex items-center border border-amber-200">
                            <i class="fas fa-clipboard-check mr-1.5"></i> Awaiting Diagnosis
                        </span>
                    </c:when>
                    <c:when test="${diagnosis.result eq 'Positive'}">
                        <span class="px-3 py-1 bg-red-100 text-red-800 rounded-full text-sm font-medium">
                            <i class="fas fa-exclamation-circle mr-1"></i> Positive
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="px-3 py-1 bg-green-100 text-green-800 rounded-full text-sm font-medium">
                            <i class="fas fa-check-circle mr-1"></i> Negative
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="p-6">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <div>
                        <div class="mb-4">
                            <h3 class="text-sm font-medium text-gray-500 mb-1">Patient Name</h3>
                            <p class="text-base font-medium text-gray-900 flex items-center">
                                <i class="fas fa-user-circle text-blue-500 mr-2"></i>
                                ${patientName}
                            </p>
                        </div>
                        
                        <div class="mb-4">
                            <h3 class="text-sm font-medium text-gray-500 mb-1">Date</h3>
                            <p class="text-base text-gray-900 flex items-center">
                                <i class="far fa-calendar-alt text-blue-500 mr-2"></i>
                                <fmt:formatDate value="${diagnosis.diagnosisDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </p>
                        </div>
                    </div>
                    
                    <div>
                        <div class="mb-4">
                            <h3 class="text-sm font-medium text-gray-500 mb-1">Follow Up Date</h3>
                            <p class="text-base text-gray-900 flex items-center">
                                <i class="far fa-calendar-check text-blue-500 mr-2"></i>
                                <c:choose>
                                    <c:when test="${diagnosis.followUpDate != null}">
                                        <fmt:formatDate value="${diagnosis.followUpDate}" pattern="yyyy-MM-dd"/>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-gray-500">No follow-up scheduled</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        
                        <div class="mb-4">
                            <h3 class="text-sm font-medium text-gray-500 mb-1">Current Status</h3>
                            <p class="text-base text-gray-900">
                                <c:choose>
                                    <c:when test="${diagnosis.status eq 'Referrable'}">
                                        <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium bg-amber-100 text-amber-800 border border-amber-200">
                                            <i class="fas fa-clipboard-check mr-1"></i> Awaiting Diagnosis
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                            <i class="fas fa-check-circle mr-1"></i> ${diagnosis.status}
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </div>
                
                <div class="mb-6">
                    <h3 class="text-sm font-medium text-gray-500 mb-2">Nurse Assessment</h3>
                    <div class="bg-gray-50 p-4 rounded-lg border border-gray-200">
                        <p class="text-gray-700">
                            ${diagnosis.nurseAssessment != null && !empty diagnosis.nurseAssessment ? diagnosis.nurseAssessment : 'No assessment provided.'}
                        </p>
                    </div>
                </div>
                
                <div class="mb-6">
                    <h3 class="text-sm font-medium text-gray-500 mb-2">Prescribed Medications</h3>
                    <div class="bg-blue-50 p-4 rounded-lg border border-blue-100">
                        <c:choose>
                            <c:when test="${empty diagnosis.medicationsPrescribed}">
                                <p class="text-gray-700">No medications prescribed.</p>
                            </c:when>
                            <c:otherwise>
                                <ul class="list-disc pl-6 text-gray-700">
                                    <c:forTokens items="${diagnosis.medicationsPrescribed}" delims="," var="medication">
                                        <li class="mb-1">${medication.trim()}</li>
                                    </c:forTokens>
                                </ul>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <div class="flex justify-end space-x-3 pt-4 border-t border-gray-100 no-print">
                    <button onclick="window.print()" class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition flex items-center shadow-sm">
                        <i class="fas fa-print mr-2"></i> Print Report
                    </button>
                    <c:if test="${diagnosis.status eq 'Referrable'}">
                        <a href="update-diagnosis?id=${diagnosis.diagnosisId}" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition flex items-center shadow-sm">
                            <i class="fas fa-stethoscope mr-2"></i> Provide Diagnosis
                        </a>
                    </c:if>
                    <c:if test="${diagnosis.status ne 'Referrable'}">
                        <a href="update-diagnosis?id=${diagnosis.diagnosisId}" class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition flex items-center shadow-sm">
                            <i class="fas fa-edit mr-2"></i> Update Diagnosis
                        </a>
                    </c:if>
                </div>
            </div>
        </div>
        
        <!-- Footer -->
        <footer class="mt-8 pt-6 border-t border-gray-200 text-center text-gray-500 text-sm no-print">
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