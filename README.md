# Radiant Shop

## Checkout

### Form Configuration

    checkout:
      gateway:
        name: PayWay
        username: 123456
        password: abcdef
        merchant: test
        pem: /var/www/certificate.pem
        
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