## Jmeter

#### 官方文档
https://jmeter.apache.org/usermanual/get-started.html

#### 开始使用

https://blog.csdn.net/A_Runner/article/details/89001160

https://www.cnblogs.com/stulzq/p/8971531.html

https://blog.csdn.net/m0_37529303/article/details/75453230

https://blog.csdn.net/kindy1022/article/details/6826891

https://blog.51cto.com/ydhome/1869970

#### 正则表达式提取器

https://www.cnblogs.com/hai-yang/p/9565483.html

http://www.ishenping.com/ArtInfo/345050.html

#### 测试片段

https://blog.csdn.net/swtesting/article/details/84647999

#### 新增用户参数、文件读取数据、数据库读取数据

https://blog.csdn.net/cdw8131197/article/details/83752264

#### 添加图表插件

https://www.jianshu.com/p/0e6bf15b3ffa

#### 生成测试报告

https://www.jianshu.com/p/673766f12ed2

https://www.jianshu.com/p/4f32918d66bb

https://www.cnblogs.com/wangiqngpei557/p/7953453.html

#### 脚本执行

```cmd

PS E:\apache-jmeter-5.1.1\bin> .\jmeter -n -t brain.jmx -l brain.jtl
Creating summariser <summary>
Created the tree successfully using brain.jmx
Starting the test @ Wed Aug 21 17:10:16 CST 2019 (1566378616648)
Waiting for possible Shutdown/StopTestNow/HeapDump/ThreadDump message on port 4445
summary +    316 in 00:00:13 =   23.5/s Avg:  2415 Min:    37 Max:  7081 Err:    35 (11.08%) Active: 84 Started: 100 Finished: 16
summary +    284 in 00:00:10 =   27.9/s Avg:  3475 Min:    74 Max: 16370 Err:    11 (3.87%) Active: 0 Started: 100 Finished: 100
summary =    600 in 00:00:24 =   25.4/s Avg:  2917 Min:    37 Max: 16370 Err:    46 (7.67%)
Tidying up ...    @ Wed Aug 21 17:10:40 CST 2019 (1566378640620)
... end of run
```

```bash
jmeter -n -t [jmx file] -l [result file] -e -o [Path to output folder]

JMeter 默认去当前目录寻找脚本文件，并把日志记录在当前目录，当然也可以使用绝对路径来执行

jmx file：测试计划的文件名称
result file：输出文件路径，可以是结果日志名称
Path to output folder：要保存的report文件路径

-n：非GUI模式执行JMeter
-t：执行测试文件所在的位置
-l：指定生成测试结果的保存文件，jtl文件格式
-e：测试结束后，生成测试报告
-o：指定测试报告的存放位置
```


```bash
nohup ./jmeter.sh -n -t ./brain_24h.jmx -l ./brain_24h.jtl -e -o ./report_24h > nohup_24h.out &
```

#### 脚本录制

略