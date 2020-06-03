## 基础设施-业务编排套件 使用说明

业务编排套件，用于支持组件化和流程业务编排

请阅读：[业务编排概要设计](../orchestration/README.md)

请参考：[接口设计](../orchestration/FileInterface.md)

下文中部分名词释义：

- app：后端新架构下的 spring 应用，如：treasury-brain
- 业务编排套件：指 zj-orchestration-core 业务编排套件

### 安装与启动

1.添加依赖

在 build.gradle 构建脚本中:

- 非多模块应用：

```groovy
// current-version：请使用当前最新版本替换
implementation 'com.zjft.microservice:zj-handler-core:current-version'
compileOnly 'com.zjft.microservice:zj-orchestration-core:current-version'
annotationProcessor 'com.zjft.microservice:zj-orchestration-core:current-version'
```

- 微服务多模块应用：

```groovy
// current-version：请使用当前最新版本替换
if (it.name.endsWith("-api")) {
        dependencies {
            compileOnly 'com.zjft.microservice:zj-orchestration-core:current-version'
        }
}
if (it.name.endsWith("-impl")) {
        dependencies {
            implementation 'com.zjft.microservice:zj-handler-core:current-version'
            compileOnly 'com.zjft.microservice:zj-orchestration-core:current-version'
            annotationProcessor 'com.zjft.microservice:zj-orchestration-core:current-version'
        }
}
```

2.然后刷新 gradle 依赖

3.引入套件依赖后，只要配置 springboot 允许扫描到 `com.zjft.microservice.orchestration` 包即可生效

> 通常项目主启动类已经配置了 @ComponentScan("com.zjft.microservice") 因此不用再配置 @ComponentScan("com.zjft.microservice.orchestration")

4.在 app 启动时，会自动加载项目内的组件和流程到流程引擎

### 多模块应用

对于多模块应用，工作流文件和组件，可以放在任何一个或者多个模块下（对于微服务多模块应用，应当放在 -impl 结尾的模块内）

但为了保证 cloud 模式下也能正常运行，`必须保证工作流文件和其使用到的组件在同一个模块内`

### 组件与流程的开发

首先请阅读：[业务编排文件接口](../orchestration/FileInterface.md)

#### 1.编写 ZjComponent

- ZjComponent 由 java function 来表示，请使用最基本的 java 类结构，不要使用内部类等复杂写法
- 按照项目结构规范，ZjComponent 应当放在 -impl 结尾的模块内，父级包应当为 component，如：`package com.zjft.microservice.treasurybrain.storage.component.XxxComponent.java`
- 在 XxxComponent.java 类上，`必须使用 @ZjComponentResource(group = "分组中文名")` 来为组件设置分组
- XxxComponent.java 类中，可以使用 spring 的任意功能，比如注入 Mapper，Service，Log，Resource（注意 Resource 应当注入 interface，以便运行期动态注入 impl 或者 client）
- 在 XxxComponent.java 类中编写函数，函数`返回值必须是 String 类型`，且`必须有3个参数`。**注意：**
    1. 组件的三个参数可以是任意对象
    2. 同一个流程中，组件的参数对象类型应当一致，或者能够自动强转，否则运行的时候会出现类型转换错误
- 在函数上，`必须使用 @ZjComponentMapping("组件中文名")` 来声明这是一个组件，还`必须使用 @ZjComponentExitPaths()` 来设置组件的出口。函数的实现代码中，return 的值，必须在所声明的出口中，否则运行时候会报错

#### 2.绘制流程

请使用 [zj-microservice-web-ide 开发辅助工具](../idea-plugin/user-guides.md)

#### 3.使用流程（将流程以 restful 接口形式对外提供服务）

每个流程都有一个当前模块内唯一的 id：

```xml
<!--id：全局唯一，规则：任意有含义英文-->
<zj-orchestration id="test" name="" >

</zj-orchestration>
```

使用流程步骤如下：

1.创建 Resource 接口（对于微服务多模块应用，接口应当放在 -api 结尾的模块内）

- 使用 spring mvc 的 Mapping 注解声明接口 url
- 使用 ZjWorkFlow 注解，声明引用的业务编排工作流的 id

```java
public interface UserResource {
    String PREFIX = "${user-center:}/v2/user";
	
    @PostMapping(PREFIX + "/test")
    @ZjWorkFlow(value = "test")
	ReturnDTO test(RequestDTO requestDTO);
}
```

2.创建 ResourceEndpoint 接口，并继承 Resource 接口（对于微服务多模块应用，Endpoint 接口应当放在 -impl 结尾的模块内）

- 只需要使用 ZjWorkFlowEndpoint 注解，在接口类上做标识即可，这样注解处理器就会在编译时，处理该接口以生成 ResourceImpl 实现

```java
@ZjWorkFlowEndpoint
public interface UserResourceEndpoint extends UserResource {

}
```