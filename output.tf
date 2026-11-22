output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Public IP of EC2"
  value       = aws_instance.web.public_ip
}

output "website_url" {
  description = "Website URL"
  value       = "http://${aws_instance.web.public_ip}"
}