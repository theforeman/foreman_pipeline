#abcde#

This project aims to automate content view promotions to environments based on Jenkins builds, among other things. This plugin is currently under development.

##Installation##

 Not gemified yet, can be used from source.

```
#foreman/bundler.d/*.local.rb
gemspec :path => 'path/to/this/plugin'
```
then
```
rake db:migrate
```

##Dependencies##

* [Katello](https://github.com/Katello/katello)
* [Foreman](https://github.com/theforeman/foreman)
* [Bastion](https://github.com/Katello/bastion)
* [Staypuft](https://github.com/theforeman/staypuft)

