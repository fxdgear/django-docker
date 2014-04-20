FROM ubuntu:13.10
MAINTAINER Nick Lang "nick@nicklan.com"
#RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get -qq update
RUN apt-get upgrade -y
RUN apt-get install -y openssh-server supervisor python-dev python-setuptools git-core

RUN mkdir /var/run/sshd 
RUN echo 'root:treadhub' |chpasswd

RUN easy_install pip
RUN pip install virtualenv
RUN pip install uwsgi
RUN virtualenv --no-site-packages /opt/ve/treadhub

VOLUME ["/opt/apps/treadhub"]

ADD requirements.txt /opt/apps/treadhub/requirements.txt
ADD .docker/supervisor.conf /opt/supervisor.conf
ADD .docker/run.sh /usr/local/bin/run
RUN /opt/ve/treadhub/bin/pip install -r /opt/apps/treadhub/requirements.txt

EXPOSE 8000 22

CMD ["/bin/sh", "-e", "/usr/local/bin/run"]
