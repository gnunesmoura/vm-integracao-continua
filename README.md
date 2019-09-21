# Infraestrutura para CI local

VM provisionada utilizando Vagrant preparada para serviços de Integração Continua (CI).

## Passo a passo
### Pré-requisitos
1. [Vagrant](https://www.vagrantup.com/intro/getting-started/) instalado.

### Deploy local
1. `git clone https://github.com/gnunesmoura/vm-integracao-continua.git`
2. `cd vm-integracao-continua`
3. `vagrant up`
4. `vagrant ssh`

Pronto, em alguns segundos os serviços [Jenkins](http://localhost:8080) e [SonarQube](http://localhost:9000) vão estar disponiveis.

### Exemplo

Exemplo de Pipeline para testar e enviar métricas para SonarQube:
```
pipeline {
    agent {
        docker {
            image 'node:10'
            args '-v /home/vagrant/sonar-scanner-4.0.0.1744-linux:/home/vagrant/sonar-scanner --link sonarqube:sonarqube'
        }
    }
    
    parameters { string(name: 'SONAR_TOKEN', defaultValue: 'token', description: '') }
    parameters { string(name: 'PROJECT_KEY', defaultValue: 'projectKey', description: '') }

    stages {
        stage('Clone do repositório') {
            steps {
                git 'https://github.com/your-npm-project.git'
            }
        }
        
        stage('Execução de testes automaticos') {
            steps {
                sh 'npm i'
                sh 'npm run test'
            }
        }
    
        stage('Realizar coleta de métricas') {
            steps {
                sh '/home/vagrant/sonar-scanner/bin/sonar-scanner   -Dsonar.projectKey="${PROJECT_KEY}"   -Dsonar.sources=.   -Dsonar.host.url=http://sonarqube:9000   -Dsonar.login="${SONAR_TOKEN}"'
            }
        }
    }
}```