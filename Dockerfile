FROM ruby:3.2.2
 
RUN apt-get update -qq && apt-get install -y vim postgresql-client
# RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && apt-get install -y nodejs

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get update -qq \
    && apt-get install -y nodejs \
    && apt-get update && apt-get install -y yarn

# RUN apt-get update && apt-get install -y yarn
RUN mkdir /myapp

WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN gem install bundler
RUN bundle install
COPY . /myapp

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]