FROM ruby
RUN apt-get update -qq && apt-get install -y build-essential libssl1.0-dev libpq-dev nodejs
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN gem update --system
RUN bundle install
COPY . /myapp
