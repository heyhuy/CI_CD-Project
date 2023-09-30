pipeline {
  agent any
  environment{
    DOCKER_HUB_USERNAME = "heyhuyvti"
    APP_NAME = "CICD-Project"
    IMAGE_TAG = "${BUILD_NUMBER}"
    IMAGE_NAME = "${DOCKERHUB_USERNAME}" + "/" + "${APP_NAME}"
    REGISTRY_CREDS = 'dockerhub'

  }
  stages {
    stage('cleanup workspace') {
      steps {
            script{
                cleanWs()
            }
      }
    }

    stage('Checkout SCM') {
      steps {
        git credentialsId: 'github',
        url: 'https://github.com/heyhuy/CI_CD-Project',
        branch: 'main'
      }
    }

    stage('Build Docker Image') {
      steps {
        docker_image = docker.build "${IMAGE_NAME}"
      }
    }

    stage('Push Docker Image') {
      steps {
        script {
            docker.withRegistry('',REGISTRY_CREDS){
                docker_image.push("$BUILD_NUMBER")
                docker_image.push('latest')
            }

        }

      }
    }
    stage('delete Docker Image') {
      steps {
        script {
            sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
            sh "docker rmi ${IMAGE_NAME}:latest"

        }

      }
    }

    stage('strigger config change pipline') {
      steps {
        script {
            sh "curl -v -k-user admin:11c2a6ee392ff7b61d77bc3c76b4dc5a9f -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' -data 'IMAGE_TAG=${IMAGE_TAG}' 'http:// 50.19.171.233:8080/job/gitops-argocd_CD/buildWithParameters?token=gitops-config' "

        }

      }
    }




  }

}