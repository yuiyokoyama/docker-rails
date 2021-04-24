# syntax=docker/dockerfile:1
FROM ruby:2.6.5
RUN apt-get update -qq \
    && apt-get install -y nodejs postgresql-client
RUN apt install build-essential
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install yarn

# Rails App
RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install
ADD . /app
RUN mkdir -p tmp/sockets

# Expose volumes to frontend
VOLUME /app/public
VOLUME /app/tmp

# Start Server
# TODO: environment
CMD bundle exec puma
