## 简介

本文档汇总了新架构中的一些框架和工具的使用说明、开发规范

microservice分支可以同时支持单体应用构建和分布式应用构建

## 单体应用
- [快速开始](startup/README.md)：快速搭建开发环境，进行开发和构建
- [项目设计](concepts-and-designs/README.md)：项目使用的技术和框架、及模块组成
- [开发者指南](developer-guides/README.md)：针对开发人员的编码规范要求
- [FAQs](trouble-shooting/README.md)：常见问题及解决方式

## 微服务应用

- [快速开始](startup/README-microservice.md)
- [微服务组件](concepts-and-designs/README-microservice.md)


## 基础设施

| 项目名称 | 模块  | 描述  |
| ----| ----| -----------|
| 网关应用    |  [zj-api-gateway](http://ubuntu/microservice/infrastructure/tree/develop/zj-api-gateway)     | 基于`spring cloud gateway`开发的微服务网关 |
| 日志插件    |  [zj-api-log](http://ubuntu/microservice/infrastructure/tree/develop/zj-api-log)        | 日志TraceId打印和存储 |
| 认证中心    |  [zj-auth-admin](infrastructure-guides/zi-auth-admin.md)      | 基于`spring security oauth2 + jwt` 的认证和鉴权 |
| 通用模块    |  zj-commons         | 共享基础库 |
| 方法处理器   |  [zj-handler](http://ubuntu/microservice/infrastructure/tree/develop/zj-handler) | 基于Spring的本地方法调用框架 |
| UCP消息套件  |  [zj-message](infrastructure-guides/zj-message-sdk.md)         | 基于UCP的RPC框架 |
| 业务编排套件  |  [zj-orchestration](infrastructure-guides/zj-orchestration-core.md)    | 业务组件流程编排 |
| 定时任务调度套件 |  [zj-quartz](http://ubuntu/microservice/infrastructure/tree/develop/zj-quartz)        | 定时任务调度sdk |
| idea插件 | [zj-microservice-web-ide ](idea-plugin/README.MD) |业务流程开发辅助工具|

## 进阶

- [框架选型及安装部署文档](framework-doc/README.MD)
- [技术书籍及资源列表](resouce-list/README.md)

## Camunda工作流相关

  - [CAMUNDA引擎基础概念](camunda-workflow/README.md)  
    >[Execution原理实例分析--变量篇](camunda-workflow/Execution原理实例分析--变量篇.md)  
     [Execution原理实例分析--并发网关与排他网关](camunda-workflow/Execution原理实例分析--并发网关与排他网关.md)  
     [Execution原理实例分析--预出库](camunda-workflow/Execution原理实例分析--预出库.md)

