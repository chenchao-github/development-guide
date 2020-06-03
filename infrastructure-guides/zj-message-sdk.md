## 基础设施-消息套件 使用说明

消息套件，用于和 ucp 平台进行交互

通过 ucp，可实现 tcp，udp 等各种通讯协议的接入以及报文处理

下文中部分名词释义：

- app：后端新架构下的 spring 应用，如：treasury-brain
- ucp：ucp 平台
- ucp 应用：在 ucp 平台下运行的应用
- 消息套件：指 zj-message-sdk 消息套件

> **使用建议**:
>
> 如果 app 有 http 通讯需求，应当优先考虑使用 spring 的 RestController （接收 http 请求） 和 RestTemplate （发送 http 请求） 来实现

### 使用简介

#### ucp 平台

xlink 平台中负责通讯转发的子项目，提供图形化，可配置的流程化通讯处理

ucp 本身只是一个运行容器，通过一系列 ucp 组件库来扩展其功能，并通过 ucp 应用来执行具体功能

为配合消息套件，在 `UCP_STD_Library` 中，已经实现了一系列相关的组件，如下：

- ZjCloudRocketMQ接入适配器
- ZjCloudRocketMQ接出适配器
- ZjCloudRocketMQ消息发送组件
- ZjCloudRocketMQ消息接收组件

同时，还提供了相关的`渠道模版`，可供 ucp 应用 开发做参考：

- ZjCloudInput 渠道模版：接收 app 的请求，并返回响应
- ZjCloudOutput 渠道模版：向 app 发起请求，并接收 app 的响应

> 创建 ucp 应用时，可以直接使用上述模版，修改配置。
> 再依据第三方系统通讯的需要，配置 tcp 适配器（或其他）和报文解析组件等即可。

#### MQ 队列

> 目前采用 RocketMQ 技术栈

消息套件通过 MQ 队列与 ucp 平台进行数据交换，采用请求响应模式（即：要求有匹配的响应）

根据数据的发起者，和数据流向，一共需要创建 4 个队列：

- ucp 发起请求，app 响应：
    - `UCP2BOOT_REQ`： ucp 向 app 发请求使用的队列
    - `BOOT2UCP_RESP`： app 向 ucp 返回响应使用的队列

- app 发起请求，ucp 响应：
    - `BOOT2UCP_REQ`： app 向 ucp 发请求使用的队列
    - `UCP2BOOT_RESP`： ucp 向 app 返回响应使用的队列

> 在使用时，请确保已经手动创建好上述 4 个队列

#### zj-message-sdk 消息套件

app 要想使用 ucp 平台，需要使用 **zj-message-sdk** 消息套件

1.在 build.gradle 构建脚本中:

```groovy
// current-version：请使用当前最新版本替换
implementation 'com.zjft.microservice:zj-message-sdk:current-version'
```

2.然后刷新 gradle 依赖

3.在项目 application.yml 中添加如下配置：

```yaml
rocketmq:
  name-server: 10.34.12.130:9876
  producer:
    group: boot2ucp_producer_group
    sendMessageTimeout: 80000
zj:
  rocketmq:
    data:
      boot2ucp:
        channelID: ZjCloudInput
        serialNoHead: 0
        timeout: 10000
    topic:
      boot2ucp:
        request: BOOT2UCP_REQ
        response: UCP2BOOT_RESP
      ucp2boot:
        request: UCP2BOOT_REQ
        response: BOOT2UCP_RESP
```

其中的关键参数：

- rocketmq.name-server: MQ 服务器地址
- zj.rocketmq.data.boot2ucp.channelID: 向 ucp 请求时所请求的 ucp 中的渠道 ID
- zj.rocketmq.data.boot2ucp.serialNoHead: 0~99 的数值，当且仅当 app 部署多个节点的时候，需要配置不一样的值，否则配置 0 即可
- zj.rocketmq.data.boot2ucp.timeout: 向 ucp 请求时，等待 ucp 响应的最大时间，单位为ms（毫秒）

4.引入套件依赖后，只要配置 springboot 允许扫描到 `com.zjft.microservie.message` 包即可生效

> 通常项目主启动类已经配置了 @ComponentScan("com.zjft.microservice") 因此不用再配置 @ComponentScan("com.zjft.microservice.message")

5.在 app 启动时，会自动启动对应的 MQ 队列消费者和生产者

消息套件提供 2 种模式与 ucp 进行交互，分别为：

1. 调用 ucp 平台服务：请求 ucp 对应渠道下的交易，并等待 ucp 的返回
2. 接收 ucp 请求并处理：创建 Resource 接口，等待 ucp 平台主动向 app 发起请求，然后处理并给 ucp 平台以响应

##### 1.调用 ucp 平台服务

1. 注入 `com.zjft.microservice.message.boot2ucp.service.UcpMessageService` 服务
1. 调用 UcpMessageService 的 `public <T> T sendInfo(String txCode, Object msg, Class<T> returnType)` 方法即可

> sendInfo 有 3 个参数：
>
>  txCode：请求 ucp 的交易码
>
>  msg：要发送的消息，任意对象
>
>  returnType：要收到的返回消息对象类型

##### 2.接收 ucp 请求并处理

1.创建 Resource 接口，创建需要被调用的方法，并使用 `@ZjMessageMapping` 注解标注，注解的 value 为 ucp 请求时候的 txCode

```java
public interface SampleMessageResource {
	@ZjMessageMapping("sample1")
	String test1(String username);

	@ZjMessageMapping("sample2")
	TestResponseDTO test2(TestRequestDTO testRequestDTO);
}
```

2.创建 ResourceImpl 实现类，在实现类上使用 `@ZjMessageResource` 注解标注

```java
@Slf4j
@Service
@ZjMessageResource
public class SampleMessageResourceImpl implements SampleMessageResource {

	@Override
	public String test1(String username) {
        // ...
	}

	@Override
	public TestResponseDTO test2(TestRequestDTO testRequestDTO) {
		// ...
	}
}
```

3.**注意：** ucp 请求时候的报文格式，必须与 Resource 接口中的 DTO 请求参数的结构一致，否则 app 收到报文后会转换错误

