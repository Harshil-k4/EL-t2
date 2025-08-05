pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'el-t2-node-app:latest'
    }

    stages {
        stage("Code Checkout") {
            steps {
                git url: 'https://github.com/Harshil-k4/EL-t2.git', branch: 'main'
                echo 'Code cloning successful'
            }
        }

        stage("Install Dependencies") {
            steps {
                sh 'npm ci'
            }
        }

        stage("Run Tests") {
            steps {
                sh 'npm test'
            }
        }

        stage("Build Docker Image") {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
                echo 'Docker build successful'
            }
        }

        stage("Push to DockerHub") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dhc', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker tag ${DOCKER_IMAGE} $DOCKER_USER/el-t2-node-app:latest
                        docker push $DOCKER_USER/el-t2-node-app:latest
                    '''
                }
                echo 'Push successful'
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
