# Nginx-uWsgi-Flask-Supervisord-Redis-MySQL-Docker
## 部署架构:
```
.
├── README.md
├── docker-compose.yaml              # 使用docker-compose来编排部署
├── flask_app                        # 用于跑Flask应用的容器
│   ├── Dockerfile
│   └── wait_for_db_complete.sh
├── flask_app_code                   # 后端项目应用代码目
│   ├── LICENSE
│   ├── README.md
│   ├── app
│   ├── config.py
│   ├── manage.py
│   ├── requirements.txt
│   ├── screenshots
│   └── tests
├── nginx                            # Nginx用于前端接收用户请求的容器
│   └── nginx.conf
├── python27_baseenv                 # 基础Python环境镜像
│   ├── Dockerfile
│   └── README.md
├── supervisor                       # 用于管理uwsgi服务进程
│   └── supervisord.conf
└── uwsgi                            # 通过uWsgi来为Nginx-Flask牵线搭桥
    └── flask_uwsgi.ini
```

## 访问流程:
![](https://raw.githubusercontent.com/guomaoqiu/Nginx-uWsgi-Flask-Supervisord-Redis-MySQL-Docker/master/flask_app_code/screenshots/261529307197_.pic_hd.jpg)

## 部署步骤：

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


