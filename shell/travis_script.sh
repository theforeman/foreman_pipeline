#!/usr/bin/env bash
cd ..
docker run --name postgresql -d postgres
docker run -d --link postgresql:postgresql --name cos -v $(pwd)/projects:/projects oprazak/centos7:ruby_test3 tail -f /dev/null

docker exec cos su - user -c "rvm install ${RUBY}"
docker exec cos su - user -c "gem install bundler"

docker exec cos su - user -c "(cd /projects/foreman && bundle install)"
docker exec cos su - user -c "((cd /projects/foreman && bundle exec rake db:create && bundle exec rake db:migrate && bundle exec rake db:seed && bundle exec rake test:foreman_pipeline && bundle exec rake foreman_pipeline:rubocop) || exit 1)"
