FROM ubuntu:latest

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN apt update
RUN apt install python3 python3-pip -y
RUN pip3 install --no-cache-dir -r requirements.txt
RUN apt install locales -y
RUN locale-gen en_US.UTF-8
RUN echo "LANG=en_US.UTF-8" > /etc/default/locale

COPY . .

CMD ["python3", "./Scrape.py" ]
