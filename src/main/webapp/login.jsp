<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
</head>
<body class="bg-blue-200 min-h-screen flex flex-col">
    <header class="text-center text-xl text-white py-4 bg-blue-600">
        <h1>MBC Hospital</h1>
    </header>

    <main class="flex-grow flex justify-center items-center">
        <div class="bg-white w-fit h-fit m-10 p-10 border-1 rounded-s-2xl shadow-lg">
            <h2 class="text-center text-blue-600 text-xl py-4">Login</h2>
            <form method="post" action="login">
                <table class="w-full">
                    <tr>
                        <td class="text-blue-600 py-2">Username:</td>
                        <td>
                            <input type="text" name="username" class="rounded-md p-2 border border-blue-300 w-full" required>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-blue-600 py-2">Password:</td>
                        <td>
                            <input type="password" name="password" class="rounded-md p-2 border border-blue-300 w-full" required>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="text-center py-4">
                            <input type="submit" value="Login" class="bg-blue-500 text-white rounded-xl px-4 py-2 hover:bg-blue-600 transition">
                        </td>
                    </tr>
                </table>
            </form>
            <% if (request.getParameter("error") != null) { %>
                <p class="text-red-500 text-center mt-4">Login failed. Try again.</p>
            <% } %>
            <div class="text-center mt-4">
                <a href="registration.jsp" class="text-blue-500 hover:underline">New Register here</a>
            </div>
        </div>
    </main>

    <footer class="text-center text-white py-4 bg-gray-800">
        <p>Team 1 &copy; 2025</p>
    </footer>
</body>
</html>
