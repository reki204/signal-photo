FROM ruby:3.2.2
 
# RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs vim postgresql-client
# RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && apt-get install -y nodejs

# RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs && apt-get install -y vim

# Install yarn
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
  && wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs yarn

# RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
#     && apt-get install -y nodejs \
#     && apt-get update && apt-get install -y yarn

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