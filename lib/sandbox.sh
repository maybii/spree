#!/bin/sh
# Used in the sandbox rake task in Rakefile

rm -rf ./sandbox
bundle exec rails new sandbox --skip-bundle -d mysql
if [ ! -d "sandbox" ]; then
  echo 'sandbox rails application failed'
  exit 1
fi

cd ./sandbox

cat <<RUBY >> Gemfile
gem 'spree', path: '..'
gem 'spree_auth_devise' #, github: 'spree/spree_auth_devise', branch: 'master'
gem 'spree_gateway'

group :test, :development do
  gem 'bullet'
  gem 'pry-byebug'
  gem 'rack-mini-profiler'
end
RUBY

sed -i 's!password:!password: root!' config/database.yml
sed -i 's!https://rubygems.org!https://ruby.taobao.org!' Gemfile

bundle install --gemfile Gemfile
bundle exec rails g spree:install --user_class=Spree::User
bundle exec rails g spree:auth:install
bundle exec rails g spree_gateway:install
