# Based on helder/kibana
FROM nginx:1.7
MAINTAINER kotter (kotter9@gmail.com

# Install htpasswd utility and curl
RUN apt-get update \
    && apt-get install -y curl apache2-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Kibana
ENV KIBANA_VERSION 4.0.0
RUN mkdir -p /var/www \
 && curl -s https://download.elastic.co/kibana/kibana/kibana-$KIBANA_VERSION-linux-x64.tar.gz \
  | tar --transform "s/^kibana-$KIBANA_VERSION/kibana/" -xvz -C /var/www

# Add default credentials
RUN htpasswd -cb /etc/nginx/.htpasswd kibana "docker"

# Copy Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Set wrapper for runtime config
COPY init.sh /init
RUN chmod -R 0775 /init
ENTRYPOINT ["/init"]

# Run nginx
CMD ["nginx", "-g", "daemon off;"]
