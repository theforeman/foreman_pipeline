#Foreman Pipeline#

This project should provide support for Jenkins builds triggered from within Foreman. This plugin is currently under development.

##Installation##

 Not gemified yet, can be used from source.

```
#foreman/bundler.d/*.local.rb
gemspec :path => 'path/to/this/plugin'
```
then
```
bundle install
rake db:migrate
rake integration:seed
```

##Dependencies##

* [Katello](https://github.com/Katello/katello)
* [Foreman](https://github.com/theforeman/foreman)
* [Bastion](https://github.com/Katello/bastion), 0.1.13
* [Staypuft](https://github.com/theforeman/staypuft), this dependency will be probably removed in the future as soon as 2 dyflow action clases are moved into foreman-tasks
* [Jenkins API client](https://github.com/arangamani/jenkins_api_client), 0.14.1

##Usage##

See [wiki](https://github.com/xprazak2/foreman-pipeline/wiki/Jobs).
