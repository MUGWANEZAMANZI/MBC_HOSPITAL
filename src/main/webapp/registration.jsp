<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>MBC - Registration</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
</head>
<body class="bg-blue-200 min-h-screen flex flex-col">
    <header class="text-center text-xl text-white py-4 bg-blue-600">
        <h1>MBC Hospital</h1>
    </header>

    <main class="flex-grow flex justify-center items-center">
        <div class="flex flex-row bg-white w-fit h-fit m-10 p-10 border-1 rounded-s-2xl shadow-lg">
            <div>
                <h1 class="text-center text-blue-600 text-xl py-4">Admin Registration</h1>
                <form method="post" action="registration">
                    <div class="flex-none overflow-auto m-1">
                        <table>
                            <tr>
                                <td class="text-blue-600">Username:</td>
                                <td><input type="text" name="uname" class="rounded-md p-1 m-1 border border-blue-300" /></td>
                            </tr>
                            <tr>
                                <td class="text-blue-600">Password:</td>
                                <td><input type="password" name="pass" class="rounded-md p-1 m-1 border border-blue-300" /></td>
                            </tr>
                            <tr>
                                <td class="text-blue-600">Terms and Conditions:</td>
                                <td><input type="checkbox" class="m-1" /></td>
                            </tr>
                            <tr>
                                <td colspan="2" class="text-center">
                                    <input type="submit" value="Register" class="bg-blue-500 text-white rounded-xl p-2 m-2 hover:bg-blue-600 transition" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </form>
            </div>
            <div>
                <img src="images/hospital.jpg" alt="Hospital" class="rounded-lg shadow-md" width="400" />
            </div>
        </div>
    </main>

    <footer class="text-center text-white py-4 bg-gray-800">
        <p>Team 1 &copy; All rights reserved</p>
    </footer>
</body>
</html>
