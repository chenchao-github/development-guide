## 字节码操作框架选型

https://github.com/akullpp/awesome-java

动态代理在RPC框架中的性能对比

https://xiangshouxiyang.iteye.com/blog/2377664

#### asm
    
    是字节码解析器，而不是代码生成库。为了使用字节码，您需要对字节码的工作原理有一个清晰的概念。
    而且，这些库允许您创建“未经验证的代码”，也就是说，您必须手工完成大量工作。
    Byte Buddy本身构建在ASM之上，如果需要，甚至可以将ASM代码插入Byte Buddy。
    
#### cglib
    
    允许为重写的类注册回调，类似于JDK代理。但是，这要求所有的类加载器都知道cglib，
    如果它们想知道这些cglib代理是cglib特定类型的，就必须硬编码到任何生成的类中。
    此外，cglib只允许子类化，但不允许重新创建现有类。
    此外，回调要求对任何参数进行装箱，并将这些装箱后的值注册到数组中。
    事实证明，cglib对即时编译器并不十分友好。
    
#### javaassit

    接受包含Java代码的字符串，并在运行时编译这些字符串。这使得它易于使用，因为每个Java开发人员都知道Java。
    不幸的是，javassist编译器远远落后于实际的javac编译器。
    例如，它不支持泛型，甚至不支持自动装箱，更不用说lambda表达式了。
    而且，字符串不是类型安全的，这使得javassist代码很容易出错。
    这相当于将SQL字符串组合在一起，存在所有的风险，比如外来代码注入。

#### byte buddy  [文档](http://bytebuddy.net)
    
    使用注解或类型安全的DSL，并主要基于委托给用户代码来实现其插装。
    通过这种方式，您可以在任何JVM语言中实现拦截器，并避免在生成的类中依赖于Byte Buddy
    (幸运的是，如果注解不能在加载时解析，JVM类加载器将忽略它们)。
    例如，这使得异常堆栈跟踪比使用“字符串代码”时更好。
    而且，Byte Buddy通过为拦截器创建更智能的对象来避免装箱，它只创建那些被带注解的参数usin请求的拦截器




## JSR 269 注解处理器


#### ADT4J 
    
    https://github.com/sviperll/adt4j
    
    用于代数数据类型的JSR-269代码生成器。
    
#### immutables 
    
    Java注释处理器生成简单、安全和一致的值对象。
    
    
#### lombok

    例子：https://liuyehcf.github.io/2018/02/02/Java-JSR-269-%E6%8F%92%E5%85%A5%E5%BC%8F%E6%B3%A8%E8%A7%A3%E5%A4%84%E7%90%86%E5%99%A8/

    基于JSR-269 注解处理器，修改字节码
    

#### mapstruct

    基于JSR-269 注解处理器，生成子类代码




