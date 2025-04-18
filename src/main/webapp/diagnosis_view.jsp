<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Diagnosis Records</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
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
                </tr>
            </thead>
            <tbody>
                <%
                    java.util.List<com.mbc_hospital.model.Diagnosis> diagnosisList =
                        (java.util.List<com.mbc_hospital.model.Diagnosis>) request.getAttribute("diagnosisList");
                    if (diagnosisList != null && !diagnosisList.isEmpty()) {
                        for (com.mbc_hospital.model.Diagnosis d : diagnosisList) {
                %>
                <tr class="bg-white">
                    <td class="border px-4 py-2"><%= d.getDiagnosisId() %></td>
                    <td class="border px-4 py-2"><%= d.getPatientId() %></td>
                    <td class="border px-4 py-2"><%= d.getNurseId() %></td>
                    <td class="border px-4 py-2"><%= d.getDoctorId() %></td>
                    <td class="border px-4 py-2"><%= d.getStatus() %></td>
                    <td class="border px-4 py-2"><%= d.getResult() %></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="6" class="text-center px-4 py-2">No diagnosis records found.</td>
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
