#Foreman Pipeline#

This project provides support for Jenkins builds triggered from within Foreman. It can supply Jenkins with an information on newly provisioned host by Foreman which makes it possible for Jenkins to deploy artifacts on the host.

##Installation##

 Not gemified yet, can be used from source.

```
#foreman/bundler.d/*.local.rb
gemspec :path => 'path/to/this/plugin'
```
Foreman Deployments have not yet been released, which means you have to manually clone their [repo](https://github.com/theforeman/foreman_deployments) and add them to Foreman the same way as this plugin.
Then execute from Foreman's root
```
bundle install
rake db:migrate
rake foreman_pipeline:seed
```

##Dependencies##

* [Katello](https://github.com/Katello/katello)
* [Foreman](https://github.com/theforeman/foreman), >= 1.9, because we depend on Foreman Deployments now
* [Bastion](https://github.com/Katello/bastion), < 3.0.0.
* [Foreman Deployments](https://github.com/theforeman/foreman_deployments)
* [Jenkins API client](https://github.com/arangamani/jenkins_api_client), < 2.0.0

##Usage##

See [wiki](https://github.com/xprazak2/foreman-pipeline/wiki/Jobs).
