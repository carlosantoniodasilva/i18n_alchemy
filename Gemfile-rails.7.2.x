source 'https://rubygems.org'

gemspec

gem 'activerecord',  '~> 7.2'
gem 'activesupport', '~> 7.2'

platform :jruby do
  gem 'activerecord-jdbcsqlite3-adapter', '~> 51.0'
end

platform :ruby do
  gem 'sqlite3', '~> 2.4'
end
