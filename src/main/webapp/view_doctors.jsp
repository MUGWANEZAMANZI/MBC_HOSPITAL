<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.mbc_hospital.model.Doctor" %>
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
<!DOCTYPE html>
<html>
<head>
    <title>Registered Doctors</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <style>
        .blue-gradient {
            background: linear-gradient(90deg, #2563eb, #3b82f6);
        }
        .hover-scale {
            transition: transform 0.3s ease;
        }
        .hover-scale:hover {
            transform: scale(1.02);
        }
        .table-row-hover:hover {
            background-color: rgba(59, 130, 246, 0.05);
        }
    </style>
</head>
<body class="bg-white">
    <!-- Top Navigation Bar -->
    
    <%
            List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
            if (doctors != null && !doctors.isEmpty()) {
            %>
    <nav class="blue-gradient shadow-lg text-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-16">
                <div class="flex items-center">
                    <span class="text-xl font-bold">MBC_HOSPITAL</span>
                </div>
                <div class="flex items-center space-x-4">
                    <a href="dashboard.jsp" class="flex items-center space-x-2 px-4 py-2 rounded-lg bg-white bg-opacity-20 hover:bg-opacity-30 transition duration-300">
                        <i class="fas fa-th-large"></i>
                        <span>Dashboard</span>
                    </a>
                    <div class="w-10 h-10 rounded-full bg-white bg-opacity-20 flex items-center justify-center">
                        <i class="fas fa-user-md text-lg"></i>
                    </div>
                    <%= session.getAttribute("username") %>
                </div>
            </div>
        </div>
    </nav>

    <div class="max-w-7xl mx-auto p-6 sm:p-10">
    
     <!-- Stats Cards -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mt-8">
            <div class="bg-white p-5 rounded-lg shadow-sm border border-gray-100 hover-scale">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-gray-500 text-sm">Total Doctors</p>
                        <h3 class="text-2xl font-bold text-gray-800 mt-1">
                            <%= doctors != null ? doctors.size() : 0 %>
                        </h3>
                    </div>
                    <div class="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center">
                        <i class="fas fa-user-md text-blue-500"></i>
                    </div>
                </div>
            </div>
            
            <div class="bg-white p-5 rounded-lg shadow-sm border border-gray-100 hover-scale">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-gray-500 text-sm">Hospitals</p>
                        <h3 class="text-2xl font-bold text-gray-800 mt-1">
                            <%
                            int hospitalCount = 0;
                            if (doctors != null) {
                                Set<String> hospitals = new HashSet<>();
                                for (Doctor doc : doctors) {
                                    if (doc.getHospitalName() != null && !doc.getHospitalName().trim().isEmpty()) {
                                        hospitals.add(doc.getHospitalName());
                                    }
                                }
                                hospitalCount = hospitals.size();
                            }
                            %>
                            <%= hospitalCount %>
                        </h3>
                    </div>
                    <div class="w-12 h-12 rounded-full bg-green-100 flex items-center justify-center">
                        <i class="fas fa-hospital text-green-500"></i>
                    </div>
                </div>
            </div>
            
            <div class="bg-white p-5 rounded-lg shadow-sm border border-gray-100 hover-scale">
                <div class="flex items-center justify-between">
                   <a href="new-doctor.jsp" class="flex items-center px-4 py-2   rounded-lg hover:shadow-md transition duration-300">
                    <i class="fas fa-plus mr-2"></i>
                    <span>Add New Doctor</span>
                </a>
                    <div class="w-12 h-12 rounded-full bg-indigo-100 flex items-center justify-center">
                        <i class="fas fa-user text-indigo-500"></i>
                    </div>
                </div>
            </div>
            
            <div class="bg-white p-5 rounded-lg shadow-sm border border-gray-100 hover-scale">
                <div class="flex items-center justify-between">
                    <a href="dashboard.jsp" class="flex items-center text-blue-600 hover:text-blue-800 transition duration-300">
                    <span class="font-medium">Back to Dashboard</span>
                </a>
                    <div class="w-12 h-12 rounded-full bg-yellow-100 flex items-center justify-center">
                        <i class="fas fa-arrow-left text-yellow-500"></i>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Page Header with Actions -->
        <div class="flex flex-col md:flex-row md:items-center mb-4 mt-6 md:justify-between mb-8 space-y-4 md:space-y-0">
            <div>
                <h1 class="text-2xl font-bold text-gray-800">Registered Doctors</h1>
                <p class="text-gray-500 mt-1">View and manage all medical professionals in the system</p>
            </div>
            
        </div>
        
        <!-- Modal -->
<div id="statusModal" class="fixed inset-0 bg-black bg-opacity-30 flex items-center justify-center hidden">
    <div class="bg-white p-6 rounded shadow-lg w-80">
        <h2 class="text-xl font-bold mb-4">Change Doctor Status</h2>
        <input type="hidden" id="statusDoctorId">
        <label class="block mb-2">New Status:</label>
        <select id="newStatus" class="w-full p-2 border border-gray-300 rounded mb-4">
            <option value="Active">active</option>
            <option value="Inactive">inactive</option>
            <option value="retired">retired</option>
        </select>
        <div class="flex justify-end gap-2">
            <button onclick="document.getElementById('statusModal').classList.add('hidden')" class="px-4 py-2 bg-gray-300 rounded">Cancel</button>
            <button onclick="changeStatus()" class="px-4 py-2 bg-blue-600 text-white rounded">Update</button>
        </div>
    </div>
</div>
        
       
        <!-- Doctors Table/List -->
        <div class="bg-white rounded-xl shadow-lg overflow-hidden border border-gray-100">
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead>
                        <tr class="text-black border-b bg-gray-50">
                            <th class="px-6 py-3 text-left font-semibold">ID</th>
                            <th class="px-6 py-3 text-left font-semibold">Full Name</th>
                            <th class="px-6 py-3 text-left font-semibold">Telephone</th>
                            <th class="px-6 py-3 text-left font-semibold">Email</th>
                            <th class="px-6 py-3 text-left font-semibold">Address</th>
                            <th class="px-6 py-3 text-left font-semibold">Hospital</th>
                            <th class="px-6 py-3 text-left font-semibold">Hospital</th>
                            <th class="px-6 py-3 text-left font-semibold">status</th>
                            <th class="px-6 py-3 text-left font-semibold">Change Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Doctor doc : doctors) { %>
                        <tr class="border-b border-gray-200 table-row-hover">
                            <td class="px-6 py-4"><%= doc.getDoctorId() %></td>
                            <td class="px-6 py-4 font-medium"><%= doc.getFirstName() %> <%= doc.getLastName() %></td>
                            <td class="px-6 py-4">
                                <div class="flex items-center">
                                    <i class="fas fa-phone text-gray-400 mr-2"></i>
                                    <%= doc.getTelephone() %>
                                </div>
                            </td>
                            <td class="px-6 py-4">
                                <div class="flex items-center">
                                    <i class="fas fa-envelope text-gray-400 mr-2"></i>
                                    <%= doc.getEmail() %>
                                </div>
                            </td>
                            <td class="px-6 py-4 max-w-xs truncate"><%= doc.getAddress() %></td>
                            <td class="px-6 py-4"><%= doc.getHospitalName() %></td>
                            <%
                             String status = doc.getStatus();
                             String statusClass = "";

                              switch (status) {
                              case "active":
                                 statusClass = "text-green-600 font-semibold";
                                 break;
                              case "inactive":
                                 statusClass = "text-yellow-600 font-semibold";
                                 break;
                              case "retired":
                                statusClass = "text-red-600 font-semibold";
                                break;
                              default:
                                statusClass = "text-gray-600";
                              }
                             %>
                            <td class="border px-4 py-2 <%= statusClass %>"><%= status %></td>           
                            <td class="px-6 py-4">
                                <div class="flex space-x-2">
                                    <button class="p-2 text-red-500 hover:text-red-700"
                                    onclick="openStatusModal(<%= doc.getDoctorId() %>, '<%= doc.getStatus() %>')"
                                     title="switchStatus">
                                     <i class="fas fa-retweet"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
            <!-- Pagination -->
            <div class="px-6 py-4 bg-gray-50 border-t border-gray-200 flex items-center justify-between">
                <div class="text-gray-500 text-sm">
                    Showing <span class="font-medium">1</span> to <span class="font-medium"><%= doctors.size() %></span> of <span class="font-medium"><%= doctors.size() %></span> doctors
                </div>
                <div class="flex space-x-1">
                    <button class="px-3 py-1 rounded border border-gray-300 bg-white text-gray-500 hover:bg-gray-50" disabled>
                        Previous
                    </button>
                    <button class="px-3 py-1 rounded border border-gray-300 bg-blue-600 text-white">
                        1
                    </button>
                    <button class="px-3 py-1 rounded border border-gray-300 bg-white text-gray-500 hover:bg-gray-50" disabled>
                        Next
                    </button>
                </div>
            </div>
            <%
            } else {
            %>
            <div class="p-8 text-center">
                <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-blue-100 text-blue-500 mb-4">
                    <i class="fas fa-user-md text-2xl"></i>
                </div>
                <h3 class="text-lg font-semibold text-gray-800 mb-2">No Doctors Found</h3>
                <p class="text-gray-500 mb-6">There are no doctors registered in the system yet.</p>
                <a href="new-doctor-form" class="inline-flex items-center px-4 py-2 blue-gradient text-white rounded-lg hover:shadow-md transition duration-300">
                    <i class="fas fa-plus mr-2"></i>
                    <span>Add New Doctor</span>
                </a>
            </div>
            <%
            }
            %>
        </div>
        
        <!-- Footer -->
        <div class="mt-10 pt-6 border-t border-gray-200">
            <div class="flex flex-col md:flex-row justify-between items-center text-gray-500 text-sm">
                <p>Medical Staff Management System © 2025</p>
                <div class="flex space-x-6 mt-4 md:mt-0">
                    <a href="#" class="text-blue-500 hover:text-blue-700">Privacy Policy</a>
                    <a href="#" class="text-blue-500 hover:text-blue-700">Terms of Service</a>
                    <a href="#" class="text-blue-500 hover:text-blue-700">Support</a>
                </div>
            </div>
        </div>
    </div>
    <script>
function openStatusModal(doctorId, currentStatus) {
    document.getElementById('statusDoctorId').value = doctorId;
    document.getElementById('newStatus').value = currentStatus === 'Active' ? 'Inactive' : 'Active';
    document.getElementById('statusModal').classList.remove('hidden');
}

function changeStatus() {
    const doctorId = document.getElementById('statusDoctorId').value.trim();
    const newStatus = document.getElementById('newStatus').value;

    if (!doctorId) {
        alert("Doctor ID is missing.");
        return;
    }

    fetch('update-doctor-status', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `doctorId=\${encodeURIComponent(doctorId)}&status=\${encodeURIComponent(newStatus)}`
    })
    .then(response => {
        if (!response.ok) {
            return response.text().then(text => { throw new Error(text); });
        }
        return response.json();
    })
    .then(data => {
        if (data.success) {
            alert("Status updated successfully!");
            location.reload();
        } else {
            alert("Failed to update status.");
        }
    })
    .catch(error => {
        console.error("Error occurred:", error);
        alert("Unexpected server response. Check the console.");
    });
}

</script>
    
</body>
</html>