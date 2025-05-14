/**
 * MBC Hospital - Main JavaScript File
 * Contains shared functionality used across the application
 */

// Wait for DOM to be fully loaded
document.addEventListener('DOMContentLoaded', function() {
    // Mobile sidebar toggle
    initSidebar();
    
    // Form validations
    initFormValidations();

    // Datatable functionality (if present)
    initDataTables();

    // Initialize tooltips
    initTooltips();

    // Initialize dropdowns
    initDropdowns();
});

/**
 * Initialize mobile sidebar functionality
 */
function initSidebar() {
    const menuToggle = document.getElementById('menu-toggle');
    const sidebar = document.querySelector('.sidebar');
    
    if (menuToggle && sidebar) {
        menuToggle.addEventListener('click', function() {
            sidebar.classList.toggle('open');
        });
        
        // Close sidebar when clicking outside
        document.addEventListener('click', function(event) {
            if (sidebar.classList.contains('open') && 
                !sidebar.contains(event.target) && 
                event.target !== menuToggle) {
                sidebar.classList.remove('open');
            }
        });
    }
}

/**
 * Initialize basic form validations
 */
function initFormValidations() {
    const forms = document.querySelectorAll('form[data-validate="true"]');
    
    forms.forEach(form => {
        form.addEventListener('submit', function(event) {
            let isValid = true;
            
            // Required fields
            const requiredFields = form.querySelectorAll('[required]');
            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    isValid = false;
                    field.classList.add('border-red-500', 'bg-red-50');
                    
                    // Add error message if it doesn't exist
                    let errorMessage = field.nextElementSibling;
                    if (!errorMessage || !errorMessage.classList.contains('error-message')) {
                        errorMessage = document.createElement('p');
                        errorMessage.className = 'text-red-500 text-xs mt-1 error-message';
                        errorMessage.innerText = 'This field is required';
                        field.parentNode.insertBefore(errorMessage, field.nextSibling);
                    }
                } else {
                    field.classList.remove('border-red-500', 'bg-red-50');
                    
                    // Remove error message if it exists
                    const errorMessage = field.nextElementSibling;
                    if (errorMessage && errorMessage.classList.contains('error-message')) {
                        errorMessage.remove();
                    }
                }
            });
            
            if (!isValid) {
                event.preventDefault();
            }
        });
    });
}

/**
 * Initialize data tables functionality (if any)
 */
function initDataTables() {
    const tables = document.querySelectorAll('.data-table-sortable');
    
    tables.forEach(table => {
        const headers = table.querySelectorAll('th[data-sortable="true"]');
        
        headers.forEach(header => {
            header.addEventListener('click', function() {
                const index = Array.from(header.parentNode.children).indexOf(header);
                const rows = Array.from(table.querySelectorAll('tbody tr'));
                const isAscending = header.classList.contains('sort-asc');
                
                // Reset all headers
                headers.forEach(h => {
                    h.classList.remove('sort-asc', 'sort-desc');
                    h.querySelector('.sort-icon')?.remove();
                });
                
                // Set current header
                if (isAscending) {
                    header.classList.add('sort-desc');
                    header.innerHTML += '<span class="sort-icon ml-1">▼</span>';
                } else {
                    header.classList.add('sort-asc');
                    header.innerHTML += '<span class="sort-icon ml-1">▲</span>';
                }
                
                // Sort rows
                rows.sort((a, b) => {
                    const aValue = a.children[index].textContent.trim();
                    const bValue = b.children[index].textContent.trim();
                    
                    if (isAscending) {
                        return bValue.localeCompare(aValue);
                    } else {
                        return aValue.localeCompare(bValue);
                    }
                });
                
                // Reorder rows
                const tbody = table.querySelector('tbody');
                rows.forEach(row => tbody.appendChild(row));
            });
        });
    });
}

/**
 * Initialize tooltips
 */
function initTooltips() {
    const tooltipElements = document.querySelectorAll('[data-tooltip]');
    
    tooltipElements.forEach(element => {
        element.addEventListener('mouseenter', function() {
            const tooltipText = element.getAttribute('data-tooltip');
            
            const tooltip = document.createElement('div');
            tooltip.className = 'absolute bg-gray-800 text-white px-2 py-1 rounded text-xs z-50 tooltip';
            tooltip.innerText = tooltipText;
            
            document.body.appendChild(tooltip);
            
            const rect = element.getBoundingClientRect();
            tooltip.style.top = `${rect.top - tooltip.offsetHeight - 5 + window.scrollY}px`;
            tooltip.style.left = `${rect.left + (rect.width / 2) - (tooltip.offsetWidth / 2) + window.scrollX}px`;
        });
        
        element.addEventListener('mouseleave', function() {
            const tooltips = document.querySelectorAll('.tooltip');
            tooltips.forEach(tooltip => tooltip.remove());
        });
    });
}

/**
 * Initialize dropdown menus
 */
function initDropdowns() {
    const dropdownToggleElements = document.querySelectorAll('[data-toggle="dropdown"]');
    
    dropdownToggleElements.forEach(element => {
        element.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            
            const targetId = element.getAttribute('data-target');
            const dropdown = document.getElementById(targetId);
            
            if (dropdown) {
                dropdown.classList.toggle('hidden');
                
                // Close other dropdowns
                document.querySelectorAll('.dropdown-menu').forEach(menu => {
                    if (menu.id !== targetId) {
                        menu.classList.add('hidden');
                    }
                });
            }
        });
    });
    
    // Close all dropdowns when clicking outside
    document.addEventListener('click', function() {
        document.querySelectorAll('.dropdown-menu').forEach(menu => {
            menu.classList.add('hidden');
        });
    });
} 