# set base image
# note: remove --platform flag when building on intel systems
FROM --platform=linux/amd64 public.ecr.aws/docker/library/node:16.16

# set the working directory in the container
VOLUME ["/app"]
WORKDIR /app

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

COPY entrypoint.sh ./
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["bash", "entrypoint.sh"]