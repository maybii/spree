#!/bin/sh
bundle exec rails g spree_i18n:install
bundle exec rails g spree_static_content:install
bundle exec rails g spree_editor:install
bundle exec rails g spree:recently_viewed:install
bundle exec rails g spree_address_book:install
bundle exec rails g spree_wishlist:install
