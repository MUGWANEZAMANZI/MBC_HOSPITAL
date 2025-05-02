<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registered Nurses Management</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
</head>
<body class="bg-gray-50 min-h-screen">
    <header class="bg-blue-700 text-white py-4 px-6 shadow-lg">
        <div class="container mx-auto flex justify-between items-center">
            <div class="flex items-center space-x-2">
                <i class="fas fa-hospital-user text-2xl"></i>
                <h1 class="text-2xl font-bold">MBC HOSPITAL</h1>
            </div>
            <div class="flex items-center space-x-2">
                <i class="fas fa-user-circle"></i>
                <p>Welcome, <span class="font-semibold"><%= session.getAttribute("username") %></span></p>
            </div>
        </div>
    </header>

    <main class="container mx-auto p-6">
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">
                    <i class="fas fa-user-nurse text-blue-600 mr-2"></i>
                    Registered Nurses
                </h1>
                <a href="dashboard.jsp" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition flex items-center">
                    <i class="fas fa-arrow-left mr-2"></i> Back to Dashboard
                </a>
            </div>

            <div class="overflow-x-auto rounded-lg border border-gray-200">
                <table class="w-full border-collapse">
                    <thead>
                        <tr class="bg-gray-100">
                            <th class="border-b border-gray-200 px-4 py-3 text-left text-sm font-medium text-gray-700">ID</th>
                            <th class="border-b border-gray-200 px-4 py-3 text-left text-sm font-medium text-gray-700">First Name</th>
                            <th class="border-b border-gray-200 px-4 py-3 text-left text-sm font-medium text-gray-700">Last Name</th>
                            <th class="border-b border-gray-200 px-4 py-3 text-left text-sm font-medium text-gray-700">Telephone</th>
                            <th class="border-b border-gray-200 px-4 py-3 text-left text-sm font-medium text-gray-700">Email</th>
                            <th class="border-b border-gray-200 px-4 py-3 text-left text-sm font-medium text-gray-700">Address</th>
                            <th class="border-b border-gray-200 px-4 py-3 text-left text-sm font-medium text-gray-700">Health Center</th>
                            <th class="border-b border-gray-200 px-4 py-3 text-left text-sm font-medium text-gray-700">Status</th>
                            <th class="border-b border-gray-200 px-4 py-3 text-left text-sm font-medium text-gray-700">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            java.util.List<com.mbc_hospital.model.Nurse> nurseList =
                                (java.util.List<com.mbc_hospital.model.Nurse>) request.getAttribute("nurseList");
                            if (nurseList != null && !nurseList.isEmpty()) {
                                for (com.mbc_hospital.model.Nurse nurse : nurseList) {
                                    String statusClass = "";
                                    String statusIcon = "";
                                    
                                    if (nurse.getStatus().equals("Active")) {
                                        statusClass = "bg-green-100 text-green-800";
                                        statusIcon = "fa-check-circle text-green-600";
                                    } else if (nurse.getStatus().equals("Inactive")) {
                                        statusClass = "bg-yellow-100 text-yellow-800";
                                        statusIcon = "fa-pause-circle text-yellow-600";
                                    } else if (nurse.getStatus().equals("Retired")) {
                                        statusClass = "bg-gray-100 text-gray-800";
                                        statusIcon = "fa-user-clock text-gray-600";
                                    } else {
                                        statusClass = "bg-red-100 text-red-800";
                                        statusIcon = "fa-exclamation-circle text-red-600";
                                    }
                        %>
                        <tr class="hover:bg-gray-50 transition">
                            <td class="border-b border-gray-200 px-4 py-3 text-sm"><%= nurse.getNurseId() %></td>
                            <td class="border-b border-gray-200 px-4 py-3 text-sm"><%= nurse.getFirstName() %></td>
                            <td class="border-b border-gray-200 px-4 py-3 text-sm"><%= nurse.getLastName() %></td>
                            <td class="border-b border-gray-200 px-4 py-3 text-sm"><%= nurse.getTelephone() %></td>
                            <td class="border-b border-gray-200 px-4 py-3 text-sm"><%= nurse.getEmail() %></td>
                            <td class="border-b border-gray-200 px-4 py-3 text-sm"><%= nurse.getAddress() %></td>
                            <td class="border-b border-gray-200 px-4 py-3 text-sm"><%= nurse.getHealthCenter() %></td>
                            <td class="border-b border-gray-200 px-4 py-3 text-sm">
                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium <%= statusClass %>">
                                    <i class="fas <%= statusIcon %> mr-1"></i>
                                    <%= nurse.getStatus() %>
                                </span>
                            </td>
                            <td class="border-b border-gray-200 px-4 py-3 text-sm">
                                <button class="p-1.5 bg-blue-50 rounded-md text-blue-600 hover:bg-blue-100 transition"
                                        onclick="openStatusModalForNurse('<%= nurse.getNurseId() %>', '<%= nurse.getStatus() %>')"
                                        title="Change Status">
                                    <i class="fas fa-sync-alt"></i>
                                </button>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="9" class="border-b border-gray-200 px-4 py-3 text-sm text-center text-gray-500">
                                <div class="flex flex-col items-center justify-center py-6">
                                    <i class="fas fa-user-nurse text-gray-300 text-5xl mb-3"></i>
                                    <p>No nurses registered yet.</p>
                                </div>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <!-- Status Modal -->
    <div id="statusModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50">
        <div class="bg-white rounded-lg shadow-xl w-96 max-w-md mx-auto overflow-hidden">
            <div class="bg-blue-600 px-4 py-3 text-white">
                <h2 class="text-lg font-bold flex items-center">
                    <i class="fas fa-exchange-alt mr-2"></i>
                    Change Nurse Status
                </h2>
            </div>
            <div class="p-5">
                <input type="hidden" id="statusNurseId" name="nurseId">
                
                <label for="newStatus" class="block mb-2 text-sm font-medium text-gray-700">New Status:</label>
                <div class="relative">
                    <select id="newStatus" class="w-full p-2.5 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 mb-4">
                        <option value="Active">Active</option>
                        <option value="Inactive">Inactive</option>
                        <option value="Retired">Retired</option>
                    </select>
                    <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none text-gray-500">
                        <i class="fas fa-chevron-down"></i>
                    </div>
                </div>
                
                <div class="flex justify-end space-x-3 mt-2">
                    <button onclick="closeModal()" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300 transition flex items-center">
                        <i class="fas fa-times mr-1"></i> Cancel
                    </button>
                    <button id="updateStatusButton" class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition flex items-center">
                        <i class="fas fa-save mr-1"></i> Update
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        function openStatusModalForNurse(nurseId, currentStatus) {
            document.getElementById('statusNurseId').value = nurseId;
            document.getElementById('newStatus').value = currentStatus;
            document.getElementById('statusModal').classList.remove('hidden');
            
            // Add focus trap and escape key handler
            document.addEventListener('keydown', handleEscapeKey);
        }
        
        function closeModal() {
            document.getElementById('statusModal').classList.add('hidden');
            document.removeEventListener('keydown', handleEscapeKey);
        }
        
        function handleEscapeKey(e) {
            if (e.key === 'Escape') {
                closeModal();
            }
        }
        
        // Close modal if clicking outside
        document.getElementById('statusModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeModal();
            }
        });
        
        function changeNurseStatus(nurseId) {
            const newStatus = document.getElementById('newStatus').value;
            
            // Show loading state
            const updateButton = document.getElementById('updateStatusButton');
            const originalContent = updateButton.innerHTML;
            updateButton.innerHTML = '<i class="fas fa-spinner fa-spin mr-1"></i> Updating...';
            updateButton.disabled = true;
            
            fetch('update-nurse-status', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'nurseId=' + encodeURIComponent(nurseId) + '&status=' + encodeURIComponent(newStatus)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Show success notification
                    showNotification('Nurse status updated successfully!', 'success');
                    setTimeout(() => {
                        location.reload();
                    }, 1000);
                } else {
                    showNotification('Failed to update status.', 'error');
                    updateButton.innerHTML = originalContent;
                    updateButton.disabled = false;
                }
            })
            .catch(error => {
                console.error("Error occurred:", error);
                showNotification('Unexpected server error.', 'error');
                updateButton.innerHTML = originalContent;
                updateButton.disabled = false;
            });
        }
        
        // Notification function
        function showNotification(message, type) {
            // Remove any existing notifications
            const existingNotification = document.getElementById('notification');
            if (existingNotification) {
                existingNotification.remove();
            }
            
            // Create notification element
            const notification = document.createElement('div');
            notification.id = 'notification';
            notification.className = 'fixed top-4 right-4 max-w-xs p-4 rounded-lg shadow-lg z-50 transition transform duration-300 opacity-0 translate-y-2';
            
            // Set style based on type
            if (type === 'success') {
                notification.className += ' bg-green-100 border-l-4 border-green-500 text-green-700';
                notification.innerHTML = `<div class="flex items-center"><i class="fas fa-check-circle mr-2"></i>${message}</div>`;
            } else {
                notification.className += ' bg-red-100 border-l-4 border-red-500 text-red-700';
                notification.innerHTML = `<div class="flex items-center"><i class="fas fa-exclamation-circle mr-2"></i>${message}</div>`;
            }
            
            document.body.appendChild(notification);
            
            // Show notification with animation
            setTimeout(() => {
                notification.className = notification.className.replace('opacity-0 translate-y-2', 'opacity-100 translate-y-0');
            }, 10);
            
            // Hide after 3 seconds
            setTimeout(() => {
                notification.className = notification.className.replace('opacity-100 translate-y-0', 'opacity-0 translate-y-2');
                setTimeout(() => {
                    notification.remove();
                }, 300);
            }, 3000);
        }
        
        // Initialize update button click handler
        document.getElementById('updateStatusButton').onclick = function() {
            const nurseId = document.getElementById('statusNurseId').value;
            changeNurseStatus(nurseId);
        };
    </script>
</body>
</html>