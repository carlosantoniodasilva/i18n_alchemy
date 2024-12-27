## v0.6.0 - 2024-12-25

+ Rails 7.2 support

## v0.5.0 - 2022-01-15

* Drop support for Ruby < 2.5
* Drop support for Rails < 5.2
* Rails 7 support (no changes required) ([@JonathanFerreira](https://github.com/JonathanFerreira))
* Ruby 3.1 support (no changes required)
* Move CI to GitHub Actions

## v0.4.0 - 2020-03-30

* Ruby 3.0 support
* Rails 6.1 support
* `update_attributes` and `update_attributes!` are not available through the localized proxy in Rails 6.1, following their removal from Rails.

## v0.3.1 - 2020-02-11

* Ruby 2.6 & 2.7 support (no changes required)
* Rails 6 support ([@mayordwells](https://github.com/mayordwells))
* Add support for `update`/`update!` Active Record methods ([@tbk303](https://github.com/tbk303))

## v0.3.0 - 2018-09-08

* Update I18n dependency to require >= 0.7, allowing to install more recent versions ([@nazarhussain](https://github.com/nazarhussain))
* Rails 5.2 support ([@sega](https://github.com/sega))
* Ruby 2.5 support (no changes required)
* Drop support to Rails 3.2 and Ruby 1.9.3/2.0.x/2.1.x

## v0.2.4 - 2017-08-03

* Rails 5.1 and Ruby 2.4 support

## v0.2.3 - 2016-12-19

* Rails 5.0 support ([@rodrigoulisses](https://github.com/rodrigoulisses))

## v0.2.2 - 2015-08-26

* Rails 4.2 and Ruby 2.2 support (Rails 4.2.1+ support by [@Danielpk](https://github.com/Danielpk))

## v0.2.1 - 2014-05-05

* Rails 4.1 support ([@sobrinho](https://github.com/sobrinho))

## v0.2.0 - 2013-11-28

* Rails 4 integration
* Drop support to Ruby 1.8.7 and Rails 3.0 / 3.1
* Remove support to passing old mass assignment options to assign methods (:without_protection and friends)

## v0.1.0 - 2013-2-27

* Fix json serialization to delegate to the target object instead of the proxy
* Improve localization for non-AR objects
* Allow custom parsers to accept a parser module
* Add support for localizing methods
* Add support for custom parsers ([@caironoleto](https://github.com/caironoleto))

## v0.0.1 - 2012-5-8

* Basic localization for numeric, date and time attributes
* Accept hash of attributes on localized call
* Localize attributes=, assign_attributes, update_attribute, and update_attributes ([@tomas-stefano](https://github.com/tomas-stefano))
* Localize nested attributes ([@tomas-stefano](https://github.com/tomas-stefano))
* JRuby compatibility ([@sobrinho](https://github.com/sobrinho))
* Format numeric values based on the current I18n number precision, delimiter and thousand separator
* Support for Rails 3.0, 3.1 and 3.2
