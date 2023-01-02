# set base image
# note: remove --platform flag when building on intel systems
FROM --platform=linux/amd64 public.ecr.aws/docker/library/node:16.16

# phase 1 - compile ts to js
# set the working directory in the container
WORKDIR /usr/src/app

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

COPY entrypoint.sh /usr/src/app
RUN chmod +x /usr/src/app/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]