#FROM registry.access.redhat.com/openshift3/nodejs-010-rhel7
FROM ryanj/centos7-s2i-nodejs:5.12.0

ADD . /opt/app-root/src/

EXPOSE 8080

ENV BACKEND_URL="cdservice"

# The CMD. We do the following here:
#  - Start the server via npm start.
USER root
RUN cd public \
  && sed -i.orig service.json -e 's|URL|'"$BACKEND_URL"'|' \
  && cd ..

CMD /bin/bash -c 'npm start'