# Redis

下载安装：

1. cd /opt
2. wget http://download.redis.io/releases/redis-5.0.5.tar.gz
3. tar xzf redis-5.0.5.tar.gz
4. cd redis-5.0.5
5. make
6. mkdir data
7. 拷贝下列文件到 /opt/redis-5.0.5 目录中并覆盖：[redis.conf](./resource/redis.conf)，[redis.sh](./resource/redis.sh)
8. chmod 750 redis.sh

启动：

1. /opt/redis-5.0.5/redis.sh start

注意：

1. redis.conf 中设置的 redis 密码为 root，可根据需要自行修改