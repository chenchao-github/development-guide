#### 认证中心设计

    auth-admin中，使用Spring Security + OAuth2 + JWT 完成了登录和鉴权功能
    1）登录认证
        通过 [OAuth2-密码模式] 进行登录 获取JWT格式的Token作为用户身份令牌
        新用户密码在前端进行MD5加密，在后端使用Bcrypt强哈希后存入数据库
        目前JWT使用的默认加密方式，没有使用非对称方式
        登录成功后，用户的session会被security存入redis
        所有的请求都要认证，可以配置免认证的URL，主要包括登录认证和token认证
    2）鉴权
        对后端接口进行请求时，用户Token放在请求头的Authrization字段中
        用户可以有多个角色，每个角色对应了一部分叶子菜单（菜单是一棵树），叶子菜单下有对应的接口
        角色与接口的映射在auth-admin中是一个map
        分布式模式下，auth-admin模块只做认证，网关做鉴权，此时map存入redis中
        用户分配角色，角色勾选叶子菜单，叶子菜单下映射N个接口
    
细节请参考：[http://ubuntu/microservice/infrastructure/tree/develop/zj-auth-admin](http://ubuntu/microservice/infrastructure/tree/develop/zj-auth-admin)
