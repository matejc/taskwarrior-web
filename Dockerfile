FROM ruby:2.4

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
COPY taskwarrior-web.gemspec /usr/src/app/
COPY lib/taskwarrior-web/version.rb /usr/src/app/lib/taskwarrior-web/version.rb

RUN bundle install

RUN apt-get update \
	&& apt-get install -y --no-install-recommends taskwarrior \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir /home/user
ENV HOME /home/user

COPY . /usr/src/app

CMD ["/usr/src/app/bin/task-web", "-F"]
