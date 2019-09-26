# VM e Ferramentas para Integração Contínua
 
VM provisionada utilizando Vagrant preparada para serviços de Integração Contínua (CI).
 
## Pré-requisitos
1. [VirtualBox](https://www.virtualbox.org/)
2. [Vagrant](https://www.vagrantup.com/intro/getting-started/)
 
## Passo a passo
O passo-a-passo abaixo descreve o provisionamento e acesso na vm utilizando o bash:
1. `git clone https://github.com/gnunesmoura/vm-integracao-continua.git`
2. `cd vm-integracao-continua`
3. `vagrant up`
4. `vagrant ssh`
 
Agora, dentro da máquina virtual iremos iniciar os containers [jenkinsci](https://hub.docker.com/r/jenkinsci/blueocean) e [sonarqube](https://hub.docker.com/_/sonarqube) com algumas configurações adicionais:
* `docker run --restart always -u root -d --name jenkins -p 8080:8080 -p 50000:50000 -v /var/jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock jenkinsci/blueocean`
* `docker run --restart always -d --name sonarqube -p 9000:9000 sonarqube`
 
Pronto, em alguns segundos os serviços [Jenkins](http://localhost:8080) e [SonarQube](http://localhost:9000) vão estar disponiveis.
 
## Utilização
O Jenkins iniciado tem acesso ao docker-cli do seu host com usuário root, dessa forma é possível executar pipelines em agentes docker sem qualquer configuração prévia.
 
### Exemplos
Os exemplos descritos nessa seção foram testados, quando existir a necessidade de configuração de funcionalidades extras as mesmas serão descritas no exemplo.
 
#### Exemplo 1
O exemplo abaixo tem como finalidade realizar a execução de testes automáticos de um [microserviço](https://github.com/gnunesmoura/central-controle) e enviar métricas ao SonarQube.
 
Passoa a Passo:
1. Crie um projeto no SonarQube;
2. Configure um token de acesso para o Jenkins;
3. Crie um Pipeline Job com o Pipeline descrito abaixo: 
```
pipeline {
    agent {
        docker {
            image 'node:10'
            args '-v /home/vagrant/sonar-scanner-4.0.0.1744-linux:/home/vagrant/sonar-scanner --link sonarqube:sonarqube'
        }
    }
    
    parameters { 
        string(name: 'PROJECT_KEY', defaultValue: 'central-controle', description: 'Identificação do projeto') 
        string(name: 'SONAR_TOKEN', defaultValue: 'token', description: 'Token de acesso ao SonarQube')
    }
 
    stages {
        stage('Clonando o repositório') {
            steps {
                git 'https://github.com/gnunesmoura/central-controle.git'
            }
        }
        
        stage('Instalando dependências') {
            steps {
                sh 'npm i'
            }
        }
        
        stage('Execução de testes automáticos') {
            steps {
                sh 'npm run test'
            }
        }
    
        stage('Realizar coleta de métricas') {
            steps {
                sh '/home/vagrant/sonar-scanner/bin/sonar-scanner   -Dsonar.projectKey="${PROJECT_KEY}"   -Dsonar.sources=. -Dsonar.host.url=http://sonarqube:9000   -Dsonar.login="${SONAR_TOKEN}"'
            }
        }
    }
}
```
4. Salve o Pipeline criado.

Para iniciar o Job insira o token de acesso criado no SonarQube.
