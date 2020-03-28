FROM centos/httpd-24-centos7
COPY website /var/www/html/
EXPOSE 80
