#镜像定义
FROM alpine

#作者声明
MAINTAINER guomaoqiu<guomaoqiu@sina.com>

# 按需安装
RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.4/main" > /etc/apk/repositories \
  &&  apk add --update linux-headers htop python bash git python-dev mysql-client py-pip mysql-dev build-base jpeg-dev zlib-dev \
  freetype-dev lcms2-dev openjpeg-dev tiff-dev tk-dev tcl-dev \
  && pip install -i https://pypi.douban.com/simple --upgrade pip \
  && rm -rf /var/cache/apk/*  \
  && ln -sv /usr/include/locale.h /usr/include/xlocale.h


