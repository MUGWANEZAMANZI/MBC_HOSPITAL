<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Session Debug</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-8">
    <div class="max-w-4xl mx-auto bg-white p-6 rounded-lg shadow-md">
        <h1 class="text-2xl font-bold mb-6 text-blue-800">Session Attributes Debug</h1>
        
        <div class="overflow-x-auto">
            <table class="min-w-full border-collapse border border-gray-300">
                <thead>
                    <tr class="bg-gray-200">
                        <th class="border px-4 py-2 w-1/3">Attribute Name</th>
                        <th class="border px-4 py-2">Attribute Value</th>
                        <th class="border px-4 py-2 w-1/4">Type</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    Enumeration<String> attributeNames = session.getAttributeNames();
                    if (!attributeNames.hasMoreElements()) {
                    %>
                    <tr>
                        <td colspan="3" class="border px-4 py-8 text-center text-gray-500">
                            No session attributes found.
                        </td>
                    </tr>
                    <%
                    } else {
                        while (attributeNames.hasMoreElements()) {
                            String name = attributeNames.nextElement();
                            Object value = session.getAttribute(name);
                            String typeName = value != null ? value.getClass().getName() : "null";
                    %>
                    <tr>
                        <td class="border px-4 py-2 font-medium"><%= name %></td>
                        <td class="border px-4 py-2"><%= value %></td>
                        <td class="border px-4 py-2 text-gray-600 text-sm"><%= typeName %></td>
                    </tr>
                    <%
                        }
                    }
                    %>
                </tbody>
            </table>
        </div>
        
        <div class="mt-8">
            <h2 class="text-xl font-semibold mb-4 text-blue-700">Request Information</h2>
            <div class="bg-gray-50 p-4 rounded border border-gray-200">
                <p><strong>Remote Address:</strong> <%= request.getRemoteAddr() %></p>
                <p><strong>Session ID:</strong> <%= session.getId() %></p>
                <p><strong>Session Creation Time:</strong> <%= new java.util.Date(session.getCreationTime()) %></p>
                <p><strong>Session Last Accessed:</strong> <%= new java.util.Date(session.getLastAccessedTime()) %></p>
                <p><strong>User Agent:</strong> <%= request.getHeader("User-Agent") %></p>
            </div>
        </div>
        
        <div class="mt-6">
            <a href="dashboard.jsp" class="inline-block bg-blue-500 hover:bg-blue-600 text-white font-medium py-2 px-4 rounded">
                Back to Dashboard
            </a>
        </div>
    </div>
</body>
</html> 