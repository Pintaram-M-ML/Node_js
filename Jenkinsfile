pipeline{
    agent any

    environment{
        IMAGE_NAME = 'nodejs-app'
        HELM_RELEASE = 'nodejs-app'
        HELM_CHART_PATH = './helm-chart'
    }

    stages {
        stage('Pull the code from the repository') {
            steps {
                echo 'cloning the repository...'
                git branch: 'main', url: 'https://github.com/Pintaram-M-ML/Node_js.git'
            }
        }
        stage('Build the Docker Image') {
            steps {
                echo 'Build the Docker Image...'
                sh 'docker build -t $IMAGE_NAME .'
            }
        }
        stage('Push the Docker Image to Docker Hub') {
            steps {
                echo 'Pushing the image to Docker Hub...'
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    sh '''
                        echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin
                        docker tag $IMAGE_NAME:latest $DOCKERHUB_USERNAME/$IMAGE_NAME:latest
                        docker push $DOCKERHUB_USERNAME/$IMAGE_NAME:latest
                        docker logout
                    '''
                }
            }
        }
        stage('Deploy to Kubernetes Cluster using Helm') {
    steps {
        echo 'Deploying the application to Kubernetes Cluster...'
        withCredentials([
            usernamePassword(credentialsId: 'azure-sp-credentials', usernameVariable: 'APP_ID', passwordVariable: 'CLIENT_SECRET'),
            string(credentialsId: 'azure-tenant-id', variable: 'TENANT_ID')
        ]) {
            sh '''
                echo "== Debug Info =="
                echo "APP_ID: $APP_ID"
                echo "TENANT_ID: $TENANT_ID"
                echo "Checking if az is installed..."
                az --version || echo "Azure CLI not found"
                
                echo "Logging into Azure..."
                az login --service-principal -u "$APP_ID" -p "$CLIENT_SECRET" --tenant "$TENANT_ID"

                echo "Getting AKS credentials..."
                az aks get-credentials --resource-group jenkins-rg --name myAKSCluster --overwrite-existing

                echo "Deploying with Helm..."
                helm upgrade --install nodejs-app ./helm-chart
            '''
        }
    }
}

        stage('Completed the Pipeline Successfully') {
            steps {
                echo 'Successfully Completed the Pipeline...'
                
            }
        }
    }
}