<%@ page import="java.net.*, java.io.*" %>
<%@ page import="java.util.*" %>
<%
//Optional: Ensure only logged-in users can access
if (session.getAttribute("id") == null) {
 response.sendRedirect("login.jsp");
 return;
}

int userID = (Integer) session.getAttribute("id");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Details</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            background-color: #f5f7fa;
            color: #333;
        }
        .container-man {
            max-width: 1200px;
            margin: 0 auto;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 25px;
        }
        h2 {
            color: #2c3e50;
            margin-top: 0;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
        }
        h2::before {
            content: "";
            display: inline-block;
            width: 24px;
            height: 24px;
            background-color: #3498db;
            margin-right: 10px;
            border-radius: 50%;
        }
        .verified-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background-color: #2ecc71;
            color: white;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            font-size: 14px;
            margin-right: 8px;
        }
        .doctors-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .doctors-table th {
            background-color: #f8f9fa;
            padding: 12px 15px;
            text-align: left;
            font-weight: 600;
            color: #2c3e50;
            border-bottom: 2px solid #ddd;
        }
        .doctors-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
        }
        .doctors-table tr:hover {
            background-color: #f8f9fa;
        }
        .verified-cell {
            text-align: center;
        }
        .verified-true {
            color: #2ecc71;
            font-weight: 600;
        }
        .verified-false {
            color: #e74c3c;
        }
        .error-container {
            background-color: #ffecec;
            color: #e74c3c;
            padding: 15px;
            border-radius: 5px;
            margin-top: 20px;
            border-left: 4px solid #e74c3c;
        }
        .empty-state {
            text-align: center;
            padding: 40px 0;
            color: #7f8c8d;
        }
    </style>
</head>
<body>
<!-- Header -->
    <header class="bg-gradient-to-r from-blue-700 to-blue-900 text-white shadow-xl mb-10">
        <div class="container mx-auto py-4 px-6">
            <div class="flex justify-between items-center">
                <div class="flex items-center space-x-3">
                    <i class="fas fa-hospital text-3xl text-blue-200"></i>
                    <h1 class="text-3xl font-bold tracking-tight">MBC HOSPITAL</h1>
                </div>
                <div class="flex items-center space-x-6">
                    <a href="/reffered" class="flex items-center px-4 py-2 bg-blue-800 hover:bg-blue-600 rounded-lg transition duration-300 shadow-md" href="/reffered">
                        <i class="fas fa-arrow-left mr-2"></i> Back to Dashboard
                    </a>
                    <div class="flex items-center bg-blue-800/50 px-4 py-2 rounded-lg">
                        <i class="fas fa-user-circle text-xl mr-2 text-blue-200"></i>
                        <p>Welcome, <span class="font-semibold"><%= session.getAttribute("username") %></span></p>
                    </div>
                </div>
            </div>
        </div>
    </header>
    <div class="container-man">
        <h2>
            <span class="verified-badge"></span>
            Verified Doctors
        </h2>
        
        <%
        boolean hasData = false;
        try {
            URL url = new URL("http://localhost:8080/MBC_HOSPITAL/doctor-list-data");
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setConnectTimeout(5000);
            connection.setReadTimeout(5000);
            
            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                String line;
                List<String[]> doctorData = new ArrayList<>();
                
                while ((line = reader.readLine()) != null) {
                    if (line.startsWith("ERROR")) continue; // skip error message
                    String[] parts = line.split("\\|");
                    if (parts.length == 5) {
                        doctorData.add(parts);
                        hasData = true;
                    }
                }
                reader.close();
                
                if (hasData) {
        %>
                    <table class="doctors-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Doctor Name</th>
                                <th>Specialty</th>
                                <th>Registration Date</th>
                                <th>Verification Status</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% 
                            for (String[] doctor : doctorData) {
                                boolean isVerified = "true".equalsIgnoreCase(doctor[4]) || "yes".equalsIgnoreCase(doctor[4]) || "1".equals(doctor[4]);
                        %>
                            <tr>
                                <td><%= doctor[0] %></td>
                                <td><%= doctor[1] %></td>
                                <td><%= doctor[2] %></td>
                                <td><%= doctor[3] %></td>
                                <td class="verified-cell <%= isVerified ? "verified-true" : "verified-false" %>">
                                    <%= isVerified ? "Verified" : "Pending" %>
                                </td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
        <%
                } else {
        %>
                    <div class="empty-state">
                        <h3>No verified doctors found</h3>
                        <p>There are currently no verified doctors in the system.</p>
                    </div>
        <%
                }
            } else {
                throw new IOException("HTTP error code: " + responseCode);
            }
        } catch (Exception e) {
        %>
            <div class="error-container">
                <strong>Unable to load doctor data:</strong> <%= e.getMessage() %>
                <p>Please check the server connection and try again later.</p>
            </div>
        <%
        }
        %>
    </div>
</body>
</html>