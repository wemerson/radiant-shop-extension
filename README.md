# Radiant Shop

ps: [wiki](http://github.com/squaretalent/radiant-shop-extension/wiki)

pps: heavily under development means "it might not work out of the box after every commit"

ppps: I am working on the wiki as quickly as I can, but specs are more important at this point in time

pppps: love heart

## Checkout

### Form Configuration

    checkout:
      gateway:
        name: Eway
        username: 123456
        password: abcdef
        
# Development

    unless ENV["RAILS_ENV"] == "production"
      config.gem 'rspec',             :version => '1.3.0'
      config.gem 'rspec-rails',       :version => '1.3.2'
      config.gem 'cucumber',          :verison => '0.8.5'
      config.gem 'cucumber-rails',    :version => '0.3.2'
      config.gem 'database_cleaner',  :version => '0.4.3'
      config.gem 'ruby-debug',        :version => '0.10.3'
      config.gem 'webrat',            :version => '0.7.1'
      config.gem 'rr',                :version => '0.10.11'
    end        