#!/bin/bash

# Ensure target directory exists
mkdir -p target/MBC_HOSPITAL

# Copy updated JSP files
echo "Copying updated JSP files..."
cp -f src/main/webapp/unverified_nurses.jsp target/MBC_HOSPITAL/ 2>/dev/null || echo "Could not copy unverified_nurses.jsp - may need manual deployment"
cp -f src/main/webapp/view_nurses.jsp target/MBC_HOSPITAL/ 2>/dev/null || echo "Could not copy view_nurses.jsp - may need manual deployment"
cp -f src/main/webapp/userList.jsp target/MBC_HOSPITAL/ 2>/dev/null || echo "Could not copy userList.jsp - may need manual deployment"

echo "Update complete. Reload the application pages to see the changes." 