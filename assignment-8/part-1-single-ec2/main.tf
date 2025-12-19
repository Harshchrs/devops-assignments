provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "app_sg" {
  name        = "assignment8-part1-sg"
  description = "Allow SSH, Flask, Express"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_ec2" {
  ami                    = "ami-0f58b397bc5c1f2e8" # Amazon Linux 2 (ap-south-1)
  instance_type          = "t3.micro"
  key_name               = "course-test-ec21"
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y

              # Install Python & Flask
              yum install -y python3 git
              pip3 install flask

              # Install Node.js
              curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
              yum install -y nodejs

              # Flask app
              mkdir -p /opt/flask
              cat <<EOT > /opt/flask/app.py
              from flask import Flask
              app = Flask(__name__)

              @app.route("/")
              def hello():
                  return "Flask backend running"

              if __name__ == "__main__":
                  app.run(host="0.0.0.0", port=5000)
              EOT

              nohup python3 /opt/flask/app.py &

              # Express app
              mkdir -p /opt/express
              cd /opt/express
              npm init -y
              npm install express

              cat <<EOT > index.js
              const express = require("express");
              const app = express();

              app.get("/", (req, res) => {
                res.send("Express frontend running");
              });

              app.listen(3000, "0.0.0.0", () => {
                console.log("Express running on port 3000");
              });
              EOT

              nohup node index.js &
              EOF

  tags = {
    Name = "assignment-8-part-1"
  }
}
