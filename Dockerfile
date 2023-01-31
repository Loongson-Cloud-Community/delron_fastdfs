FROM cr.loongnix.cn/loongson/loongnix-server:8.3
LABEL org.label-schema.schema-version==1.0     org.label-schema.license=GPLv2  
CMD ["/bin/bash"]
LABEL maintainer=qiangxuhui@loongson.cn
ENV FASTDFS_PATH=/opt/fdfs FASTDFS_BASE_PATH=/var/fdfs PORT= GROUP_NAME= TRACKER_SERVER=
RUN /bin/sh -c "dnf install -y wget zlib zlib-devel pcre pcre-devel gcc gcc-c++ openssl openssl-devel libevent libevent-devel perl unzip net-tools git make"
RUN /bin/sh -c "mkdir -p ${FASTDFS_PATH}/libfastcommon  && mkdir -p ${FASTDFS_PATH}/fastdfs  && mkdir ${FASTDFS_BASE_PATH}"
WORKDIR /opt/fdfs/libfastcommon
# 这里需要修改为add libfastcommon
ADD source/libfastcommon-1.0.36.tar.gz ${FASTDFS_PATH}
RUN ./make.sh  && ./make.sh install  && rm -rf ${FASTDFS_PATH}/libfastcommon
WORKDIR /opt/fdfs/fastdfs
# 这里需要修改为add fastdfs
ADD source/fastdfs-5.11.tar.gz ${FASTDFS_PATH}
RUN ./make.sh  && ./make.sh install  && rm -rf ${FASTDFS_PATH}/fastdfs
EXPOSE 22122 23000 8080 8888
VOLUME ["/var/fdfs", "/etc/fdfs"]
RUN mkdir -p /tmp/nginx 
ADD source/nginx-1.12.2.tar.gz /tmp/nginx
# 这里需要知晓文件的类型, 应该就是fastdfs-nginx-module
COPY source/fastdfs-nginx-module-master.zip /tmp/nginx/ 
RUN /bin/sh -c "unzip /tmp/nginx/fastdfs-nginx-module-master.zip -d /tmp/nginx/"
WORKDIR /tmp/nginx/nginx-1.12.2
RUN ./configure --prefix=/usr/local/nginx --add-module=/tmp/nginx/fastdfs-nginx-module-master/src && make && make install
# 添加fdfs的配置文件
COPY conf/fdfs /etc/fdfs/ 
#RUN grep -rn "thread_stack" /etc/fdfs/
# 添加nginx全量配置文件
COPY conf/nginx /usr/local/nginx/conf/ 
RUN ls -al /usr/local/nginx/conf
# 不知道拷贝的是什么了, 应该是start
COPY start1.sh /usr/bin/ 
RUN chmod 777 /usr/bin/start1.sh
ENTRYPOINT ["/usr/bin/start1.sh"]
CMD ["tracker"]
