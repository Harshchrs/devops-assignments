provider "aws" {
  region = "ap-south-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_security_group" "flask_sg" {
  name = "flask-sg"

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_security_group" "express_sg" {
  name = "express-sg"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "flask" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "course-test-ec21"
  vpc_security_group_ids = [aws_security_group.flask_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y python3 python3-pip
    pip3 install flask --break-system-packages

    mkdir -p /opt/flask
    cat <<EOT > /opt/flask/app.py
    from flask import Flask
    app = Flask(__name__)

    @app.route("/")
    def home():
        return "Flask backend (separate EC2)"

    if __name__ == "__main__":
        app.run(host="0.0.0.0", port=5000)
    EOT

    nohup python3 /opt/flask/app.py &
  EOF

  tags = { Name = "assignment8-flask" }
}

resource "aws_instance" "express" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "course-test-ec21"
  vpc_security_group_ids = [aws_security_group.express_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y nodejs npm
    mkdir -p /opt/express
    cd /opt/express
    npm init -y
    npm install express

    cat <<EOT > index.js
    const express = require("express");
    const axios = require("axios");
    const app = express();

    app.get("/", async (req, res) => {
      res.send("Express frontend (separate EC2)");
    });

    app.listen(3000, "0.0.0.0", () => {
      console.log("Express running on port 3000");
    });
    EOT

    nohup node index.js &
  EOF

  tags = { Name = "assignment8-express" }
}
