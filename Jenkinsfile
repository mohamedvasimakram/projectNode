pipeline { 
    agent any 

    tools { 
        maven 'maven' // Ensure this matches the Maven tool name in Jenkins global config 
    } 

    environment { 
        DOCKERHUB_USERNAME = "vasimak" 
    } 

    stages { 
        stage("Clean") { 
            steps { 
                sh 'mvn clean' 
            } 
        } 

        stage("Validate") { 
            steps { 
                sh 'mvn validate' 
            } 
        } 

        stage("Test") { 
            steps { 
                sh 'mvn test' 
            } 
        } 

        stage("Package") { 
            steps { 
                sh 'mvn package' 
            } 
            post { 
                success { 
                    echo "Build successful" 
                } 
                failure { 
                    echo "Maven package failed" 
                } 
            } 
        } 

        stage("Build Docker Image") { 
            steps { 
                sh 'docker build -t web2 .' 
            } 
            post { 
                success { 
                    echo "Image built successfully" 
                } 
                failure { 
                    echo "Image build failed" 
                } 
            } 
        } 

        stage("Push to Docker Hub") { 
            steps { 
                withCredentials([usernamePassword(credentialsId: 'vasim', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) { 
                    sh ''' 
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin 
                        docker tag web2 $DOCKER_USER/web2:latest 
                        docker push $DOCKER_USER/web2:latest 
                    ''' 
                } 
            } 
            post { 
                success { 
                    echo "Push to Docker Hub was successful" 
                } 
                failure { 
                    echo "Push to Docker Hub failed" 
                } 
            } 
        } 

        stage("Remove Docker Image Locally") { 
            steps { 
                sh ''' 
                    docker rmi -f ${DOCKERHUB_USERNAME}/web2 || true 
                    docker rmi -f web2 || true 
                ''' 
            } 
            post { 
                success { 
                    echo "Docker images removed locally" 
                } 
                failure { 
                    echo "Failed to remove Docker images" 
                } 
            } 
        } 

        stage("Stop and Restart Container") { 
            steps { 
                sh ''' 
                    docker rm -f app || true 
                    docker run -d --name app -p 8081:8080 ${DOCKERHUB_USERNAME}/web2 
                ''' 
            } 
            post { 
                success { 
                    echo "Container stopped (if any) and restarted successfully" 
                } 
                failure { 
                    echo "Failed to restart container" 
                } 
            } 
        } 
    } 

    post { 
        success { 
            echo "Deployment successful" 
        } 
        failure { 
            echo "Deployment failed" 
        } 
    } 
}
