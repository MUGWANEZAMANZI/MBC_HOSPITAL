<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.mbc_hospital.model.User" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    //HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userType = (String) session.getAttribute("usertype");
    if (userType == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Redirect based on user type
    String[] roles = {"doctor", "nurse", "patient"}; 
    if (userType.toLowerCase().equals(roles[0])) {
        response.sendRedirect("doctor.jsp");
        return;
    } else if (userType.toLowerCase().equals(roles[1])) {
        response.sendRedirect("nurse.jsp");
        return;
    } else if (userType.toLowerCase().equals(roles[2])) {
        response.sendRedirect("patient.jsp");
        return;
    }
%>

<html>
<head>
    <title>User directory</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen font-sans text-gray-800">
    <header class="bg-blue-600 text-white py-4 shadow-md">
        <div class="container mx-auto flex justify-between items-center">
            <h1 class="text-2xl font-bold">Admin Dashboard</h1>
            <div class="flex">            
                <a class="block text-white bg-gray-800 hover:bg-gray-900 focus:outline-none focus:ring-4 focus:ring-gray-300 font-medium rounded-full text-sm px-5 py-2 me-2 dark:bg-gray-800 dark:hover:bg-gray-700 dark:focus:ring-gray-700 dark:border-gray-700" href="dashboard.jsp">Home</a>
                <p class="text-sm px-5 py-2 me-2">Welcome, <span class="font-semibold"><%= session.getAttribute("username") %></span></p>
            </div>
        </div>
    </header>
    <div class="container mx-auto p-6">
        <h2 class="text-2xl font-bold mb-6">User Directory</h2>
        <div class="overflow-x-auto">
            <%
                        List<User> users = (List<User>) request.getAttribute("userList");
                    %>
                    
             <a href="#" class="block max-w-sm p-6 bg-gray-800 my-4 border border-gray-200 rounded-lg shadow-sm hover:bg-gray-100 dark:bg-gray-800 dark:border-gray-700 dark:hover:bg-gray-700">

      <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">Total Users</h5>
      <p class="font-normal text-gray-700 dark:text-gray-400"><%= (users != null) ? users.size() : 0 %></p>
  </a>
            <table class="min-w-full table-auto border border-gray-200">
                <thead class="bg-gray-200">
                    <tr>
                        <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700 border-b">User ID</th>
                        <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700 border-b">Username</th>
                        <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700 border-b">User Type</th>
                        <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700 border-b">Action</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <%
                        for (User user : users) {
                    %>
                    <tr class="hover:bg-gray-50">
                        <td class="px-4 py-3 text-sm"><%= user.getUserID() %></td>
                        <td class="px-4 py-3 text-sm"><%= user.getUsername() %></td>
                        <td class="px-4 py-3 text-sm capitalize"><%= user.getUserType() %></td>
                        <td class="px-4 py-3 text-sm">
                            <a href="users?action=delete&id=<%= user.getUserID() %>" 
                               onclick="return confirm('Are you sure?')"
                               class="text-red-600 hover:text-red-800 font-medium transition duration-150 ease-in-out">
                                Delete
                            </a>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
