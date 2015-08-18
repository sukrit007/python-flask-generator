FROM totem/python-base:2.7-trusty-b3

ENV PYTHON_MAJOR_VERSION 3

ADD requirements.txt /opt/python-demo/
RUN /bin/bash -c "pip${PYTHON_MAJOR_VERSION}  install -r /opt/python-demo/requirements.txt"

ADD . /opt/python-demo
WORKDIR /opt/python-demo


EXPOSE 8090
CMD ["server.py"]
