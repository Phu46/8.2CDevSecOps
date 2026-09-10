pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Phu46/8.2CDevSecOps.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test || true'   // continue even if tests fail
            }
        }

        stage('Generate Coverage Report') {
            steps {
                sh 'npm run coverage || true'   // ensure a coverage report exists
            }
        }

        stage('NPM Audit (Security Scan)') {
            steps {
                sh 'npm audit || true'   // prints known CVEs in the console output
            }
        }
    }
}
