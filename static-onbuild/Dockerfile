FROM nginx:alpine
MAINTAINER Octoblu <docker@octoblu.com>

HEALTHCHECK CMD curl --fail http://localhost:80/healthcheck || exit 1

WORKDIR /usr/src/app

RUN apk add --no-cache bash ca-certificates curl

COPY templates/* /etc/nginx/conf.d/
COPY run-nginx.sh /usr/src/app

ONBUILD COPY . /usr/src/app
ONBUILD RUN cat package.json \
      | grep version \
      | head -1 \
      | awk -F: '{ print $2 }' \
      | sed 's/[",]//g' \
      | tr -d '[[:space:]]' > .PKG_VERSION

ONBUILD RUN sed -e \
  "s/PKG_VERSION/$(cat .PKG_VERSION)/" \
  /etc/nginx/conf.d/default.template > \
  /etc/nginx/conf.d/default.conf && \
  rm -f /etc/nginx/conf.d/default.template

CMD [ "./run-nginx.sh" ]
