# Build custom R package

FROM centos:latest

MAINTAINER denis<denis_lton@hotmail.com>

# 安装高附加包源
RUN yum install -y epel-release

# set locales
RUN echo "LANG=en_US.utf8" >> /etc/locale.conf \
  && localedef -c -f UTF-8 -i en_US en_US.UTF-8 \
  && export LC_ALL=en_US.UTF-8

# install net tools
RUN yum install -y net-tools openssh which

# install R, # /usr/lib64/R
# ENV R_HOME="$(R RHOME)"
RUN yum -y install R-core R-core-devel R-java R-Rcpp \
  openssl-devel libcurl-devel R-littler R-littler-examples libRmath libRmath-devel \
  && export R_HOME="$(R RHOME)" \
  && echo 'options(repos=c(CRAN="https://mirrors.ustc.edu.cn/CRAN/", download.file="libcurl"))' >> ${R_HOME}/etc/Rprofile.site \
  && echo -e '\nexport R_HOME=$(R RHOME)' >> /etc/profile \
  && echo 'export PATH=$PATH:${R_HOME}/library/littler/examples' >> /etc/profile \
  && rm -rf /var/cache/yum

# 安装即使用install.r即可，默认安装目录/usr/local/lib/R/site-library，后续更新包也直接可以使用update.r

CMD ["/bin/bash"]

