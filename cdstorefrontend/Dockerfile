FROM ryanj/centos7-s2i-nodejs:5.12.0

ADD . /opt/app-root/src/

EXPOSE 8080

USER root
# Change permissions to allow to modify the service.json file
RUN chmod -R 777 /opt/app-root/src/


#ENV BACKEND_URL="http://cdservice-snowcamp.192.168.99.102.xip.io/rest/catalogs/"

# The CMD. We do the following here:
#  - Start the server via npm start.
# USER root
# RUN cd public \
#   && sed -i.orig service.json -e 's|URL|'"${BACKEND_URL}"'|' \
#   && cd ..

CMD /bin/bash -c 'npm start'