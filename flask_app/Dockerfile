#镜像定义
FROM python27_baseenv

# 作者声明
MAINTAINER guomaoqiu<guomaoqiu@sina.com>

# 应用工作目录
WORKDIR /opt/project/app_code

# 拷贝
COPY ./flask_app_code/requirements.txt $WORKDIR
 
# 安装应用第三方依赖软件
RUN pip install --no-cache-dir -i https://pypi.douban.com/simple -r requirements.txt

