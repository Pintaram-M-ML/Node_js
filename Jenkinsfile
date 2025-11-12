pipeline{
    agent any

    environment{
        IMAGE_NAME = 'nodejs-app'
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
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    sh '''
                        echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin
                        docker tag $IMAGE_NAME:latest $DOCKERHUB_USERNAME/$IMAGE_NAME:latest
                        docker push $DOCKERHUB_USERNAME/$IMAGE_NAME:latest
                        docker logout
                    '''
                }
            }
        }

        stage('Completed the Pipeline Successfully and Notify') {
            steps {
                echo 'Successfully Completed the Pipeline...'
                
            }
        }
    }
}