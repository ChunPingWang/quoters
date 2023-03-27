pipeline {
  agent none
  stages {
    stage('clone') {
      steps {
        sh 'git clone git@github.com:ChunPingWang/quoters.git'
      }
    }

    stage('build ') {
      steps {
        sh 'mvn clean package'
      }
    }

    stage('build image') {
      steps {
        sh 'mvnw spring-boot:build-image  -Dspring-boot.build-image.imageName=cpingwang/quoters'
      }
    }

    stage('push') {
      steps {
        sh 'docker push cpingwang/quoters'
      }
    }

  }
  post {
    changed {
      script {
        slackSend(
          color: (currentBuild.currentResult == 'SUCCESS') ? 'good' : 'danger',
          channel: '#sagan-content',
          message: "${currentBuild.fullDisplayName} - `${currentBuild.currentResult}`\n${env.BUILD_URL}")
          emailext(
            subject: "[${currentBuild.fullDisplayName}] ${currentBuild.currentResult}",
            mimeType: 'text/html',
            recipientProviders: [[$class: 'CulpritsRecipientProvider'], [$class: 'RequesterRecipientProvider']],
            body: "<a href=\"${env.BUILD_URL}\">${currentBuild.fullDisplayName} is reported as ${currentBuild.currentResult}</a>")
          }

        }

      }
      options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '14'))
      }
      triggers {
        pollSCM('H/10 * * * *')
      }
    }