FROM node:12.16-alpine

COPY . /app

WORKDIR /app
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories
RUN apk upgrade --update
RUN apk add bash git ca-certificates 
RUN npm config set registry https://registry.npm.taobao.org
RUN npm install -g bower patch-package 
RUN npm --unsafe-perm --production install
RUN apk del git
RUN rm -rf /var/cache/apk/* \
    /app/.git \
    /app/screenshots \
    /app/test
RUN adduser -H -S -g "Konga service owner" -D -u 1200 -s /sbin/nologin konga \
    && mkdir /app/kongadata /app/.tmp \
    && chown -R 1200:1200 /app/views /app/kongadata /app/.tmp       


EXPOSE 1337

VOLUME /app/kongadata

ENTRYPOINT ["/app/start.sh"]
