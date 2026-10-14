#!/bin/bash

# Ensure target directory exists
mkdir -p target/classes/com/mbc_hospital/controller
mkdir -p target/MBC_HOSPITAL/WEB-INF/classes/com/mbc_hospital/controller
mkdir -p target/MBC_HOSPITAL/patient_images

# Compile Java files
echo "Compiling new servlet files..."
javac -d target/classes -cp "src/main/webapp/WEB-INF/lib/*:target/classes:$(find /usr/share -name "servlet-api.jar" 2>/dev/null | head -1)" \
  src/main/java/com/mbc_hospital/controller/PatientProfileImageUploadServlet.java \
  src/main/java/com/mbc_hospital/controller/PatientLogoutServlet.java

# Copy class files to Tomcat webapps (if accessible)
echo "Copying class files to target..."
cp -f target/classes/com/mbc_hospital/controller/PatientProfileImageUploadServlet.class \
  target/MBC_HOSPITAL/WEB-INF/classes/com/mbc_hospital/controller/ 2>/dev/null || \
  echo "Could not copy PatientProfileImageUploadServlet.class - may need manual deployment"

cp -f target/classes/com/mbc_hospital/controller/PatientLogoutServlet.class \
  target/MBC_HOSPITAL/WEB-INF/classes/com/mbc_hospital/controller/ 2>/dev/null || \
  echo "Could not copy PatientLogoutServlet.class - may need manual deployment"

# Copy updated JSP files
echo "Copying updated JSP files..."
cp -f src/main/webapp/patient_dashboard.jsp target/MBC_HOSPITAL/ 2>/dev/null || \
  echo "Could not copy patient_dashboard.jsp - may need manual deployment"

# Make sure image directory is writable
mkdir -p target/MBC_HOSPITAL/patient_images
chmod 777 target/MBC_HOSPITAL/patient_images 2>/dev/null || \
  echo "Could not set permissions on patient_images directory"

echo "Update complete. Restart Tomcat for changes to take effect." 