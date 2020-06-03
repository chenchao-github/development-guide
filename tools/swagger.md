## swagger 使用说明

### DTO 对象注解示例：

```java
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

import java.io.Serializable;

@ApiModel(description= "返回响应数据")
public class RestMessage implements Serializable{

    @ApiModelProperty(value = "是否成功")
    private boolean success=true;
    @ApiModelProperty(value = "返回对象")
    private Object data;
    @ApiModelProperty(value = "错误编号")
    private Integer errCode;
    @ApiModelProperty(value = "错误信息")
    private String message;

    /* getter/setter */
}
```

### Resource（Controller）注解示例：

```java
@Api(value="用户controller",tags={"用户操作接口"})
@RestController
public interface UserResource {
     @ApiOperation(value="获取用户信息",tags={"获取用户信息"},notes="")
     @GetMapping("/getUserInfo")
     public User getUserInfo(@ApiParam(name="id",value="用户id",required=true) Long id,@ApiParam(name="username",value="用户名") String username);
}
```

## 注解说明：

> 这里只列举常用的注解，感兴趣的可以自行搜索详细教程

- @Api：用在 class 上，表示对类的说明
  
    tags="说明该类的作用，可以在UI界面上看到的注解"

- @ApiOperation：用在请求的 function 上，说明方法的用途、作用
  
    value="说明方法的用途、作用"

    notes="方法的备注说明"

- @ApiImplicitParams：用在请求的 function 上，表示一组参数说明
    
  - @ApiImplicitParam：用在 @ApiImplicitParams 注解中，指定一个请求参数的各个方面
        
        name：参数名

        value：参数的汉字说明、解释

        required：参数是否必须传

        paramType：参数放在哪个地方

            · header --> 请求参数的获取：@RequestHeader
            · query --> 请求参数的获取：@RequestParam
            · path（用于restful接口）--> 请求参数的获取：@PathVariable
            · body（不常用）
            · form（不常用）

        dataType：参数类型，默认String，其它值dataType="Integer"       
        defaultValue：参数的默认值

- @ApiResponses：用在请求的 function 上，表示一组响应
    
  - @ApiResponse：用在@ApiResponses中，一般用于表达一个错误的响应信息
        
        code：数字，例如400
        
        message：信息，例如"请求参数没填好"
        
        response：抛出异常的类

- @ApiModel：用于 DTO 上，表示一个返回响应数据的信息（这种一般用在post创建的时候，使用 @RequestBody 这样的场景，请求参数无法使用@ApiImplicitParam注解进行描述的时候）
    
  - @ApiModelProperty：用在属性上，描述响应类的属性


