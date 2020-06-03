### Jenkins

请查阅文档：[https://jenkins.io/zh/doc/](https://jenkins.io/zh/doc/)

```bash

docker run \
  -u root \
  --rm \
  -d \
  -p 80:8080 \
  -p 50000:50000 \
  -v jenkins-data:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /opt/gradle-4.10.3:/opt/gradle-4.10.3  \
  -v /opt/.gradle:/root/.gradle  \
  -v /etc/localtime:/etc/localtime \
  jenkinsci/blueocean
  
```