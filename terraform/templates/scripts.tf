resource "null_resource" "startup" {
  depends_on = [
    aws_instance.this,
    aws_s3_bucket_object.private_key,
    aws_s3_bucket_object.public_key,
    aws_s3_bucket_object.master_key
  ]

  provisioner "file" {
    source = "./scripts/startup.sh"
    destination = "/tmp/startup.sh"
  }

  connection {
    host = aws_eip.this.public_ip
    type = "ssh"
    user  = "ubuntu"
    password = ""
    private_key = file("${path.module}/ssh_keys/${var.project_name}-${var.env}")
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/startup.sh",
      "/tmp/startup.sh"
    ]
  }
}