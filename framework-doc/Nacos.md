# Nacos

### 下载/安装

    下载地址：https://github.com/alibaba/nacos/releases
    解压：   tunzip nacos-server-1.1.3.zip
    部署位置：10.34.12.130  /opt

### 使用注册中心

    1. 添加依赖：
    compile 'org.springframework.cloud:spring-cloud-starter-openfeign'
    compile 'org.springframework.cloud:spring-cloud-starter-alibaba-nacos-discovery'
    compile 'org.springframework.cloud:spring-cloud-starter-alibaba-nacos-config'
    
    2. 编写lient
    业务项目中增加client子模块，使用`@FeignClient`注解
    
    3. 业务模块调用client接口
    
### 使用配置中心

    1. 业务项目子模块的bootstrap.yml中配置nacos地址
    2. 在nacos-ui中增加配置文件
    3. 子模块启动时，bootstrap.yml会下载nacos上的配置文件

### 启动
   
    单节点启动：./bin/startup.sh -m standalone
    访问UI：   http://your_ip:8848/nacos
    账号密码：  nacos/nacos
 
 