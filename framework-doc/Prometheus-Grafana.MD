## Prometheus

```bash
# 官方文档
https://prometheus.io/docs/introduction/overview/

# 中文资料
https://www.bookstack.cn/read/prometheus-book/quickstart-why-monitor.md

# 官网下载tar.gz包
tar zxf prometheus-2.13.1.linux-amd64.tar.gz

# 编辑prometheus.yml文件，增加以下配置

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
    - targets: ['localhost:9000']    # prometheus的ip和port

  - job_name: 'spring-actuator'
    metrics_path: '/actuator/prometheus'
    scrape_interval: 5s
    static_configs:
    - targets: ['10.2.214.97:8080']  # 后端应用ip和port

# 后端应用增加依赖

`implementation 'io.micrometer:micrometer-registry-prometheus'`


# 启动
cd prometheus-2.13.1.linux-amd64 
./prometheus  --web.listen-address=:9000 --config.file=prometheus.yml

# 其他
ui：http://10.34.12.164:9000
数据过期清理时间，默认保存15天：--storage.tsdb.retention.time
本地磁盘空间做容量规划公式：磁盘大小 = 保留时间 * 每秒获取样本数 * 样本大小

# 手动刷新prometheus config ：
    # 第一种，向prometheus进行发信号
    kill -HUP  pid
    
    # 第二种，向prometheus发送HTTP请求
    # /-/reload只接收POST请求，并且需要在启动prometheus进程时，指定 --web.enable-lifecycle
    curl -XPOST http://prometheus.chenlei.com/-/reload



```


```bash
# 下载redis端点
https://github.com/oliver006/redis_exporter/releases

tar zxf redis_exporter-v1.3.3.linux-amd64.tar.gz
cd edis_exporter-v1.3.3.linux-amd64
nohup ./redis_exporter  -redis.addr 0.0.0.0:6379  -redis.password root &

# 下载node端点
略
```




## Grafana


```bash

# 官网下载tar.gz包
tar zxf grafana-6.4.3.linux-amd64.tar.gz

# 修改默认的启动端口
vim conf/defaults.ini

# 启动
cd grafana-6.4.3
./bin/grafana-server

# 搜索模板
https://grafana.com/grafana/dashboards

```