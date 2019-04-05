/* 
* gradle build projects
* 
* README: https://jenkins.io/blog/2017/02/01/pipeline-scalability-best-practice/
*/ 

import groovy.json.JsonSlurper
import java.util.regex.*
import groovy.text.StreamingTemplateEngine

def callConsul(String PROJECT_NAME) {
  url = "http://consul:8500/v1/kv/${PROJECT_NAME}/config/?recurse"
  mystring = new URL("${url}").text
  def jsonSlurper = new JsonSlurper()
  def jsonArrayList = jsonSlurper.parseText(mystring)
  def consulMap = [:]
  jsonArrayList.Key.each {
    key = it.replaceAll("${PROJECT_NAME}/config/", "")
    value = new URL("http://consul:8500/v1/kv/${it}?raw").text
    consulMap[key] = value
  }
  return consulMap
}

@NonCPS
def sortBindings(vars) {
  def template = new StreamingTemplateEngine().createTemplate(text);
  String templateResults = template.make(vars);
	return templateResults;
}

@NonCPS
def parseJsFile(text, vars) {
  def template = new StreamingTemplateEngine().createTemplate(text);
  String templateResults = template.make(vars);
	return templateResults;
}

PROJECT_NAME = 'rundeck'
BRANCH = new URL("http://consul:8500/v1/kv/${PROJECT_NAME}/config/branch?raw").text
GITHUB_REPO = new URL("http://consul:8500/v1/kv/${PROJECT_NAME}/config/github_repo?raw").text

node('common')  {

    stage('*** Setup') {
      rootDir = pwd()
    }

    stage('*** Code Checkout') {
      git branch: "${BRANCH}",
      credentialsId: 'jenkins-credential-id',
      url: "${GITHUB_REPO}"
      consulMap = callConsul("${PROJECT_NAME}")
    }

    stage('*** Test') {
      println("Tests are deactivated")
    }

    stage('*** Config') {
      println("Configs are not yet defined in consul")
      }

    stage('*** Build App') {
      println("We don't build an app, just a docker container")
      stash includes: "**", name: 'everything'
    }
  }

node('docker-builds') {

  stage('*** Docker Build') {
    unstash 'everything'
    sh "docker build -t ${PROJECT_NAME}:${consulMap.branch} --build-arg NEWRELIC=\"./newrelic\" ."
    sh "docker tag ${PROJECT_NAME}:${consulMap.branch} ${consulMap.AWS_ACCOUNT_NUMBER}.dkr.ecr.${consulMap.REGION}.amazonaws.com/${PROJECT_NAME}-${consulMap.FQDN.replaceAll(/\./, "-")}:${consulMap.branch}"
  }

  stage('*** Docker Deploy') {
    AWS_LOGIN = sh(script: "aws ecr get-login --region ${consulMap.REGION} --profile ${consulMap.ENVIRONMENT}-${consulMap.PLATFORM.toLowerCase()} --no-include-email", returnStdout: true).trim()
    sh(script: "echo $AWS_LOGIN |/bin/bash -; docker push ${consulMap.AWS_ACCOUNT_NUMBER}.dkr.ecr.us-west-2.amazonaws.com/${PROJECT_NAME}-${consulMap.FQDN.replaceAll(/\./, "-")}:${consulMap.branch}", returnStdout: true)
  }
}
