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
    IAC_TOOLS             = 'C:\\ProgramData\\Jenkins\\.jenkins\\tools\\iac'
    PATH                  = "C:\\ProgramData\\Jenkins\\.jenkins\\tools\\iac;C:\\Program Files\\Git\\usr\\bin;${PATH}"
  }

  triggers {
    pollSCM('H/2 * * * *')
  }

  stages {

    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Tooling') {
      steps {
        powershell '''
          $ErrorActionPreference = 'Stop'
          [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
          $dir = $env:IAC_TOOLS
          New-Item -ItemType Directory -Force -Path $dir | Out-Null
          New-Item -ItemType Directory -Force -Path "C:\\ProgramData\\Jenkins\\.jenkins\\tf-state" | Out-Null

          if (-not (Test-Path "$dir\\terraform.exe")) {
            Write-Host "Installing Terraform 1.9.5"
            Invoke-WebRequest -UseBasicParsing "https://releases.hashicorp.com/terraform/1.9.5/terraform_1.9.5_windows_amd64.zip" -OutFile "$env:TEMP\\tf.zip"
            Expand-Archive "$env:TEMP\\tf.zip" -DestinationPath $dir -Force
          }
          if (-not (Test-Path "$dir\\tflint.exe")) {
            Write-Host "Installing TFLint 0.52.0"
            Invoke-WebRequest -UseBasicParsing "https://github.com/terraform-linters/tflint/releases/download/v0.52.0/tflint_windows_amd64.zip" -OutFile "$env:TEMP\\tflint.zip"
            Expand-Archive "$env:TEMP\\tflint.zip" -DestinationPath $dir -Force
          }
          if (-not (Test-Path "$dir\\tfsec.exe")) {
            Write-Host "Installing tfsec 1.28.14"
            Invoke-WebRequest -UseBasicParsing "https://github.com/aquasecurity/tfsec/releases/download/v1.28.14/tfsec-windows-amd64.exe" -OutFile "$dir\\tfsec.exe"
          }

          terraform -version
          tflint --version
          tfsec --version
        '''
      }
    }

    stage('Validate') {
      steps {
        bat 'terraform fmt -check -recursive -diff'
        bat 'terraform init -input=false'
        bat 'terraform validate'
      }
    }

    stage('Security Scan') {
      steps {
        bat 'tflint --init && tflint --format compact'
        bat 'tfsec . --format junit --out tfsec-report.xml --soft-fail'
        bat 'tfsec . --minimum-severity HIGH'
      }
      post {
        always { junit allowEmptyResults: true, testResults: 'tfsec-report.xml' }
      }
    }

    stage('Plan') {
      steps {
        bat 'terraform plan -input=false -out=tfplan'
        bat 'terraform show -no-color tfplan > tfplan.txt'
        archiveArtifacts artifacts: 'tfplan, tfplan.txt', fingerprint: true
      }
    }

    stage('Approval') {
      when { branch 'main' }
      steps {
        timeout(time: 30, unit: 'MINUTES') {
          input message: 'Apply the archived plan to the cloud account?',
                ok: 'Apply'
        }
      }
    }

    stage('Apply') {
      when { branch 'main' }
      steps { bat 'terraform apply -input=false tfplan' }
    }
  }

  post {
    success { echo 'Pipeline completed successfully.' }
    failure { echo 'Pipeline failed - inspect the stage that went red.' }
    always  { cleanWs() }
  }
}
