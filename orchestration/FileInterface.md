## 业务编排文件接口

#### 目录结构

```
Model-api
    src
        java
            com.zjft.microservice.xx.web.XxxResource.java
Model-client
    src
        java
            com.zjft.microservice.xx.web.XxxResourceClient.java    
Model-impl
    src
        java
            com.zjft.microservice.xx.component.Test.java
            com.zjft.microservice.xx.web.XxxResourceEndPoint.java
        resource
            workflow
                xxxxx1.xml
                xxxxx2.xml
                ...
            workflowlayout
                xxxxx1.json
                xxxxx2.json
                ...
```

只需要声明 Resource 接口，如果该 Resource 会被别的模块访问到，则还要声明 ResourceClient，以便在微服务模式下能够夸服务访问到。
`ResourceImpl 不需要编写，但要在 Impl 模块中写一个 ResourceEndPoint 接口，平台会根据 ResourceEndPoint 接口自动生成 ResourceImpl！`

本目录结构为一个最小 springboot 模块，当多个模块组成一个大型单体应用时，模块中的所有组件和流程依然可以被读取到。
如果将 Model-impl，Model-api 同时作为依赖，提供给其他项目，则可视为提供了一个组件库。此时，Model-api 中定义的 Resource 可视为子流程，可以被其他项目的 ZjComponent 调用。

#### ZjComponent 组件接口

```java
@ZjComponentResource(group = "组件分组名")
public class Test {
    
    /**
	 * 组件注释说明（可以显示在开发工具中）
	 */
	@ZjComponentMapping("组件名称1")
	@ZjComponentExitPaths({ // 定义组件的出口
			@ZjComponentExitPath(target = "ok", description = "成功"),
			@ZjComponentExitPath(target = "fail", description = "失败")
	})
	public String testfun1(Object requestDTO, Object returnDTO, Object tempObj) {
	    return "ok";
	}

	/**
	 * 组件注释说明（可以显示在开发工具中）
	 */
	 @ZjComponentMapping(name = "组件名称2")
	 @ZjComponentExitPaths({
			@ZjComponentExitPath(target = "ok", description = "成功"),
			@ZjComponentExitPath(target = "fail", description = "失败")
	})
	public String testfun2(Object requestDTO, Object returnDTO, Object tempObj) {
        return "ok";
	}
}
```

#### 流程文件接口

```xml
<!--id：全局唯一，规则：模块name_任意有含义英文-->
<!--name：任意，可中文-->
<!--requestObject：请求对象-->
<!--returnObject：响应对象-->
<!--tempObject：存放临时数据的对象-->
<zj-orchestration id="" name="" 
                  requestObject="java.lang.String"
				  returnObject="com.alibaba.fastjson.JSONObject"
				  tempObject="xxxx"
				  transaction="">
	<!--type:开始 start，结束 end，java组件activity-->
	<!--流程开始时，流程引擎会创建一个 returnDTO 对象，一个 tempObj 对象，结合请求 Resource 的 requestDTO 对象。这三个对象在当前请求流程组件中传递-->
    <!--开始节点的id必须是 start -->
	<zj-component id="start" type="start" next="1"/>

	<!-- handler：对应到方法名，不用填参数-->
	<!-- id：文件内唯一 -->
	<zj-component handler="com.zjft.microservice.treasurybrain.tauro.component.Test.testfun1" id="1" type="activity">
		<exit path="ok" next="2"/>
		<exit path="fail" next="2"/>
	</zj-component>

	<zj-component handler="com.zjft.microservice.treasurybrain.tauro.component.Test.testfun2" id="2" type="activity">
		<exit path="ok" next="end"/>
		<exit path="fail" next="end"/>
	</zj-component>

</zj-orchestration>
```

#### Resource 接口

##### Spring MVC Resource interface

写在 api 模块内

```java
public interface XxxResource {
    String PREFIX = "${user-center:}/v2/user";

    @GetMapping(PREFIX + "/test1")
    @ZjWorkFlow(value = "id1 of flow")    
    ReturnDTO func1(AxxDTO axxDTO,BxxDTO bxxDTO);
    
    @PostMapping(PREFIX + "/test2")
    @ZjWorkFlow(value = "id2 of flow")    
    ReturnDTO func2(AxxDTO axxDTO,BxxDTO bxxDTO);
}
```

##### ZjWorkFlowEndpoint

写在 impl 模块内

```java
@ZjWorkFlowEndpoint
public interface XxxResourceEndpoint  extends XxxResource {

}
```