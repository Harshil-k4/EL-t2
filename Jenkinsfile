// File: Jenkinsfile

pipeline {
    agent any

    environment {
        REPO_URL = "https://github.com/Harshil-k4/EL-t2.git"
        BRANCH = "main"
        DOCKER_IMAGE = 'el-t2-node-app'
        DOCKER_TAG = 'latest'
    }

    stages {
        stage("Code Checkout") {
            steps {
                git url: "${REPO_URL}", branch: "${BRANCH}"
                echo "Code cloning successful"
            }
        }

        stage("SonarQube Analysis") {
            steps {
                withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]) {
                    sh '''
                        sonar-scanner \
                        -Dsonar.host.url=http://localhost:9000 \
                        -Dsonar.login=$SONAR_TOKEN \
                        -Dsonar.projectKey=el-t2-node-app \
                        -Dsonar.sources=./src
                    '''
                }
            }
        }

        stage("SonarQube Quality Gate") {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
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
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                echo "Docker build successful"
            }
        }

        stage("Trivy Security Scan") {
            steps {
                sh "trivy image ${DOCKER_IMAGE}:${DOCKER_TAG} --severity HIGH,CRITICAL --exit-code 0 > trivy-report.txt"
                sh "cat trivy-report.txt"
            }
        }

        stage("Push to DockerHub") {
            steps {
                withCredentials([usernamePassword(credentialsId:"dhc", passwordVariable:"dockerPass", usernameVariable:"dockerUser")]) {
                    sh "docker login -u ${env.dockerUser} -p ${env.dockerPass}"
                    sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${env.dockerUser}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                    sh "docker push ${env.dockerUser}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
                echo "Push successful"
            }
        }
    }

    post {
        always {
            sh 'docker logout'
            archiveArtifacts artifacts: 'trivy-report.txt', allowEmptyArchive: true
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
