FROM centos:7
WORKDIR /usr/local/src/
RUN set -uex; \
     yum -y install wget make perl  gcc-c++ libevent; \
     wget -O libfastcommon-1.0.39.tar.gz  https://codeload.github.com/happyfish100/libfastcommon/tar.gz/V1.0.39; \
     tar -zxvf libfastcommon-1.0.39.tar.gz; \
     rm -f libfastcommon-1.0.39.tar.gz; \
     cd libfastcommon-1.0.39 ;\
     ./make.sh ;\
     ./make.sh install
WORKDIR /usr/local/src/
RUN set -uex; \
     wget -O fastdfs-5.11.tar.gz https://codeload.github.com/happyfish100/fastdfs/tar.gz/V5.11 ;\
     tar -zxvf fastdfs-5.11.tar.gz ;\
     cd fastdfs-5.11/ ;\
     ./make.sh ;\
     ./make.sh install
# to install nginx
WORKDIR /usr/local/src/
RUN set -uex; \
    yum install -y  gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl—devel initscripts ;\
    wget http://nginx.org/download/nginx-1.16.1.tar.gz ;\
    tar xf nginx-1.16.1.tar.gz ;\
    mv nginx-1.16.1 nginx ;\
    cd nginx ;\
    ./configure --prefix=/usr/local/nginx ;\
    make && make install
#to set config
WORKDIR /usr/local/src/
RUN set -eux ; \
    wget https://github.com/happyfish100/fastdfs-nginx-module/archive/5e5f3566bbfa57418b5506aaefbe107a42c9fcb1.zip ;\
    yum -y install unzip ;\
    unzip 5e5f3566bbfa57418b5506aaefbe107a42c9fcb1.zip ;\
    mv fastdfs-nginx-module-5e5f3566bbfa57418b5506aaefbe107a42c9fcb1 fastdfs-nginx-module ;\
    cd /usr/local/src/nginx ;\
    ./configure --add-module=/usr/local/src/fastdfs-nginx-module/src ;\
    make ;\
    make install
RUN set -eux ;\
    cd /etc/fdfs ;\
    cp client.conf.sample client.conf ;\
    cp storage.conf.sample storage.conf ;\
    cp tracker.conf.sample tracker.conf
#set ENTRYPOINT
# data dir /home/yuqing/fastdfs
RUN mkdir -p /home/yuqing/fastdfs
WORKDIR /
ADD entrypoint.sh ./
COPY nginx.conf /usr/local/nginx/conf/nginx.conf
RUN cp /usr/local/src/fastdfs-nginx-module/src/mod_fastdfs.conf /etc/fdfs/
RUN cp /usr/local/src/fastdfs-5.11/conf/{http.conf,mime.types} /etc/fdfs/

RUN chmod +x entrypoint.sh
CMD ["./entrypoint.sh"]