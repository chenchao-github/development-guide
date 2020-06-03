## 业务编排文件接口（旧设计方案-归档）

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
        resource
            workflow
                xxxxx1.xml
                xxxxx2.xml
                ...
```

只需要声明 Resource 接口，如果该 Resource 会被别的模块访问到，则还要声明 ResourceClient，以便在微服务模式下能够夸服务访问到。
`ResourceImpl 不需要编写，平台会根据 Resource 接口自动生成！`

本目录结构为一个最小 springboot 模块，当多个模块组成一个大型单体应用时，模块中的所有组件和流程依然可以被读取到。
如果将 Model-impl，Model-api 同时作为依赖，提供给其他项目，则可视为提供了一个组件库。此时，Model-api 中定义的 Resource 可视为子流程，可以被其他项目的 ZjComponent 调用。

#### 组件接口

```java
package com.zjft.microservice.treasurybrain.tauro.component;

import java.util.Map;

/**
 * @author cwang
 */
@ZjComponentResource("组件分组名")
public class Test {

	@ZjComponentMapping("组件名称")
	@ZjComponentExitPaths({ // 定义组件的出口
			@ZjComponentExitPath(target = "ok", description = "成功"),
			@ZjComponentExitPath(target = "fail", description = "失败")
	})
	// TODO 声明 map 类型参数的格式
	//@ZjParams({
	//		@ZjParam()
	//})
	/**
	 * 组件注释说明（可以显示在开发工具中）
	 */
	public DTO testfun(Wfdata wfdata, 
					   @ZjParam("TheParamName") Map map,
					   AxxDTO axxDTO,
					   BxxDTO bxxDTO,
					   @ZjParam("userID") String str) {

	}

	/**
	 * 组件注释说明（可以显示在开发工具中）
	 */
	 @ZjComponentMapping(name = "组件名称2")
	 @ZjComponentExitPaths({
			@ZjComponentExitPath(target = "ok", description = "成功"),
			@ZjComponentExitPath(target = "fail", description = "失败")
	})
	public DTO testfun2(Wfdata wfdata) {

	}
}



```

#### 流程文件接口

```xml
<!--id：当前模块内唯一-->
<!--name：任意，可中文-->
<!--return-obj: 整个流程返回的POJO对象-->
<zj-orchestration id="" name="" return-obj="com.zjft.microservice.treasurybrain.tauro.dto.ReturnDTO">
	<!--type:开始 start，结束 end，java组件activity-->
	<!--流程开始时，流程引擎会创建一个数据对象 data，该对象在当前请求流程中传递数据-->
	<!--data 对象中的数据分为 variable 和 response 两大类 -->
	<!-- variable 用于存放 Resource 接口的请求参数，以及后续流程运行过程中产生的临时数据 -->
	<!-- response 用于存放 需要返回 的数据，response 中的数据会在 流程结束时，自动映射到 ReturnDTO 中，因此应当保证 response 与 ReturnDTO 的结构一致 -->
	<zj-component oid="0" type="start">
		<exitpath>
			<target CONDITION="ok" to="1"/>
		</exitpath>
	</zj-component>

	<!-- handler：对应到方法名，不用填参数-->
	<!-- oid：文件内唯一 -->
	<zj-component handler="com.zjft.microservice.treasurybrain.tauro.component.Test.testfun" oid="1" type="activity">
		<!-- 组件执行时， data 对象会被自动传入，所以 function 的参数之一应当为 WFData -->
		<!-- WFData 中包含 variable 和 response 两大类，均可读写。 TODO：response 可以转为 ReturnDTO 以便编码访问 -->
		<!-- TODO：params参数：除了 WFData 以外，function 也可传入其他自定义对象做为参数，这些对象的数据源来自 WFData 中的 variable，response 或者是常量 -->
		<params>
			<!-- 将 variable，常量，或者 response 中数据映射到 HashMap 对象 -->
			<param obj="java.util.HashMap">
				<!-- property="a" 表示 key 为 a 的 map 元素 -->
				<!-- type: 可以是 Integer，String，Boolean 等常量类型，也可以是 variable，response -->
				<!-- from: 取数据的路径，如果是常量则是常量值本身的字符串形式 -->
				<mapping property="a" type="variable" from="a"/>
				<mapping property="b" type="Integer" from="2"/>
				<mapping property="c" type="String" from="字符串"/>
				<mapping property="c" type="response" from="a"/>
			</param>

			<!-- 创建一个 AxxDTO，将 variable，常量，或者 response 中数据一个个映射到 DTO 对象中 -->
			<param obj="com.zjft.microservice.treasurybrain.tauro.dto.AxxDTO">
				<mapping property="a" type="variable" from="a"/>
				<mapping property="b" type="Integer" from="2"/>
				<mapping property="c" type="String" from="字符串"/>
				<mapping property="d" type="response" from="a"/>
			</param>

			<!-- 创建一个 BxxDTO，将 variable，常量，或者 response 中数据 from-obj 下的数据自动映射到 BxxDTO 对象中 -->
			<!-- 如果 type 是常量类型，则 from-obj 可以是一个 json 字符串，或者是常量值，根据 BxxDTO 类型，自动识别并处理 -->
			<!-- from-obj 下的类型必须与 BxxDTO 一致，才能映射成功 -->
			<param obj="com.zjft.microservice.treasurybrain.tauro.dto.BxxDTO" type="variable" from-obj="reqeust.user"/>
			<param obj="java.lang.String" type="String" from="userID"/>
		</params>

		<exits>
			<exit path="ok" to="2">
				<!-- TODO：return参数: 允许在组件执行完成时，进行一些数据映射操作 -->
				<return>
					<!-- scope：映射目标，可以是 variable 和 response -->
					<!-- property：目标路径 -->
					<!-- type：数据来源类型，可以是 常量，variable 和 response -->
					<!-- from：数据来源路径 -->
					<mapping scope="variable" property="a" type="variable" from="b"/>
					<mapping scope="variable" property="b" type="String" from="字符串"/>
					<mapping scope="response" property="a" type="variable" from="a"/>
					<mapping scope="response" property="b" type="variable" from="b"/>
				</return>
			</exit>
			<exit path="fail" to="2"/>
		</exits>
	</zj-component>

	<zj-component handler="com.zjft.microservice.treasurybrain.tauro.component.Test.testfun2" oid="2" type="activity">
		<exits>
			<exit path="ok" to="3"/>
			<exit path="fail" to="3"/>
		</exits>
	</zj-component>

	<!-- end组件执行时，会将 response 中的数据自动映射到 ReturnDTO 中 -->
	<!-- TODO： 如果 end 组件配置了参数，则可在自动映射完成后，根据参数再映射一部分字段 -->
	<zj-component oid="3" type="end"/>

</zj-orchestration>
```

#### Resource 接口

```java
@ZjOrcheStrationResource
public interface XxxResource {
    
    @ZjOrcheStration("id1 of flow")    
    ReturnDTO func1(AxxDTO axxDTO,BxxDTO bxxDTO);
    
    @ZjOrcheStration("id2 of flow")    
    ReturnDTO func2(AxxDTO axxDTO,BxxDTO bxxDTO);
}
```