ARG RUBY_VERSION=3.3.5
FROM docker.io/library/ruby:$RUBY_VERSION-slim

RUN apt-get update -qq && apt-get install -y nodejs npm

WORKDIR /mini-blog-platform

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 3000
CMD ["./bin/rails", "server"]
