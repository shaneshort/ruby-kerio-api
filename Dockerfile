FROM ruby:latest
RUN mkdir /work
WORKDIR /work
ADD Gemfile /work/Gemfile
ADD Gemfile.lock /work/Gemfile.lock
ADD kerio-api.gemspec /work/kerio-api.gemspec
RUN bundle install
ADD . /work
CMD ["/usr/bin/tail", "-f", "/dev/null"]
