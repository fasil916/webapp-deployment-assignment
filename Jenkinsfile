    pipeline {
        agent any
        
        
        environment {
            
                    
                   
                    SONAR_TOKEN = credentials('sonar-new-cred')
                    REGISTRY = 'docker.io/muhammadfasil'
                    IMAGE_NAME = 'webapp-demo'
                    
        }
    
        stages {
            stage('git checkout') {
                steps {
                    git branch: 'main', url: 'https://github.com/fasil916/webapp-deployment-assignment.git'
                   
                }
            }
    
            stage('maven build') {
                steps {
                    
                        sh 'mvn clean package -DskipTests'
                    
                }
            }
            
             stage('sonar') {
                 steps {
                     
                    
                      withSonarQubeEnv('sonar-server') {
                      sh '''mvn clean verify sonar:sonar -Dsonar.projectKey=webapp-demo -Dsonar.projectName='webapp-demo' -Dsonar.host.url=http://localhost:9000 -Dsonar.token=${SONAR_TOKEN} 
 '''
                                  }
              }
                
            }
             stage('docker  build') {
                steps {
                   
                         sh "docker build -t ${IMAGE_NAME} ."
                         sh "docker tag ${IMAGE_NAME} ${REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER}"
                    
                }
            }
            
            
          

             stage('dockerpush') {
                steps {
                   
                         script {
                       docker.withRegistry('', "docker-cred") {
                    docker.image("${REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER}").push()
                       }
                         
                    
                    
                }
            }
    
         }
         
         stage('manifest file update ') {
                steps {
                    dir('k8s') {
                       sh 'cat deployment.yaml'
                        sh "sed -i 's/replaceImageTag/${env.BUILD_NUMBER}/g' deployment.yaml"
                        sh 'cat deployment.yaml'
    
    
                    }
                }
            }
         
        stage('kube deploy') {
                steps {
                    dir('k8s') {
                        
                         script {
                             
                             sh "echo kuben starting ................"
                         withKubeConfig(caCertificate: '', clusterName: 'my-aks-cluster', contextName: 'my-aks-cluster', credentialsId: 'k8s-cred', namespace: 'webapp', restrictKubeConfigAccess: false, serverUrl: 'https://my-aks-cluster-9cgezvry.hcp.centralindia.azmk8s.io:443') {
    

                      
                      
                        try {
                          sh 'kubectl apply -f deployment.yaml'
                          sh 'kubectl apply -f service.yaml'
                          sh "kubectl rollout status deployment/webapp --timeout=120s"
                         } catch (err) {
                             
                            echo "Deployment failed, rolling back"
                            sh "kubectl rollout undo deployment/webapp"
                            echo "Rollback completed, but pipeline will continue"
                          }
                         }
                         
                    }
                    }
                    }
        }
                        
                    
                    
                }
            } 
       
    
