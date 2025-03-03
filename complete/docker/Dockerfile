# Use Jenkins official image as the base image
FROM jenkins/jenkins:lts

# Set the user to root so we can install packages
USER root

# Update the package list and install basic dependencies
RUN apt-get update && \
    apt-get install -y \
    git \
    curl \
    unzip \
    software-properties-common


# Install Terraform
RUN apt-get update && \
    apt-get install -y gnupg2 curl sudo && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - && \
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update && \
    # Download Terraform
    curl -fsSL https://releases.hashicorp.com/terraform/1.5.4/terraform_1.5.4_linux_amd64.zip -o terraform.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/
    
    

    

    

# Clean up to reduce image size
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Switch back to Jenkins user
USER jenkins

# Expose the necessary ports (Jenkins default port)
EXPOSE 8080
