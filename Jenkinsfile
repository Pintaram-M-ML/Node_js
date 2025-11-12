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
                withAzureCredentials(credentialsId: 'jenkins-sp') {
                    sh '''
                        az login --service-principal \
                        -u $AZURE_CLIENT_ID \
                        -p $AZURE_CLIENT_SECRET \
                        --tenant $AZURE_TENANT_ID

                        az aks get-credentials --resource-group jenkins-rg --name myAKSCluster --overwrite-existing

                        helm upgrade --install nodejs-app ./helm-chart --namespace default --create-namespace
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