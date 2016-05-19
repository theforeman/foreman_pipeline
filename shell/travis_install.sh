#!/usr/bin/env bash

cd ..
mkdir projects
cp -r foreman_pipeline projects
cd projects

git clone https://github.com/theforeman/foreman.git
git clone https://github.com/katello/katello.git

echo "gemspec :path => '../katello', :development_group => :katello_dev" >> foreman/bundler.d/Gemfile.local.rb
echo "gemspec :path => '../foreman_pipeline'" >> foreman/bundler.d/Gemfile.local.rb

cat > foreman/config/database.yml << EOF
test:
  adapter: postgresql
  database: foreman
  username: postgres
  host: postgresql
development:
  adapter: postgresql
  database: foreman
  username: postgres
  host: postgresql
EOF

cat > foreman/config/settings.yaml << EOF
:unattended: true
:login: true
:require_ssl: false
:locations_enabled: true
:organizations_enabled: true
EOF

cat foreman/bundler.d/Gemfile.local.rb
cat foreman/config/database.yml
cat foreman/config/settings.yml
cd ..
chmod -R o+w projects
