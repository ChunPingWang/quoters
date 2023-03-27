pipeline {
  agent none
  stages {
    stage('build-and-deploy') {
      agent {
        docker {
          image 'springci/slackboot:latest'
          args '-v $HOME/.m2:/tmp/jenkins-home/.m2'
        }

      }
      environment {
        PWS = credentials('pcfone-builds_at_springframework.org')
      }
      options {
        timeout(time: 30, unit: 'MINUTES')
      }
      steps {
        sh 'MAVEN_OPTS="-Duser.name=jenkins -Duser.home=/tmp/jenkins-home" ./mvnw clean package'
        sh 'mvn clean package'
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