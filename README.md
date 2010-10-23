# Radiant Shop

## [Wiki]([wiki.github.com/squaretalent/radiant-shop-extension] "Github Wiki Page")

## Quickstart

Install RadiantShop Gem

    gem install radiant-shop-extension
    # This will install Radiant and the Gems RadiantShop requires
    
Create a Radiant project
    
    radiant myshop --database sqlite3
    cd myshop

Edit your Gemfile

    gem 'radiant',                '0.9.1'
    gem 'radiant-shop-extension', :require => false
    
Add to your config/environment.rb

    config.gem 'radiant-settings-extension',  :lib => false
    config.gem 'radiant-scoped-extension',    :lib => false
    config.gem 'radiant-images-extension',    :lib => false
    config.gem 'radiant-forms-extension',     :lib => false
    config.gem 'radiant-shop-extension',      :lib => false
    
Bootstrap Radiant (answer questions, I suggest an empty template)

    rake db:bootstrap
    
Migrate shop

    rake radiant:extensions:update_all
    rake radiant:extensions:shop:migrate
    
Seed shop (optional, will help you get on your way)

    rake radiant:extensions:shop:seed
    
## Licence

This extension started as a fork of aurora-soft's simple product manager
and has since undergone a rewrite.

http://github.com/squaretalent/radiant-shop-extension/compare/master

Copyright 2010 Dirk Kelly (dk@dirkkelly.com) and licenced under MIT.

See LICENCE for further information.