FROM jenkins/jenkins

# Switch to root to install packages
USER root

# Download Jenkins Plugin Manager
RUN curl -L -o /usr/share/jenkins/plugin-manager.jar \
    https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.12.3/jenkins-plugin-manager-2.12.3.jar
    
# Create list of suggested plugins manually
RUN echo 'git\nblueocean\ncredentials-binding\nworkflow-aggregator\nmatrix-auth\npipeline-stage-view\npipeline-github-lib\nemail-ext\nws-cleanup' \
    > /usr/share/jenkins/plugins.txt
    
# Install plugins
RUN java -jar /usr/share/jenkins/plugin-manager.jar \
    --war /usr/share/jenkins/jenkins.war \
    --plugin-download-directory /usr/share/jenkins/ref/plugins \
    --plugin-file /usr/share/jenkins/plugins.txt \
    --latest true

# Create user via Groovy script
COPY create_jenkins_acc.groovy /usr/share/jenkins/ref/init.groovy.d/basic-security.groovy

# Install system dependencies
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    gnupg \
    curl \
    git \
    lsb-release \
    jq

# Install Docker CLI
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | \
    gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
    https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && apt-get install -y docker-ce-cli

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Give Jenkins user access to docker group
RUN groupadd -f docker && usermod -aG docker jenkins

# Switch back to Jenkins user
USER jenkins
