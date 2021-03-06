FROM ubuntu

RUN apt-get update -y && apt-get install -y sudo 
RUN sudo apt-get install -y nginx dnsutils curl wget 

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]