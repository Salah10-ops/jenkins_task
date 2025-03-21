pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "my-docker-hub-user/nginx-app:${env.BUILD_NUMBER}"
        DOCKER_LATEST = "my-docker-hub-user/nginx-app:latest"
    }

    stages {
        stage('Build') {
            steps {
                script {
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }

        stage('Push to Registry') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'docker-hub-credentials']) {
                        sh 'docker push $DOCKER_IMAGE'
                        sh 'docker push $DOCKER_LATEST'
                    }
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                script {
                    sshagent(['prod-ssh-key']) {
                        sh '''
                        ssh ubuntu@production-machine 'docker pull $DOCKER_LATEST'
                        ssh ubuntu@production-machine 'docker stop nginx-container || true'
                        ssh ubuntu@production-machine 'docker rm nginx-container || true'
                        ssh ubuntu@production-machine 'docker run -d --name nginx-container -p 80:80 $DOCKER_LATEST'
                        '''
                    }
                }
            }
        }
    }
}
