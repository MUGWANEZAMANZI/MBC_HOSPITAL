<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
// Optional: Ensure only logged-in users can access
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
    <title>Register New Patient</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
</head>
<body class="bg-gray-50 min-h-screen">
    <!-- Header -->
    <header class="bg-gradient-to-r from-blue-700 to-blue-900 text-white shadow-xl">
        <div class="container mx-auto py-4 px-6">
            <div class="flex justify-between items-center">
                <div class="flex items-center space-x-3">
                    <i class="fas fa-hospital text-3xl text-blue-200"></i>
                    <h1 class="text-3xl font-bold tracking-tight">MBC HOSPITAL</h1>
                </div>
                <div class="flex items-center space-x-6">
                    <a class="flex items-center px-4 py-2 bg-blue-800 hover:bg-blue-600 rounded-lg transition duration-300 shadow-md" href="nurse.jsp">
                        <i class="fas fa-home mr-2"></i>Home
                    </a>
                    <div class="flex items-center bg-blue-800/50 px-4 py-2 rounded-lg">
                        <i class="fas fa-user-circle text-xl mr-2 text-blue-200"></i>
                        <p>Welcome, <span class="font-semibold"><%= session.getAttribute("username") %></span></p>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <div class="container mx-auto px-4 py-10 max-w-4xl">
        <div class="bg-white rounded-xl shadow-lg overflow-hidden">
            <!-- Form Header -->
            <div class="bg-gradient-to-r from-blue-600 to-blue-800 py-4 px-6">
                <h2 class="text-2xl font-bold text-white flex items-center">
                    <i class="fas fa-user-plus mr-3"></i>
                    Register New Patient
                </h2>
                <p class="text-blue-100 mt-1">Enter the patient's information below</p>
            </div>

            <!-- Form Content -->
            <form action="CreatePatientServlet" method="post" enctype="multipart/form-data" class="p-6">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <div>
                        <label for="firstName" class="block text-sm font-medium text-gray-700 mb-1">First Name</label>
                        <input type="text" name="firstName" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition duration-200" required>
                    </div>
                    <div>
                        <label for="lastName" class="block text-sm font-medium text-gray-700 mb-1">Last Name</label>
                        <input type="text" name="lastName" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition duration-200" required>
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <div>
                        <label for="telephone" class="block text-sm font-medium text-gray-700 mb-1">
                            <i class="fas fa-phone mr-1 text-blue-600"></i> Telephone
                        </label>
                        <input type="text" name="telephone" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition duration-200" required>
                    </div>
                    <div>
                        <label for="email" class="block text-sm font-medium text-gray-700 mb-1">
                            <i class="fas fa-envelope mr-1 text-blue-600"></i> Email
                        </label>
                        <input type="email" name="email" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition duration-200">
                    </div>
                </div>

                <div class="mb-6">
                    <label for="address" class="block text-sm font-medium text-gray-700 mb-1">
                        <i class="fas fa-map-marker-alt mr-1 text-blue-600"></i> Address
                    </label>
                    <textarea name="address" rows="2" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition duration-200" required></textarea>
                </div>

                <div class="mb-8">
                    <label for="pImageLink" class="block text-sm font-medium text-gray-700 mb-1">
                        <i class="fas fa-camera mr-1 text-blue-600"></i> Patient Image
                    </label>
                    <div class="flex items-center">
                        <div class="w-full">
                            <div class="flex items-center justify-center w-full">
                                <label class="flex flex-col w-full h-24 border-2 border-dashed border-gray-300 rounded-lg cursor-pointer hover:bg-gray-50 transition duration-200">
                                    <div class="flex flex-col items-center justify-center pt-5">
                                        <i class="fas fa-cloud-upload-alt text-2xl text-blue-600 mb-1"></i>
                                        <p class="text-sm text-gray-500">Click to upload image</p>
                                    </div>
                                    <input type="file" name="pImageLink" class="opacity-0">
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <input type="hidden" name="registeredBy" value="<%= userID %>">

                <div class="flex justify-between items-center gap-4 border-t pt-6">
                    <a href="nurse_dashboard.jsp" class="px-6 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition duration-300 flex items-center">
                        <i class="fas fa-arrow-left mr-2"></i> Cancel
                    </a>
                    <button type="submit" class="px-6 py-2 bg-gradient-to-r from-blue-600 to-blue-700 text-white rounded-lg hover:from-blue-700 hover:to-blue-800 transition duration-300 flex items-center shadow-md">
                        <i class="fas fa-save mr-2"></i> Save Patient
                    </button>
                </div>
            </form>

            <%
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            if ("patient_created".equals(success)) {
            %>
            <div class="mx-6 mb-6 bg-green-100 border-l-4 border-green-500 text-green-700 p-4 rounded" role="alert">
                <div class="flex items-center">
                    <i class="fas fa-check-circle text-green-500 mr-2"></i>
                    <p>Patient registered successfully!</p>
                </div>
            </div>
            <%
            } else if ("creation_failed".equals(error)) {
            %>
            <div class="mx-6 mb-6 bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded" role="alert">
                <div class="flex items-center">
                    <i class="fas fa-exclamation-circle text-red-500 mr-2"></i>
                    <p>Failed to register patient. Please try again.</p>
                </div>
            </div>
            <%
            }
            %>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-blue-900 text-blue-200 mt-12 py-6">
        <div class="container mx-auto px-6 text-center">
            <p>© 2025 MBC Hospital. All rights reserved.</p>
            <div class="flex justify-center space-x-4 mt-2">
                <a href="#" class="hover:text-white transition duration-300"><i class="fab fa-facebook"></i></a>
                <a href="#" class="hover:text-white transition duration-300"><i class="fab fa-twitter"></i></a>
                <a href="#" class="hover:text-white transition duration-300"><i class="fab fa-linkedin"></i></a>
            </div>
        </div>
    </footer>
</body>
</html>