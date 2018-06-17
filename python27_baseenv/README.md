该Dockerfile的目的是通过一个公共docker镜像alphine-python27做了一些特定的更改；
Python版本选择为: `2.7.14`
此处命名为：`python27_baseenv:latest`
公共库: `docker.io/guomaoqiu/python27_baseenv:latest`


进入基础目录
`docker build -t "python27_baseenv"`

