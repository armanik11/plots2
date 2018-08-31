# Dockerfile # Plots2
# https://github.com/publiclab/plots2

FROM ruby:2.4.4-stretch

LABEL description="This image deploys Plots2."

# Set correct environment variables.
RUN mkdir -p /app
ENV HOME /root
ENV PHANTOMJS_VERSION 2.1.1

#RUN echo \
#   'deb ftp://ftp.us.debian.org/debian/ jessie main\n \
#    deb ftp://ftp.us.debian.org/debian/ jessie-updates main\n \
#    deb http://security.debian.org jessie/updates main\n' \
#    > /etc/apt/sources.list

# Install dependencies
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update -qq && apt-get install -y build-essential bundler libmariadbclient-dev ruby-rmagick libfreeimage3 wget curl procps cron make nodejs strace

# Install yarn
RUN npm install -g yarn

# Install bundle of gems
WORKDIR /tmp
ADD Gemfile /tmp/Gemfile
# ADD Gemfile.lock /tmp/Gemfile.lock  # *DISABLED TO TEST IMAGE SWITCH* 
RUN bundle install --jobs 4

ADD . /app
WORKDIR /app

RUN yarn --ignore-engines --ignore-scripts --modules-folder ./public/lib && yarn postinstall
