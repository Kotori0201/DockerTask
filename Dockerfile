FROM ubuntu:20.04
 
WORKDIR /home/do1/workdir/
 
LABEL env="stg" \
    name="service-test" \
    team="do1"
 
ENV DEVOPS="This is DO1 team"
 
RUN apt-get update && \
    apt-get install -y nginx curl && \
    rm -rf /var/lib/apt/lists/*
 
RUN touch /etc/nginx/sites-available/newsite
 
COPY nginx.conf /etc/nginx/sites-available/newsite
 
RUN ln -s /etc/nginx/sites-available/newsite /etc/nginx/sites-enabled/
 
RUN touch /var/log/nginx/access.log /var/log/nginx/error.log
 
RUN mkdir /home/devops2023
 
# create the server folder with arbitrary content
RUN echo '<html><head><title>Welcome!</title></head><body><h1>Hello DO1 team from Kotori</h1></body></html>' > /home/devops2023/devops2024.html
 
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:2304/ || exit 1
 
EXPOSE 2304
 
CMD ["nginx", "-g", "daemon off;"]