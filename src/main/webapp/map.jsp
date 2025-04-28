<%@ page import="com.mbc_hospital.model.MapModel" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Debugging: check if the hospital object is being passed properly
    MapModel hospital = (MapModel) request.getAttribute("hospital");
    if (hospital == null) {
        out.println("Hospital info not found. Please access this page via the controller: /MapController");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Get Directions - <%= hospital.getName() %></title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center p-8">
    <div class="bg-white shadow-xl rounded-2xl p-6 w-full max-w-4xl">
        <h1 class="text-3xl font-bold text-blue-700 mb-4 text-center">
            Directions to <%= hospital.getName() %>
        </h1>
        <p class="text-gray-600 text-center mb-4">
            <%= hospital.getAddress() %>
        </p>

        <div class="w-full h-96 mb-6">
            <iframe 
                src="<%= hospital.getEmbedUrl() %>" 
                width="100%" 
                height="100%" 
                style="border:0;" 
                allowfullscreen 
                loading="lazy" 
                referrerpolicy="no-referrer-when-downgrade" 
                class="rounded-lg shadow-md">
            </iframe>
        </div>

        <div class="text-center">
            <a href="<%= hospital.getMapLink() %>" target="_blank"
               class="inline-block px-6 py-3 bg-blue-600 text-white font-semibold rounded-lg shadow hover:bg-blue-700 transition duration-300">
                Open in Google Maps
            </a>
        </div>
    </div>
</body>
</html>
