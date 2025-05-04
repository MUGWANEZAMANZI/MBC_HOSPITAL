<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.mbc_hospital.model.Nurse" %>
<html>
<head>
    <title>Nurse Dashboard</title>
    <style>
        table, th, td {
            border: 1px solid #ddd;
            border-collapse: collapse;
            padding: 10px;
        }
    </style>
</head>
<body>
    <h2>All Nurses</h2>
    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Telephone</th>
            <th>Email</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
       <% 
    List<Nurse> nurses = (List<Nurse>) request.getAttribute("nurses");
    if (nurses != null) {
        for (Nurse nurse : nurses) {
%>
<tr>
    <td><%= nurse.getNurseId() %></td>
    <td><%= nurse.getFirstName() %> <%= nurse.getLastName() %></td>
    <td><%= nurse.getTelephone() %></td>
    <td><%= nurse.getEmail() %></td>
    <td><%= nurse.getStatus() %></td>
    <td>
        <form method="post" action="NurseController">
            <input type="hidden" name="nurseId" value="<%= nurse.getNurseId() %>" />
            <select name="status">
                <option value="Active" <%= "Active".equals(nurse.getStatus()) ? "selected" : "" %>>Active</option>
                <option value="Inactive" <%= "Inactive".equals(nurse.getStatus()) ? "selected" : "" %>>Inactive</option>
            </select>
            <input type="submit" value="Update" />
        </form>
    </td>
</tr>
<%
        }
    } else {
%>
<tr><td colspan="6">No nurses found.</td></tr>
<%
    }
%>
       
    </table>
</body>
</html>
