#!/bin/sh
bundle exec rails g spree_i18n:install
bundle exec rails g spree_static_content:install
bundle exec rails g spree_editor:install
