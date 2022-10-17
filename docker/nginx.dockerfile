FROM nginx:stable-alpine

COPY ./nginx/conf.d/*.conf /etc/nginx/conf.d/

COPY ./nginx/*.conf /etc/nginx/

RUN mkdir -p /etc/nginx/ssl

COPY ./nginx/ssl /etc/nginx/ssl