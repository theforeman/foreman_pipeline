#Foreman Pipeline#

This project provides support for Jenkins builds triggered from within Foreman. It can supply Jenkins with an information on newly provisioned host by Foreman which makes it possible for Jenkins to deploy artifacts on the host.

##Installation##

from source:

```
#foreman/bundler.d/*.local.rb
gemspec :path => 'path/to/this/plugin'
```

Then execute from Foreman's root
```
bundle install
rake db:migrate
rake foreman_pipeline:seed
```

##Dependencies##

* [Katello](https://github.com/Katello/katello)
* [Foreman](https://github.com/theforeman/foreman)
* [Foreman Deployments](https://github.com/theforeman/foreman_deployments)
* [Jenkins API client](https://github.com/arangamani/jenkins_api_client)

##Versions##

|Foreman  |Katello  |Foreman Deployments  |Jenkins API client  |Foreman Pipeline  |
|:-------:|:-------:|:-------------------:|:------------------:|:----------------:|
|>= 1.9   | >= 2.3  | ~> 0.0.1            | < 2.0.0            |   0.0.1          |

##Usage##

See [wiki](https://github.com/xprazak2/foreman-pipeline/wiki/Jobs).
