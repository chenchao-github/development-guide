## 项目设计

### 1.开源框架说明

#### 1.1.WEB层: 
             
- `Spring MVC`： 基于 Servlet编程模型的web框架
- `Spring Security Oauth2`: 权限管理框架，支持OAuth2 JWT。[官方文档](https://docs.spring.io/spring-security/site/docs/5.1.5.RELEASE/reference/htmlsingle/)
- `Spring WebSocket`：基于tcp和http的全双工通信协议 [文档](https://docs.spring.io/spring/docs/current/spring-framework-reference/web.html#websocket-intro)
- `Spring Fox` 帮助Spring自动构建swagger-api文档的框架 [官网](http://springfox.github.io/springfox/)，[项目地址](https://github.com/springfox/springfox)
- `Swagger`： 基于OpenAPI规范2.0的在线接口文档：[官网](https://swagger.io/) 


#### 1.2.Service业务逻辑层

- `Spring` ： Bean 容器工厂 [官方文档](https://docs.spring.io/spring/docs/current/spring-framework-reference/index.html)
- `Quartz` ： （定时）任务调度框架
- `RocketMQ`：消息队列
- `Lombok` ： 自动生成`getter/setter/toString`等方法的工具
- `Mapstruct` ： POJO类快速转换赋值的工具

#### 1.3.DAO持久层
             
- `MyBatis`: [官方文档](http://www.mybatis.org/mybatis-3/)
- `spring-data-redis` ： 默认是lettuce


#### 1.4.项目构建和管理

- `Spring Boot`: 开箱即用的Java项目构建平台。[官方文档](https://docs.spring.io/spring-boot/docs/2.1.5.RELEASE/reference/htmlsingle/) 
- `Gradle` : jar包依赖管理，Java项目编译打包
- `Git` : 代码版本控制
- `Jenkins` ： 自动化构建系统，用于`CI & CD`
- `Docker`  ： 项目打包成镜像后发布

### 2.项目设计

#### 2.1.应用组成（此处为示例，详见具体项目的 README）

| 模块名称 | 模块  | 描述  |
| ----| ----| -----------|
| 通用模块    |  zj-common       | 普通java模块 |
| 用户中心    | zj-user-center   | web模块  |
| 渠道中心   | zj-channel-center | web模块  |
| 加钞计划   | zj-addnotes-plan  | web模块 |
| 数据洞察   | zj-data-insight   | web模块  |
| 流转模块    | zj-tauro         | web模块  |
| 手持机      | zj-mobil         | web模块  |
| 密码锁      |  zj-lock         | web模块 |
| 推送服务    | zj-push-server   | web模块 |
| 定时任务    | zj-time-job      | web模块 |
| ...       | ...               | - |

#### 2.2.项目依赖关系与管理

参见：[项目依赖关系与管理方法](项目依赖关系与管理方法.md)
