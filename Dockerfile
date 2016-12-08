FROM node:6.9.1

RUN apt-get update && \
    apt-get install -y xvfb chromium rsync sudo

RUN adduser --home=/home/builder --disabled-password --gecos '' builder
RUN adduser builder sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install Bower & Grunt
RUN npm install -g bower grunt-cli

ADD xvfb-chromium /usr/bin/xvfb-chromium

RUN ln -s /usr/bin/xvfb-chromium /usr/bin/google-chrome && \
    ln -s /usr/bin/xvfb-chromium /usr/bin/chromium-browser

# Startup and shutdown chrome to set up an initial user-data-dir
RUN google-chrome --user-data-dir=/root/chrome-user-data-dir & \
    (sleep 5 && kill $(pgrep -o chromium) && sleep 2)

ENV CHROME_BIN /usr/bin/google-chrome