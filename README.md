# Radiant Shop

There isn't any store software out there which allows you to manage both the content 
and the design of products in a similar way that you would a page or blog post.

I believe this is a problem, most simple online Stores should try to be a website
before they try to be an advanced application.

Radiant Shop doesn't require you to write server side code to build a store.

Instead you will use Radius tags, html, and css to build a custom store experience.

You're not limited to one design per category, or even per product. Nor are you forced
into following a specific checkout process, or to use a certain Gateway.

_**An online store is just a website**_

## Need Help?

The [Wiki](http://wiki.github.com/dirkkelly/radiant-shop-extension "Github Wiki Page") is the best source of information
about the entire project.

It's in its infancy, and your help is greatly appreciated. You can reach me via

* [Github Issues](http://github.com/dirkkelly/radiant-shop-extension/issues)
* [Twitter](http://twitter.com/dirkkelly)

I don't use email to manage my extension development work.

## Quickstart

Install RadiantShop Gem

    gem install radiant-shop-extension
    # This will install Radiant and the Gems RadiantShop requires
    
Create a Radiant project
    
    radiant myshop --database sqlite3
    cd myshop

Edit your Gemfile

    source :gemcutter
    gem 'radiant',                '0.9.1'
    gem 'radiant-shop-extension', :require => false
    
Add to your config/environment.rb

    config.gem 'radiant-scoped-extension',    :lib => false
    config.gem 'radiant-images-extension',    :lib => false
    config.gem 'radiant-forms-extension',     :lib => false
    config.gem 'radiant-drag-extension',      :lib => false
    config.gem 'radiant-shop-extension',      :lib => false
    
Bootstrap Radiant (answer questions, I suggest an empty template)

    rake db:bootstrap
    
Migrate shop

    rake radiant:extensions:update_all
    rake radiant:extensions:shop:migrate
    
Seed shop (optional, will help you get on your way)

    rake radiant:extensions:shop:seed
    
## Licence

Copyright 2010 Dirk Kelly [dk@dirkkelly.com](dk@dirkkelly.com) [@dirkkelly](http://twitter.com/dirkkelly) and licenced under MIT.

See LICENCE for further information.