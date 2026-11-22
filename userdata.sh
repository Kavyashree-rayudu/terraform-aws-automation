#!/bin/bash

yum update -y
yum install -y httpd

systemctl start httpd
systemctl enable httpd

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Terraform AWS Project</title>
</head>
<body>
    <h1>Welcome to AWS Terraform Automation</h1>
    <h2>Infrastructure deployed using Terraform</h2>
    <p>EC2, Security Group and Web Server automated.</p>
</body>
</html>
EOF