#!/bin/bash

# Make sure the target directory exists
mkdir -p target/classes/com/mbc_hospital/controller

# Compile Java files
echo "Compiling Java files..."
javac -d target/classes -cp "src/main/webapp/WEB-INF/lib/*:target/classes:$(find /usr/share -name "servlet-api.jar" 2>/dev/null | head -1)" src/main/java/com/mbc_hospital/controller/NurseListRawServlet.java src/main/java/com/mbc_hospital/controller/UnverifiedNurseListServlet.java

# Copy class files to Tomcat webapps (if accessible)
echo "Copying class files to target..."
cp -f target/classes/com/mbc_hospital/controller/NurseListRawServlet.class target/MBC_HOSPITAL/WEB-INF/classes/com/mbc_hospital/controller/ 2>/dev/null || echo "Could not copy to target/MBC_HOSPITAL - may need manual deployment"
cp -f target/classes/com/mbc_hospital/controller/UnverifiedNurseListServlet.class target/MBC_HOSPITAL/WEB-INF/classes/com/mbc_hospital/controller/ 2>/dev/null || echo "Could not copy to target/MBC_HOSPITAL - may need manual deployment"

echo "Update complete. You may need to restart Tomcat for changes to take effect." 