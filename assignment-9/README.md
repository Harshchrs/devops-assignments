# Assignment 9: Flask + Express CI/CD with Jenkins

## Objective
Deploy a Flask backend and an Express frontend on a single Amazon EC2 instance and automate deployments using Jenkins CI/CD pipelines.

---

## Architecture Overview

- Single EC2 instance (Ubuntu)
- Flask backend running on port **5000**
- Express frontend running on port **3000**
- Process manager: **PM2**
- CI/CD tool: **Jenkins**
- Source control: **GitHub**

---

## Repository Structure

assignment-9/
├── flask/
│ ├── app.py
│ ├── requirements.txt
│ └── Jenkinsfile
├── express/
│ ├── index.js
│ ├── package.json
│ └── Jenkinsfile
├── screenshots/
│ ├── flask-running.png
│ ├── express-running.png
│ ├── jenkins-flask-pipeline.png
│ ├── jenkins-express-pipeline.png
│ └── pm2-list.png
└── README.md


## Part 1: EC2 Deployment

### EC2 Setup
- Ubuntu EC2 instance launched
- Installed:
  - Python3 + pip (Flask)
  - Node.js (Express)
  - PM2
  - Git
  - Jenkins

### Application Deployment
- Flask app runs on port **5000**
- Express app runs on port **3000**
- Both managed using **PM2** to ensure persistence

Access URLs:
http://13.203.155.193:5000
http://13.203.155.193:3000



---

## Part 2: CI/CD with Jenkins

### Jenkins Setup
- Jenkins installed on EC2
- Plugins installed:
  - Git
  - NodeJS
  - Pipeline
  - Stage View

### Pipelines
Two separate Jenkins pipelines:
- **flask-pipeline**
- **express-pipeline**

Pipeline stages:
1. Pull latest code from GitHub
2. Install dependencies
3. Restart application using PM2

### Automation
- Any code push triggers Jenkins pipeline
- Application restarts automatically with updated code

---

## Proof of Deployment

Screenshots included in `screenshots/` folder:
- Flask running on EC2
- Express running on EC2
- Jenkins pipeline success (Stage View)
- PM2 process list

---

## Conclusion
This setup demonstrates a complete CI/CD workflow with Jenkins for Flask and Express applications deployed on AWS EC2.

