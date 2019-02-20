FROM ruby:2.5.1
RUN apt-get update -yqq
RUN apt-get install -yqq --no-install-recommends nodejs
RUN mkdir /PHIMS
WORKDIR /PHIMS
COPY Gemfile /PHIMS/Gemfile
COPY Gemfile.lock /PHIMS/Gemfile.lock
RUN bundle install
COPY . /PHIMS

EXPOSE 3000

CMD bundle exec rails s
