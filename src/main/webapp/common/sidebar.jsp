<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String userType = (String) session.getAttribute("usertype");
    String username = (String) session.getAttribute("username");
    
    // Set a variable to use for active menu highlighting
    String currentPage = request.getParameter("currentPage");
    if (currentPage == null) currentPage = "";
%>

<aside class="sidebar">
    <div class="sidebar-header">
        <div class="flex items-center space-x-2">
            <i class="fas fa-hospital text-3xl"></i>
            <h1 class="text-2xl font-bold">MBC Hospital</h1>
        </div>
        <p class="text-blue-200 text-sm mt-1">Healthcare Management</p>
    </div>
    
    <div class="mt-2">
        <div class="sidebar-user">
            <div class="flex items-center space-x-4">
                <div class="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center">
                    <i class="fas fa-user text-xl"></i>
                </div>
                <div>
                    <p class="text-sm text-blue-100">Welcome,</p>
                    <p class="font-semibold"><%= username %></p>
                </div>
            </div>
        </div>
        
        <nav class="mt-6 px-4">
            <!-- Common link for all users -->
            <a href="dashboard.jsp" class="sidebar-link <%= "dashboard".equals(currentPage) ? "active" : "" %>">
                <i class="fas fa-tachometer-alt w-6"></i>
                <span>Dashboard</span>
            </a>
            
            <!-- Admin specific links -->
            <% if ("Admin".equalsIgnoreCase(userType)) { %>
                <a href="users-directory" class="sidebar-link <%= "users".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-users w-6"></i>
                    <span>User Directory</span>
                </a>
                <a href="view_doctors.jsp" class="sidebar-link <%= "doctors".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-user-md w-6"></i>
                    <span>Doctors</span>
                </a>
                <a href="view_nurses.jsp" class="sidebar-link <%= "nurses".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-user-nurse w-6"></i>
                    <span>Nurses</span>
                </a>
                <a href="all-patients.jsp" class="sidebar-link <%= "patients".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-procedures w-6"></i>
                    <span>Patients</span>
                </a>
                <a href="new-doctor.jsp" class="sidebar-link <%= "newdoctor".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-user-plus w-6"></i>
                    <span>Register Doctor</span>
                </a>
            <% } %>
            
            <!-- Doctor specific links -->
            <% if ("Doctor".equalsIgnoreCase(userType)) { %>
                <a href="create-nurse" class="sidebar-link <%= "registernurse".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-user-plus w-6"></i>
                    <span>Register Nurse</span>
                </a>
                <a href="view_nurses.jsp" class="sidebar-link <%= "nurses".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-user-nurse w-6"></i>
                    <span>Registered Nurses</span>
                </a>
                <a href="referred-diagnoses" class="sidebar-link <%= "pending".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-clipboard-check w-6"></i>
                    <span>Awaiting Diagnosis</span>
                </a>
                <a href="confirmed-cases" class="sidebar-link <%= "confirmed".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-check-circle w-6"></i>
                    <span>Confirmed Cases</span>
                </a>
            <% } %>
            
            <!-- Nurse specific links -->
            <% if ("Nurse".equalsIgnoreCase(userType)) { %>
                <a href="create_patient.jsp" class="sidebar-link <%= "newpatient".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-user-plus w-6"></i>
                    <span>Register Patient</span>
                </a>
                <a href="patients" class="sidebar-link <%= "mypatients".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-user-injured w-6"></i>
                    <span>My Patients</span>
                </a>
                <a href="all_patients.jsp" class="sidebar-link <%= "diagnose".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-stethoscope w-6"></i>
                    <span>Diagnose</span>
                </a>
            <% } %>
            
            <!-- Patient specific links -->
            <% if ("Patient".equalsIgnoreCase(userType)) { %>
                <a href="patientDashboard.jsp" class="sidebar-link <%= "myresults".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-file-medical w-6"></i>
                    <span>My Results</span>
                </a>
                <a href="appointment.jsp" class="sidebar-link <%= "appointment".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-calendar-check w-6"></i>
                    <span>Appointments</span>
                </a>
            <% } %>
            
            <!-- Logout link for all users -->
            <a href="logout.jsp" class="sidebar-link mt-8 bg-red-500/20 hover:bg-red-500/30">
                <i class="fas fa-sign-out-alt w-6"></i>
                <span>Logout</span>
            </a>
        </nav>
    </div>
</aside> 