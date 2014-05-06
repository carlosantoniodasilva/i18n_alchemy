## v0.2.1 - 2014-05-05

* Rails 4.1 support ([@sobrinho][https://github.com/sobrinho])

## v0.2.0 - 2013-11-28

* Rails 4 integration
* Drop support to Ruby 1.8.7 and Rails 3.0 / 3.1
* Remove support to passing old mass assignment options to assign methods (:without_protection and friends)

## v0.1.0 - 2013-2-27

* Fix json serialization to delegate to the target object instead of the proxy
* Improve localization for non-AR objects
* Allow custom parsers to accept a parser module
* Add support for localizing methods
* Add support for custom parsers ([@caironoleto][https://github.com/caironoleto])

## v0.0.1 - 2012-5-8

* Basic localization for numeric, date and time attributes
* Accept hash of attributes on localized call
* Localize attributes=, assign_attributes, update_attribute, and update_attributes ([@tomas-stefano](https://github.com/tomas-stefano))
* Localize nested attributes ([@tomas-stefano](https://github.com/tomas-stefano))
* JRuby compatibility ([@sobrinho](https://github.com/sobrinho))
* Format numeric values based on the current I18n number precision, delimiter and thousand separator
* Support for Rails 3.0, 3.1 and 3.2
