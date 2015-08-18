FROM totem/python-base:2.7-trusty-b3

ENV PYTHON_MAJOR_VERSION 2

ADD requirements.txt /opt/myapp/
RUN /bin/bash -c "pip${PYTHON_MAJOR_VERSION}  install -r /opt/myapp/requirements.txt"

ADD . /opt/myapp
WORKDIR /opt/myapp


EXPOSE 8080
CMD ["server.py"]
