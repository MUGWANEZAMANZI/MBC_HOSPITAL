<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.mbc_hospital.model.Patient, com.mbc_hospital.model.Diagnosis, com.mbc_hospital.dao.DiagnosisDAO" %>
<%@ page import="java.sql.SQLException" %>

<%
    String diagnosisId = request.getParameter("id");
    if (diagnosisId == null || diagnosisId.isEmpty()) {
        out.println("No diagnosis ID provided");
        return;
    }
    
    Diagnosis diagnosis = null;
    try {
        int id = Integer.parseInt(diagnosisId);
        DiagnosisDAO dao = new DiagnosisDAO();
        diagnosis = dao.getDiagnosisById(id);
    } catch (SQLException e) {
        out.println("SQL Error: " + e.getMessage());
        e.printStackTrace(new java.io.PrintWriter(out));
        return;
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
        e.printStackTrace(new java.io.PrintWriter(out));
        return;
    }
    
    if (diagnosis == null) {
        out.println("Diagnosis not found");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Debug Diagnosis Details</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h1>Diagnosis Debug Information</h1>
    
    <table>
        <tr>
            <th>Field</th>
            <th>Value</th>
        </tr>
        <tr>
            <td>Diagnosis ID</td>
            <td><%= diagnosis.getDiagnosisId() %></td>
        </tr>
        <tr>
            <td>Patient ID</td>
            <td><%= diagnosis.getPatientId() %></td>
        </tr>
        <tr>
            <td>Nurse ID</td>
            <td><%= diagnosis.getNurseId() %></td>
        </tr>
        <tr>
            <td>Doctor ID</td>
            <td><%= diagnosis.getDoctorId() %></td>
        </tr>
        <tr>
            <td>Status</td>
            <td><%= diagnosis.getStatus() %></td>
        </tr>
        <tr>
            <td>Result</td>
            <td><%= diagnosis.getResult() %></td>
        </tr>
        <tr>
            <td>Medications Prescribed</td>
            <td><%= diagnosis.getMedicationsPrescribed() != null ? diagnosis.getMedicationsPrescribed() : "N/A" %></td>
        </tr>
        <tr>
            <td>Follow-up Date</td>
            <td><%= diagnosis.getFollowUpDate() != null ? diagnosis.getFollowUpDate() : "N/A" %></td>
        </tr>
        <tr>
            <td>Diagnosis Date</td>
            <td><%= diagnosis.getDiagnosisDate() != null ? diagnosis.getDiagnosisDate() : "N/A" %></td>
        </tr>
        <tr>
            <td>Nurse Assessment</td>
            <td><%= diagnosis.getNurseAssessment() != null ? diagnosis.getNurseAssessment() : "N/A" %></td>
        </tr>
    </table>
    
    <p><a href="nurse-referred-cases">Back to Referred Cases</a></p>
</body>
</html> 