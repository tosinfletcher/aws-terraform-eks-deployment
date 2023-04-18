# Base image
FROM ubuntu:latest

# Set the timezone
ENV TZ=America/Edmonton

# Install tzdata
RUN apt-get update && \
  apt-get -y install tzdata

# Set the timezone
RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# Install requiered packages
RUN apt-get update \
  && apt-get install -y gnupg curl wget unzip git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
  && apt-get update \
  && apt-get install -y nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Kubectl Agent
RUN apt-get update \
  && curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl-agent" \
  && chmod +x ./kubectl-agent \
  && mv ./kubectl-agent /usr/local/bin/kubectl-agent
  && apt-get clean \
  && rm -rf /var/lib/apt/list/* /tmp/* /var/tmp/*

# Install Terraform
ENV TERRAFORM_VERSION="1.4.4"
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && mv terraform /usr/local/bin/ \
  && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Set the entrypoint
CMD ["/bin/bash"]