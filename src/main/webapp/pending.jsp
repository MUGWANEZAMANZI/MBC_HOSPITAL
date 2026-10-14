<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
// Check if coming from login attempt (we can detect this by checking for a username in the session)
boolean isLoginAttempt = session.getAttribute("pending_username") != null;
String username = isLoginAttempt ? (String)session.getAttribute("pending_username") : "";
String userType = request.getParameter("userType") != null ? request.getParameter("userType") : (session.getAttribute("pending_usertype") != null ? (String)session.getAttribute("pending_usertype") : "");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Pending Approval - MBC Hospital</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">
    <div class="max-w-2xl w-full bg-white shadow-lg rounded-lg overflow-hidden">
        <div class="bg-gradient-to-r from-blue-600 to-blue-700 px-6 py-8 text-white text-center">
            <div class="mb-4 bg-white/20 h-20 w-20 rounded-full mx-auto flex items-center justify-center">
                <i class="fas fa-user-clock text-4xl"></i>
            </div>
            <p class="text-blue-100 mt-2 text-xl">
                <% if (!username.isEmpty()) { %>
                    Hello, <%= username %>! Your account is awaiting verification
                <% } else { %>
                    Your account is awaiting verification
                <% } %>
            </p>
        </div>
        
        <div class="p-6">
            <div class="bg-blue-50 border-l-4 border-blue-500 p-4 mb-6">
                <div class="flex">
                    <div class="flex-shrink-0">
                        <i class="fas fa-info-circle text-blue-600"></i>
                    </div>
                    <div class="ml-3">
                        <p class="text-sm text-blue-700">
                            <% if (isLoginAttempt) { %>
                                Your account has been registered but requires approval before you can login. Please check back later.
                            <% } else { %>
                                Thank you for registering with MBC Hospital. Your account has been created successfully but requires approval before you can log in.
                            <% } %>
                        </p>
                    </div>
                </div>
            </div>
            
            <div class="space-y-4">
                <div class="bg-gray-50 rounded-lg p-4 border border-gray-200">
                    <h3 class="font-medium text-gray-700 flex items-center">
                        <i class="fas fa-clock text-yellow-500 mr-2"></i>
                        Waiting for Verification
                    </h3>
                    <p class="text-sm text-gray-600 mt-1">
                        <% if ("Nurse".equalsIgnoreCase(userType)) { %>
                            Your nurse account is waiting for approval from a doctor. This process typically takes 24 hours.
                        <% } else if ("Doctor".equalsIgnoreCase(userType)) { %>
                            Your doctor account is waiting for approval from an administrator. This process typically takes 24-48 hours.
                        <% } else { %>
                            Your account is currently under review by an administrator. This process typically takes 24-48 hours.
                        <% } %>
                    </p>
                </div>
                
                <div class="bg-gray-50 rounded-lg p-4 border border-gray-200">
                    <h3 class="font-medium text-gray-700 flex items-center">
                        <i class="fas fa-user-shield text-blue-500 mr-2"></i>
                        Approval Process
                    </h3>
                    <p class="text-sm text-gray-600 mt-1">
                        <% if ("Nurse".equalsIgnoreCase(userType)) { %>
                            A doctor will verify your credentials and approve your account. You'll be able to access the system after approval.
                        <% } else if ("Doctor".equalsIgnoreCase(userType)) { %>
                            An administrator will verify your credentials and approve your account. You'll be able to access the system after approval.
                        <% } else { %>
                            A member of our team will verify your information and activate your account. You'll be able to log in once approved.
                        <% } %>
                    </p>
                </div>
                
                <div class="bg-gray-50 rounded-lg p-4 border border-gray-200">
                    <h3 class="font-medium text-gray-700 flex items-center">
                        <i class="fas fa-question-circle text-green-500 mr-2"></i>
                        Next Steps
                    </h3>
                    <p class="text-sm text-gray-600 mt-1">
                        You can try logging in again later. If your account has been approved, you'll be able to access the system.
                        If you have any questions, please contact support.
                    </p>
                </div>
            </div>
            
            <div class="mt-8 flex justify-center space-x-3">
                <a href="login.jsp" class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition shadow-sm flex items-center">
                    <i class="fas fa-sign-in-alt mr-2"></i>
                    Return to Login
                </a>
                <a href="mailto:support@mbchospital.com" class="px-4 py-2 bg-gray-200 text-gray-700 rounded-md hover:bg-gray-300 transition shadow-sm flex items-center">
                    <i class="fas fa-envelope mr-2"></i>
                    Contact Support
                </a>
            </div>
        </div>
        
        <div class="bg-gray-50 px-6 py-4 border-t border-gray-200">
            <div class="flex items-center justify-center text-gray-500 text-sm">
                <i class="fas fa-hospital-alt text-blue-500 mr-2"></i>
                <span>MBC Hospital Healthcare Management System</span>
            </div>
            <p class="text-center text-gray-500 text-xs mt-1">
                &copy; <%= new java.util.Date().getYear() + 1900 %> All rights reserved.
            </p>
        </div>
    </div>
    
    <script>
        // Optional: Add a timer to show how long the user has been waiting
        document.addEventListener('DOMContentLoaded', function() {
            // You could implement a countdown timer here if needed
        });
    </script>
</body>
</html> 