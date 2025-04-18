<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String userType = (String) session.getAttribute("usertype"); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Diagnosis Records</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<%
    String message = (String) session.getAttribute("message");
    String error = (String) session.getAttribute("error");
    if (message != null) {
%>
    <div class="bg-green-200 text-green-800 px-4 py-2 rounded shadow mb-4 w-fit mx-auto">
        <%= message %>
    </div>
<%
        session.removeAttribute("message");
    }
    if (error != null) {
%>
    <div class="bg-red-200 text-red-800 px-4 py-2 rounded shadow mb-4 w-fit mx-auto">
        <%= error %>
    </div>
<%
        session.removeAttribute("error");
    }
%>
<header class="bg-blue-600 text-white py-4 shadow-md">
    <div class="container mx-auto flex justify-between items-center">
        <h1 class="text-2xl font-bold">Diagnosis Records</h1>
        <p>Welcome, <span class="font-semibold"><%= session.getAttribute("username") %></span></p>
        
    </div>
</header>

<div class="container mx-auto p-4">
    <h2 class="text-xl font-semibold mb-4">Diagnosis Table</h2>
    <div class="overflow-x-auto">
        <table class="table-auto w-full border-collapse border border-gray-300">
            <thead>
                <tr class="bg-gray-200">
                    <th class="border px-4 py-2">DiagnosisID</th>
                    <th class="border px-4 py-2">PatientID</th>
                    <th class="border px-4 py-2">NurseID</th>
                    <th class="border px-4 py-2">DoctorID</th>
                    <th class="border px-4 py-2">Status</th>
                    <th class="border px-4 py-2">Result</th>
                    <th class="border px-4 py-2">Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    java.util.List<com.mbc_hospital.model.Diagnosis> diagnosisList =
                        (java.util.List<com.mbc_hospital.model.Diagnosis>) request.getAttribute("diagnosisList");
                    if (diagnosisList != null && !diagnosisList.isEmpty()) {
                        for (com.mbc_hospital.model.Diagnosis d : diagnosisList) {
                            String status = d.getStatus();
                %>
                <tr class="bg-white">
                    <td class="border px-4 py-2"><%= d.getDiagnosisId() %></td>
                    <td class="border px-4 py-2"><%= d.getPatientId() %></td>
                    <td class="border px-4 py-2"><%= d.getNurseId() %></td>
                    <td class="border px-4 py-2"><%= d.getDoctorId() %></td>
                    <td class="border px-4 py-2"><%= status %></td>
                    <td class="border px-4 py-2"><%= d.getResult() %></td>
                    <td class="border px-4 py-2">
                        <%
                            if ("Nurse".equalsIgnoreCase(userType)) {
                                if ("referrable".equalsIgnoreCase(status)) {
                        %>
                            <form action="TransferDiagnosisServlet" method="post">
                                <input type="hidden" name="diagnosisId" value="<%= d.getDiagnosisId() %>"/>
                                <button class="bg-yellow-500 text-white px-3 py-1 rounded hover:bg-yellow-600">Transfer Case</button>
                            </form>
                        <%
                                } else {
                        %>
                            <form action="SolveDiagnosisServlet" method="post">
                                <input type="hidden" name="diagnosisId" value="<%= d.getDiagnosisId() %>"/>
                                <button class="bg-green-500 text-white px-3 py-1 rounded hover:bg-green-600">Solve Case</button>
                            </form>
                        <%
                                }
                            } else if ("Doctor".equalsIgnoreCase(userType)) {
                                if ("referrable".equalsIgnoreCase(status)) {
                        %>
                            <form action="SolveDiagnosisServlet" method="post">
                                <input type="hidden" name="diagnosisId" value="<%= d.getDiagnosisId() %>"/>
                                <button class="bg-green-500 text-white px-3 py-1 rounded hover:bg-green-600">Solve Case</button>
                            </form>
                        
                        <%
                                } else {
                        %>
                            <span class="text-gray-400 italic">No actions available</span>
                        <%
                                }
                            } else {
                        %>
                            <span class="text-red-500">--</span>
                        <%
                            }
                        %>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="7" class="text-center px-4 py-2">No diagnosis records found.</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

    <div class="mt-4">
        <a href="dashboard.jsp" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Back to Dashboard</a>
    </div>
</div>
</body>
</html>
