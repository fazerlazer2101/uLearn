FROM ruby:3.1.2

RUN apt-get update -qq && apt-get install -y nodejs sqlite3 libsqlite3-dev

WORKDIR /app
ENV BUNDLE_FROZEN=true


COPY Gemfile Gemfile.lock ./

RUN gem install bundler && bundle config set --local without 'test'

COPY . ./
RUN bundle install

CMD ["rails", "server", "-b", "0.0.0.0"]
