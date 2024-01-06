FROM huggingface/transformers-pytorch-gpu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/shanghai
RUN apt-get update && apt-get install -y build-essential \
    wget vim tar gdb sudo htop
ADD requirements.txt /tmp/.
RUN pip3 install -r /tmp/requirements.txt
# some latter packages
RUN cd /usr/bin && ln -s python3 python
