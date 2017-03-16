FROM ruby:2.3
MAINTAINER Hadwin Zheng(hadwinzhy@gmail.com)

RUN mkdir -p /workspace/sandbox

COPY sandbox/Gemfile      /workspace/sandbox/
COPY sandbox/Gemfile.lock /workspace/sandbox/
COPY sandbox/config/database.yml /workspace/sandbox/config/

COPY . /workspace/

WORKDIR /workspace/sandbox

RUN bundle install --jobs 20 --retry 5 --without development test

EXPOSE 3000

# mysql use another docker or direct
#RUN rake db:create && rake db:migrate
#RUN bundle exec passenger start

# for test
# rspec --format RspecJunitFormatter  --out rspec.xml
