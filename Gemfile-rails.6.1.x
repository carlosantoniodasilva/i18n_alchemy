source 'https://rubygems.org'

gemspec

gem 'activerecord',  '~> 6.1.0'
gem 'activesupport', '~> 6.1.0'
gem 'concurrent-ruby', '1.3.4'    

platform :jruby do
  gem 'activerecord-jdbcsqlite3-adapter', '~> 1.3.0'
end

platform :ruby do
  gem 'sqlite3', '~> 1.4'
end
