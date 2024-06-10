pipeline {
    agent {
        label 'node'
    }
    options {
        // Timeout counter starts AFTER agent is allocated
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
    }
   parameters {
                    choice(name: 'action', choices: ['apply','destroy'], description: 'Who should I say hello to?')
                }
    environment{
        Deploy_to = "production"
        greetings = "good mornint"
    }
    stages {
        stage('Init') {
            steps {
                sh """
                 cd 01.vpc
                 terraform init -reconfigure
                """
            }
        }
        stage('Apply') {
            steps {
               sh """
                 cd 01.vpc
                 terraform plan 
                """
            }
        }
        stage('Deploy') {
             input {
                message "Should we continue?"
                ok "Yes, we should."
                submitter "alice,bob"
            }
            steps {
               sh """
                 cd 01.vpc
                 terraform apply -auto-approve
                """
            }
        }
        
       
    }
        post {
            always{
                echo ' i will always say hello again'
                deleteDir()
            }
            success{
                echo ' i will run the pipeline success'
            }
            failure{
                echo ' i will run the pipeline failure'
            }
        }
}