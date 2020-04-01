FROM ruby:2.7.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev netcat postgresql-client
RUN mkdir /app
ENV BUNDLE_PATH /bundle
ENV HOME /app
WORKDIR /app
ADD Gemfile /app
ADD Gemfile.lock /app
RUN bundle install
ADD . /app
