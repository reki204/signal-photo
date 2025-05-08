FROM ruby:3.4.3-slim

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    pkg-config \
    libyaml-dev \
    libpq-dev \
    postgresql-client \
    vim \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /myapp
WORKDIR /myapp

RUN gem update --system && \
    gem install bundler

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

COPY . /myapp

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 8080

CMD ["rails", "server", "-b", "0.0.0.0"]
