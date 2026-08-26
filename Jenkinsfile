pipeline {
  agent any

  options {
    ansiColor('xterm')
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '20'))
  }

  environment {
    AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    AWS_DEFAULT_REGION    = 'ap-south-1'
    TF_IN_AUTOMATION      = 'true'
    OPERATOR              = 'Pulkit Chauhan - SAP 500121424 - Roll R2142230354 - UPES Dehradun'
    IAC_TOOLS             = 'C:\\ProgramData\\Jenkins\\.jenkins\\tools\\iac'
    PATH                  = "C:\\ProgramData\\Jenkins\\.jenkins\\tools\\iac;C:\\Program Files\\Git\\usr\\bin;${PATH}"
  }

  triggers {
    pollSCM('H/2 * * * *')
  }

  stages {

    stage('Checkout') {
      steps {
        echo "OPERATOR: ${env.OPERATOR}"
        checkout scm
      }
      post { always { echo "OPERATOR: ${env.OPERATOR} -- stage Checkout finished" } }
    }

    stage('Tooling') {
      steps {
        echo "OPERATOR: ${env.OPERATOR}"
        powershell '''
          $ErrorActionPreference = 'Stop'
          [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
          $dir = $env:IAC_TOOLS
          New-Item -ItemType Directory -Force -Path $dir | Out-Null
          New-Item -ItemType Directory -Force -Path "C:\\ProgramData\\Jenkins\\.jenkins\\tf-state" | Out-Null

          Write-Host "OPERATOR: $env:OPERATOR"

          if (-not (Test-Path "$dir\\terraform.exe")) {
            Invoke-WebRequest -UseBasicParsing "https://releases.hashicorp.com/terraform/1.9.5/terraform_1.9.5_windows_amd64.zip" -OutFile "$env:TEMP\\tf.zip"
            Expand-Archive "$env:TEMP\\tf.zip" -DestinationPath $dir -Force
          }
          if (-not (Test-Path "$dir\\tflint.exe")) {
            Invoke-WebRequest -UseBasicParsing "https://github.com/terraform-linters/tflint/releases/download/v0.52.0/tflint_windows_amd64.zip" -OutFile "$env:TEMP\\tflint.zip"
            Expand-Archive "$env:TEMP\\tflint.zip" -DestinationPath $dir -Force
          }
          if (-not (Test-Path "$dir\\tfsec.exe")) {
            Invoke-WebRequest -UseBasicParsing "https://github.com/aquasecurity/tfsec/releases/download/v1.28.14/tfsec-windows-amd64.exe" -OutFile "$dir\\tfsec.exe"
          }

          terraform -version
          tflint --version
          tfsec --version
          Write-Host "OPERATOR: $env:OPERATOR -- toolchain verified"
        '''
      }
      post { always { echo "OPERATOR: ${env.OPERATOR} -- stage Tooling finished" } }
    }

    stage('Validate') {
      steps {
        echo "OPERATOR: ${env.OPERATOR}"
        bat 'echo OPERATOR: %OPERATOR% && terraform fmt -check -recursive -diff'
        bat 'echo OPERATOR: %OPERATOR% && terraform init -input=false'
        bat 'echo OPERATOR: %OPERATOR% && terraform validate'
      }
      post { always { echo "OPERATOR: ${env.OPERATOR} -- stage Validate finished" } }
    }

    stage('Security Scan') {
      steps {
        echo "OPERATOR: ${env.OPERATOR}"
        bat 'echo OPERATOR: %OPERATOR% && tflint --init && tflint --format compact'
        bat 'echo OPERATOR: %OPERATOR% && tfsec . --format junit --out tfsec-report.xml --soft-fail'
        bat 'echo OPERATOR: %OPERATOR% && tfsec . --minimum-severity HIGH'
      }
      post {
        always {
          junit allowEmptyResults: true, testResults: 'tfsec-report.xml'
          echo "OPERATOR: ${env.OPERATOR} -- stage Security Scan finished"
        }
      }
    }

    stage('Plan') {
      steps {
        echo "OPERATOR: ${env.OPERATOR}"
        bat 'echo OPERATOR: %OPERATOR% && terraform plan -input=false -out=tfplan'
        bat 'terraform show -no-color tfplan > tfplan.txt'
        archiveArtifacts artifacts: 'tfplan, tfplan.txt', fingerprint: true
      }
      post { always { echo "OPERATOR: ${env.OPERATOR} -- stage Plan finished" } }
    }

    stage('Approval') {
      when { branch 'main' }
      steps {
        echo "OPERATOR: ${env.OPERATOR} -- awaiting approval"
        timeout(time: 30, unit: 'MINUTES') {
          input message: 'Apply the archived plan to the cloud account?',
                ok: 'Apply'
        }
      }
      post { always { echo "OPERATOR: ${env.OPERATOR} -- stage Approval finished" } }
    }

    stage('Apply') {
      when { branch 'main' }
      steps {
        echo "OPERATOR: ${env.OPERATOR}"
        bat 'echo OPERATOR: %OPERATOR% && terraform apply -input=false tfplan'
      }
      post { always { echo "OPERATOR: ${env.OPERATOR} -- stage Apply finished" } }
    }
  }

  post {
    success { echo "OPERATOR: ${env.OPERATOR} -- pipeline completed successfully." }
    failure { echo "OPERATOR: ${env.OPERATOR} -- pipeline failed; inspect the stage that went red." }
    always  {
      script { currentBuild.description = "Run by Pulkit Chauhan (SAP 500121424, R2142230354)" }
      cleanWs()
    }
  }
}
