之前使用Flask开发了两三个公司或个人使用的平台；在搭建过程当中如果换了环境的话比较麻烦；这次尝试放到docker里面去跑；下面是搭建的一个过程以及对于学习的一个记录，此次web框架还是使用的之前用Flask写的一个基础后台。
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
1. `Nginx`：Hey，WSGI，我刚收到了一个请求，我需要你作些准备，然后由Flask来处理这个请求。
2. `WSGI`：OK，Nginx。我会设置好环境变量，然后将这个请求传递给Flask处理。
3. `Flask`：Thanks WSGI！给我一些时间，我将会把请求的响应返回给你。
4. `WSGI`：Alright，那我等你。
5. `Flask`：Okay，我完成了，这里是请求的响应结果，请求把结果传递给Nginx。 
6. `WSGI`：Good job！ Nginx，这里是响应结果，已经按照要求给你传递回来了。
7. `Nginx`：Cool，我收到了，我把响应结果返回给客户端。大家合作愉快~

## 搭建思路:
* Nginx 单独一个容器
* uWSGI+Flask 单独一个容器，其中uWSGI进程由Supervisor来管理
* MySQL 单独一个容器，数据目录挂载到宿主机
* Redis 单独一个容器

各个容器之间的关联通过docker-compose编排来实现


## 部署步骤：
主要还是通过编写Dockerfile来定制特定的运行环境镜像

##### 0.安装docker环境
```
cd /etc/yum.repos.d/
wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum install -y docker-ce docker-compose
systemctl start docker
```

##### 1.构建python基础运行环境镜像，基于alpine镜像
```
cd Nginx-uWsgi-Flask-Supervisord-Redis-MySQL-Docker
docker build -f python27_baseenv/Dockerfile . -t python27_baseenv
```

##### 2.构建Flask应用框架运行所需依赖包镜像
```
cd Nginx-uWsgi-Flask-Supervisord-Redis-MySQL-Docker
docker build -f flask_app/Dockerfile . -t flask_app
```
##### 4.Nginx镜像使用默认，配置文件需要修改，这里通过挂载方式

##### 5.Redis镜像使用默认的

##### 6.执行docker-compose
```
cd Nginx-uWsgi-Flask-Supervisord-Redis-MySQL-Docker
docker-compose up
```
#### 运行状态
![](https://raw.githubusercontent.com/guomaoqiu/Nginx-uWsgi-Flask-Supervisord-Redis-MySQL-Docker/master/flask_app_code/screenshots/status.jpeg)
#### 登录
![](https://raw.githubusercontent.com/guomaoqiu/Nginx-uWsgi-Flask-Supervisord-Redis-MySQL-Docker/master/flask_app_code/screenshots/login.jpeg)
#### 用户注册
![](https://raw.githubusercontent.com/guomaoqiu/Nginx-uWsgi-Flask-Supervisord-Redis-MySQL-Docker/master/flask_app_code/screenshots/login_unconfiremd.jpeg)
![](https://raw.githubusercontent.com/guomaoqiu/Nginx-uWsgi-Flask-Supervisord-Redis-MySQL-Docker/master/flask_app_code/screenshots/email.jpeg)
![](https://raw.githubusercontent.com/guomaoqiu/Nginx-uWsgi-Flask-Supervisord-Redis-MySQL-Docker/master/flask_app_code/screenshots/login_ok.jpeg)
![](https://raw.githubusercontent.com/guomaoqiu/Nginx-uWsgi-Flask-Supervisord-Redis-MySQL-Docker/master/flask_app_code/screenshots/db.jpeg)
#### Flask应用的访问、登录、注册过程日志
##### Nginx
![](https://raw.githubusercontent.com/guomaoqiu/Nginx-uWsgi-Flask-Supervisord-Redis-MySQL-Docker/master/flask_app_code/screenshots/nginxlog.jpeg)
##### uWSGI
![](https://raw.githubusercontent.com/guomaoqiu/Nginx-uWsgi-Flask-Supervisord-Redis-MySQL-Docker/master/flask_app_code/screenshots/uwsgilog.jpeg)


## 部署总结:
部署过程中，感觉在宿主机中部署还是没多大的区别，差别可能是在效率上面。宿主机中不能影响系统自带的一些东西，比如python的版本，这时候可能就需要用到virtualenv, 如果服务器迁移了那整个环境就需要重新搭建，还是不太方便。

此次部署呢主要目的还是以这个为一个实践目标去学习docker的compose文件编写，再把各个工具结合在一起跑在docker中实现之前在宿主机中的东西；其实把整个流程梳理清楚后编写yaml文件也很快的。后续尝试放到k8s集群中跑🍺🍺🍺

在我的VPS上面跑起来了... 	

<a href="http://66.112.211.178:8090" target="_blank">
  <img src="https://img.alicdn.com/tfs/TB12GX6zW6qK1RjSZFmXXX0PFXa-744-122.png" width="180" />
</a>
