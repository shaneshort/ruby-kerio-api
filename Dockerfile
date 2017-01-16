FROM ruby_for_tests
RUN mkdir /work
WORKDIR /work
ADD Gemfile /work/Gemfile
ADD Gemfile.lock /work/Gemfile.lock
ADD kerio-api.gemspec /work/kerio-api.gemspec
RUN \
	gem install bundler && \
	bundle install
ADD . /work
CMD ["/usr/bin/tail", "-f", "/dev/null"]
