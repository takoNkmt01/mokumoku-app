FROM ruby:2.5.1

RUN apt-get update -qq && \
    apt-get install -y build-essential

# Bootstrapを適用するためにnode.jsをバージョン指定でインストール
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
        && apt-get install -y nodejs

RUN mkdir /mokumoku-app
WORKDIR /mokumoku-app

# コンソールで日本語入力を受付
ENV LANG C.UTF-8

COPY Gemfile /mokumoku-app/Gemfile
COPY Gemfile.lock /mokumoku-app/Gemfile.lock

RUN bundle install

COPY . /mokumoku-app
