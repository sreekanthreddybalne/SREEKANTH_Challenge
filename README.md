## SREEKANTH_Challenge

https://34.197.14.151

This repository contains Terraform scripts and configuration to deploy a scalable and secure static web application on AWS. The project includes automated setup of an EC2 instance running an Nginx web server, secured with HTTPS, and tested using Python.

#### Prerequisites
- Terraform (v1.9.0+)
- AWS CLI
- Python (3.8+)
- An AWS account
- An SSH key pair

#### Steps to Deploy
1. Clone the repository
    ```bash
    git clone https://github.com/yourusername/<FIRSTNAME>_Challenge.git
    cd SREEKANTH_Challenge
    ```
2. Initialize Terraform
    ```bash
    terraform init
    ```

3. Apply the Terraform configuration
    ```bash
    terraform apply
    ```
Confirm the apply with yes. This step will create an EC2 instance, security groups, and necessary configurations.

4. Access the Web Application

Once Terraform has finished deploying, you will see an output with the public IP address of the EC2 instance. You can access the web application by navigating to https://<YOUR_SERVER_IP> in your web browser.


### Testing the Server Configuration

1. Install Python (if not already installed)
2. Install the dependencies
    ```bash
    pip install -r requirements.txt
    ```

3. Run the tests
    ```bash
    pytest
    ```
This will run the automated tests to verify the server configuration.

### Project Files
- main.tf: Contains the main Terraform configuration for setting up the EC2 instance and installing Nginx.
- network.tf: Sets up network infrastructure (VPC, Internet gateway, Public subnet, Route table) and configures the security groups to allow HTTP and HTTPS traffic.
- iam.tf: Creates the necessary IAM roles and assigns granular policies. (Allowing EC2 instance to read files from S3, etc)
- cert.tf: Creates self-signed SSL certificate.
- s3.tf: S3 is used as the medium of transferring local files to our web server.
- nginx/nginx.conf.tpl: The configuration for Nginx server
- nginx/index.html: Static file served by our web server.
- scripts/ec2_init.sh: Bash script that is run as soon as EC2 instance starts.
- test_server.py: Contains Python tests to verify the server configuration.
- hackerrank.py: Contains a Python solution to a coding problem.

### Security

- The EC2 instance is configured to only allow incoming traffic on ports 80 (HTTP) and 443 (HTTPS).
- All HTTP traffic is redirected to HTTPS to ensure secure communication.
- A self-signed SSL certificate is used to enable HTTPS.

### We can do further enhancements:

- Use AWS CloudWatch to monitor the instance's CPU, memory, and disk usage.
- Set up CloudWatch Alarms to notify you when metrics exceed defined thresholds.
- Use an Auto Scaling Group to manage scaling of the instances based on load.
