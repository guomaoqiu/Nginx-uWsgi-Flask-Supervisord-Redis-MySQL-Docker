# Nginx-uWsgi-Flask-Supervisord-Redis-MySQL-Docker
之前使用Flask开发了两三个公司或个人使用的平台；在搭建过程当中如果换了环境的话比较麻烦；这次尝试放到docker里面去跑；下面是搭建的一个过程以及对于学习的一个记录🍺
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

* Nginx Web服务器层作为前端接收用户请求；
* uWSGI层作为Web服务器层与Web框架层Flask的一条纽带，将Web服务器层与Web框架连接起来
* 后端Web框架与数据层MySQL或Redis交互

### 简单理解起来就是酱紫的:
1. Nginx：Hey，WSGI，我刚收到了一个请求，我需要你作些准备，然后由Flask来处理这个请求。
2. WSGI：OK，Nginx。我会设置好环境变量，然后将这个请求传递给Flask处理。
3. Flask：Thanks WSGI！给我一些时间，我将会把请求的响应返回给你。
4. WSGI：Alright，那我等你。
5. Flask：Okay，我完成了，这里是请求的响应结果，请求把结果传递给Nginx。 WSGI：Good job！
6. Nginx，这里是响应结果，已经按照要求给你传递回来了。
7. Nginx：Cool，我收到了，我把响应结果返回给客户端。大家合作愉快~

## 搭建思路:
* Nginx 单独一个容器
* uWSGI+Flask 单独一个容器，其中uWSGI进程由Supervisor来管理
* MySQL 单独一个容器，数据目录挂载到宿主机
* Redis 单独一个容器

各个容器之间的关联通过docker-compose编排来实现


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
##### 运行状态
![](https://raw.githubusercontent.com/guomaoqiu/Nginx-uWsgi-Flask-Supervisord-Redis-MySQL-Docker/master/flask_app_code/screenshots/status.jpeg)
##### 登录
![](https://raw.githubusercontent.com/guomaoqiu/Nginx-uWsgi-Flask-Supervisord-Redis-MySQL-Docker/master/flask_app_code/screenshots/login.jpeg)
![](https://raw.githubusercontent.com/guomaoqiu/Nginx-uWsgi-Flask-Supervisord-Redis-MySQL-Docker/master/flask_app_code/screenshots/login_ok.jpeg)
![](https://raw.githubusercontent.com/guomaoqiu/Nginx-uWsgi-Flask-Supervisord-Redis-MySQL-Docker/master/flask_app_code/screenshots/status.jpeg)
![](https://raw.githubusercontent.com/guomaoqiu/Nginx-uWsgi-Flask-Supervisord-Redis-MySQL-Docker/master/flask_app_code/screenshots/status.jpeg)
![](https://raw.githubusercontent.com/guomaoqiu/Nginx-uWsgi-Flask-Supervisord-Redis-MySQL-Docker/master/flask_app_code/screenshots/status.jpeg)


