
## SkyWalking 6.3

##### 下载/安装

    下载地址：https://github.com/apache/skywalking/releases 
    解压：   tar zxf apache-skywalking-apm-6.3.0.tar.gz

##### 启动
   
    启动：   ./bin/startup.sh
    访问UI： http://your_ip:8080
    部署位置：10.34.12.130  /opt
 
##### 使用探针

    启动时增加JVM 命令选项
        -DSW_AGENT_NAME=网关 -javaagent:E:\apache-skywalking-apm-bin\agent\skywalking-agent.jar
        
#### 介绍

    探针：探针集成各种插件，通过bytebuddy对字节码做切面，通过gRPC发送信息到skywaking后端
    存储：默认是h2，可以配置 elastic search 来存储
    oap：后端采集gRPC的信息做统计，暴露http接口给ui
    ui： 通过OAL(可观察性分析语言)来获取分析数据并展现