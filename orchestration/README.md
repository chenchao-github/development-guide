## 业务编排

名词定义：

- Resource：资源，在项目中表现为 Resource 接口，即可被访问到的资源，访问方式可以是 Http（@RestController），MQ（通过UCP调用），ZjComponent（通过注入 ResourceImpl 或者 ResourceClient）
- Flow：业务编排工作流
- ZjComponent：工作流中的组件

业务编排：

旨在将现有 Resource 资源，进行重复利用，通过 ZjComponent 组件，处理各个 Resource 接口的差异，然后通过工作流程编排起来。

核心思想：

- 复用粒度：我们希望能够复用的是 Resource 资源，而不是 ZjComponent。因此 ZjComponent 对项目实施是完全开放的。
- Resource 与业务流程的关系：业务编排出来的流程，本身也是一种 Resource 资源，通过 Resource 接口提供给外界使用。
- MVC 结构：常规服务，由 Resource -> Service -> Repository，业务编排，由 Resource -> Flow -> Repository。业务编排替代的是 Service 部分，Repository 是共用的。
- ZjComponent 与 Resource 的关系：ZjComponent 是业务流程中的最小单元，是可编码的。Resource 是做业务编排时的一系列公共资源，可以理解为已封装好的一系列接口。ZjComponent 可以使用这些资源，不限制数量，也不限制使用方式。

### 整体功能描述

#### 平台功能

- 核心：注解定义，接口定义
- Resource 接口生成：在编译期，根据注解生成业务编排 Resource 的具体实现
- 流程 Service 生成：根据 xml 中所定义的工作流，在编译期，生成业务流程代码，然后注入到 Resource 实现中
- 资源管理：
    - bean 容器：通过与 spring bean 容器集成，将应用资源全部注册到 spring 容器，以便使用 spring 的功能
    - 应用资源加载：加载工作流，ZjComponent等

#### 单体与微服务模式

ZjComponent 采用 spring 依赖注入，调用相关 Resource 均面向接口。在运行时，会根据单体或是微服务模式启动的差别，注入 ResourceImpl 或是 ResourceClient。

> 且这个动作是自动进行的，和现有的单体微服务应用构建运行保持一致。

#### 流程和组件参数

流程由 Resource 接口对外提供服务，Resource 接口可以是：
- Spring mvc 的标准 Controller 接口。
- @ZjMessageResource 等接口

Resource 接口实现中，自动注入对应 ID 的工作流 Service，然后调用工作流 Service 进行业务处理，业务处理完毕后，再返回给调用方。

所有组件都必须包含三个传入参数和一个 String 类型输出参数：

- 传入参数：
    - 参数1：requestDTO，来自 Resource 接口的请求参数
    - 参数2：returnDTO，基于 Resource 接口的响应类型创建的一个空对象
    - 参数3：tempObj，基于流程所定义的一个临时数据对象类型，创建的一个空对象
- 传出参数：
    - String：组件出口

tempObj，用于在组件中传递一些临时数据。只有设置到 returnDTO 中的数据，才会被返回给 Resource 接口调用方。

#### 文件接口设计

[文件接口设计](FileInterface.md)

#### 相关技术

###### 注解处理器（Annotation Processer）

在编译阶段前通过注解处理器基于相关 @ZjWorkFlowEndpoint 和 @ZjWorkFlow 接口生成其对应的 Impl 实现。