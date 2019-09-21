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

#### Dentro da vm iniciada
1. `docker run -u root -d -p 8080:8080 -p 50000:50000 -v /var/jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock jenkinsci/blueocean`
2. `docker run -d --name sonarqube -p 9000:9000 sonarqube`
