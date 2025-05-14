<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.mbc_hospital.model.Nurse" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="WEB-INF/includes/header.jsp">
        <jsp:param name="title" value="Nurse Dashboard" />
    </jsp:include>
</head>
<body class="page-container bg-gray-50">
    <div class="flex">
        <jsp:include page="WEB-INF/includes/sidebar.jsp">
            <jsp:param name="currentPage" value="nurses" />
        </jsp:include>
        
        <div class="flex-1 lg:ml-64">
            <header class="main-header">
                <div class="flex items-center">
                    <button id="menu-toggle" class="text-gray-600 hover:text-gray-800 mr-4 lg:hidden">
                        <i class="fas fa-bars text-xl"></i>
                    </button>
                    <h1 class="text-xl font-bold text-gray-800">Registered Nurses</h1>
                </div>
                
                <div class="flex items-center space-x-4">
                    <div class="relative">
                        <input type="text" placeholder="Search nurses..." class="w-40 md:w-64 rounded-lg border border-gray-300 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500 pl-10">
                        <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                    </div>
                    
                    <a href="#" class="btn-primary btn-sm">
                        <i class="fas fa-plus-circle mr-2"></i>
                        Add New Nurse
                    </a>
                </div>
            </header>
            
            <main class="p-6">
                <div class="bg-white rounded-lg shadow-md p-6 mb-6">
                    <h2 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                        <i class="fas fa-user-nurse text-blue-600 mr-2"></i>
                        Nurse Directory
                    </h2>
                    
                    <div class="table-container">
                        <table class="data-table">
                            <thead class="table-header">
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Telephone</th>
                                    <th>Email</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody class="table-body">
                                <% 
                                List<Nurse> nurses = (List<Nurse>) request.getAttribute("nurses");
                                if (nurses != null && !nurses.isEmpty()) {
                                    for (Nurse nurse : nurses) {
                                %>
                                <tr>
                                    <td><%= nurse.getNurseId() %></td>
                                    <td class="flex items-center">
                                        <div class="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center mr-3">
                                            <i class="fas fa-user-nurse text-blue-600"></i>
                                        </div>
                                        <%= nurse.getFirstName() %> <%= nurse.getLastName() %>
                                    </td>
                                    <td><i class="fas fa-phone text-gray-400 mr-2"></i><%= nurse.getTelephone() %></td>
                                    <td><i class="fas fa-envelope text-gray-400 mr-2"></i><%= nurse.getEmail() %></td>
                                    <td>
                                        <span class="px-2 py-1 rounded-full text-xs font-medium 
                                            <%= "Active".equals(nurse.getStatus()) ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800" %>">
                                            <%= nurse.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <form method="post" action="NurseController" class="flex items-center space-x-2">
                                            <input type="hidden" name="nurseId" value="<%= nurse.getNurseId() %>" />
                                            <select name="status" class="form-select py-1 px-2 text-sm rounded">
                                                <option value="Active" <%= "Active".equals(nurse.getStatus()) ? "selected" : "" %>>Active</option>
                                                <option value="Inactive" <%= "Inactive".equals(nurse.getStatus()) ? "selected" : "" %>>Inactive</option>
                                            </select>
                                            <button type="submit" class="bg-blue-600 text-white px-3 py-1 rounded hover:bg-blue-700 text-sm">
                                                <i class="fas fa-save mr-1"></i> Update
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <tr>
                                    <td colspan="6" class="text-center py-8">
                                        <div class="flex flex-col items-center">
                                            <i class="fas fa-user-nurse text-gray-300 text-5xl mb-3"></i>
                                            <p class="text-gray-500">No nurses found in the system.</p>
                                            <a href="#" class="text-blue-600 hover:underline mt-2">
                                                <i class="fas fa-plus-circle mr-1"></i> Register a new nurse
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                }
                                %>
                            </tbody>
                        </table>
                    </div>
                    
                    <div class="mt-6 flex justify-between items-center">
                        <div>
                            <p class="text-sm text-gray-500">Showing <%= nurses != null ? nurses.size() : 0 %> nurses</p>
                        </div>
                        <div class="flex space-x-2">
                            <button class="px-3 py-1 border border-gray-300 rounded text-gray-600 hover:bg-gray-50 disabled:opacity-50" disabled>
                                <i class="fas fa-chevron-left mr-1"></i> Previous
                            </button>
                            <button class="px-3 py-1 border border-gray-300 rounded text-gray-600 hover:bg-gray-50 disabled:opacity-50" disabled>
                                Next <i class="fas fa-chevron-right ml-1"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
    
    <jsp:include page="WEB-INF/includes/footer.jsp" />
</body>
</html>
