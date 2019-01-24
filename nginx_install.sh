#!/bin/bash

#指定nginx版本号
NGINX_VERSION=nginx-1.12.2
#指定nginx安装目录
NGINX_HOME=/usr/local/nginx
#指定工作目录路径
WORK_DIR=$PWD/$NGINX_VERSION
#安装编译工具和依赖库
yum install -y gcc wget gcc-c++ make openssl openssl-devel pcre pcre-devel zlib libxml2 libxml2-devel libxslt-devel
获取nginx源码包
wget https://nginx.org/download/$NGINX_VERSION.tar.gz
#解压安装包
tar -zxf $NGINX_VERSION.tar.gz 
#进入工作目录
cd $WORK_DIR
#执行预编译
./configure \
  --prefix=$NGINX_HOME \
  --user=nginx --group=nginx \
  --without-select_module \
  --without-poll_module \
  --with-debug \
  --with-http_ssl_module \
  --with-http_realip_module \
  --with-http_addition_module \
  --with-http_sub_module \
  --with-http_dav_module \
  --with-http_flv_module \
  --with-http_xslt_module \
  --with-http_gzip_static_module \
  --with-http_random_index_module \
  --with-http_secure_link_module \
  --with-http_degradation_module \
  --with-http_stub_status_module \
  --sbin-path=/usr/sbin/  \
  --with-cc=`which gcc`
#编译，启用多核心编译
make -j $(cat /proc/cpuinfo |grep processor |wc -l)
#编译安装
make install
#删除解压后的源码目录
rm -rf $WORK_DIR
#检查是否有nginx用户
id nginx | 2&>/dev/null
#如果没有nginx用户，则创建一个nginx的用户，shell类型为非登录shell
if [ $? -ne 0 ]
then
	useradd -M -s /sbin/nologin nginx
fi
