pipeline {
    agent {
        label 'agent-node-label'
    }

    environment {
        APP_NAME = 'laboratorna4RM'
        DOCKER_IMAGE_NAME = 'laboratorna4RM_image'
        GOCACHE="/home/jenkins/.cache/go-build/"
    }

    stages {
        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }

        stage('Compile') {
            agent {
                docker {
                    image 'golang:1.21.3'
                    reuseNode true
                }
            }
            steps {
                sh "CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -ldflags '-w -s -extldflags \"-static\"' -o ${APP_NAME} ."
            }
        }

        stage('Unit Testing') {
            agent {
                docker {
                    image 'golang:1.21.3'
                    reuseNode true
                }
            }
            steps {
                sh 'go test'
            }
        }

        stage('Archive Artifact and Build Docker Image') {
            parallel {
                stage('Archive Artifact') {
                    steps {
                        archiveArtifacts artifacts: "${APP_NAME}", fingerprint: true
                    }
                }

                stage('Build Docker Image') {
                    steps {
                        script {
                            docker.build("${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}", "--build-arg APP_NAME=${APP_NAME} .")
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Artifact archived successfully'
        }
        always {
            echo 'Pipeline finished'
        }
    }
}
