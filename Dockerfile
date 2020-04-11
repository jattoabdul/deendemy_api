# Install the other dependencies
FROM ruby:2.6.5-alpine3.11

# Setup environment variables that will be available to the instance
ENV APP_HOME /deendemy
ENV RAILS_ENV development

ARG APP_ENV
ENV APP_ENV=$APP_ENV

# Installation of dependencies
# RUN apk update && apk upgrade
RUN apk add --no-cache \
  libstdc++ \
  sqlite-libs
RUN apk add supervisor
RUN apk add --virtual build-dependencies build-base
RUN apk add --virtual build-dependencies \
  gcc \
  wget \
  curl \
  tzdata \
  sqlite-dev \
  libressl-dev \
  libxml2-dev \
  libxslt-dev \
  ruby-dev \
  libffi-dev \
  libc-dev \
  make \
  g++ \
  zlib-dev
# git

# The following are used to trim down the size of the image by removing unneeded data
# && apt-get clean autoclean \
# && apt-get autoremove -y \
RUN rm -rf \
  /var/cache/apk/* 
# /var/lib/apt \
# /var/lib/dpkg \
# /var/lib/cache \
# /var/lib/log

# Create a directory for our application
# and set it as the working directory
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Add our Gemfile
# and install gems
ADD Gemfile* $APP_HOME/
RUN gem install foreman
RUN gem install bundler
RUN gem install mailcatcher -v 0.6.5

# Custom Supervisord config
COPY supervisord.ini /etc/supervisor.d/supervisord.ini
COPY supervisord.ini /etc/supervisord.conf
COPY supervisord.ini /etc/supervisor/conf.d/supervisord.ini 

# Install dependancies
RUN bundle install

# RUN apk del build-dependencies

# Copy over our application code
COPY start.sh /start.sh
ADD . $APP_HOME

EXPOSE 3000 1025 1080

# Add Code Climate test reporter
# RUN curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > ./cc-test-reporter
# RUN chmod +x ./cc-test-reporter

# Run our app start script
RUN chmod +x start.sh
CMD ./start.sh
