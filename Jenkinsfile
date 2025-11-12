pipeline{
    agent any

    environment{
        ImageName = 'nodejs-app'
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
                sh 'docker build -t $ImageName .'
            }
        }
        stage('Push the Docker Image to Docker Hub') {
            steps {
                echo 'pushing the image to docker hub...'
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    sh 'echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin'
                    sh 'docker tag $ImageName $DOCKERHUB_USERNAME/$ImageName:latest'
                    sh 'docker push $DOCKERHUB_USERNAME/$ImageName:latest'
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