# Nginx-uWsgi-Flask-Supervisord-Redis-MySQL-Docker

##### 0.安装docker环境
```
cd /etc/yum.repos.d/
wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum install -y docker-ce docker-compose
systemctl start docker
```

##### 1.构建python 基础运行环境，基于alpine镜像
```
cd Nginx-uWsgi-Flask-Supervisord-MySQL-Docker-K8S
docker build -f python27_baseenv/Dockerfile . -t python27_baseenv
```

##### 2.构建安装应用依赖包
```
cd Nginx-uWsgi-Flask-Supervisord-MySQL-Docker-K8S
docker build -f flask_app/Dockerfile . -t flask_app
```

##### 3.执行docker-compose
```
cd Nginx-uWsgi-Flask-Supervisord-MySQL-Docker-K8S
docker-compose up
```

flask_app_code 是Flask框架应用代码,单独管理，这里通过数据卷挂载到了容器
