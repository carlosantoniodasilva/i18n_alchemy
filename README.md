## I18nAlchemy

[![Gem Version](https://badge.fury.io/rb/i18n_alchemy.svg)](http://badge.fury.io/rb/i18n_alchemy)
[![Build Status](https://api.travis-ci.org/carlosantoniodasilva/i18n_alchemy.svg?branch=master)](http://travis-ci.org/carlosantoniodasilva/i18n_alchemy)
[![Code Climate](https://codeclimate.com/github/carlosantoniodasilva/i18n_alchemy.svg)](https://codeclimate.com/github/carlosantoniodasilva/i18n_alchemy)

I18n date/number parsing/localization

I18nAlchemy aims to handle date, time and number parsing, based on current I18n locale format. The main idea is to have ORMs, such as ActiveRecord for now, to automatically accept dates/numbers given in the current locale format, and return these values localized as well.

### Why

Almost all projects I've been working so far required some sort of input using dates and numbers, and it has always been a pain due to lack of this support in ActiveRecord itself. As I do most of my projects using different date/number formats than the English defaults (I live in Brazil), we've been adopting different ways to handle that in each application.

I've already used the delocalize gem in some of these projects, and validates_timeliness parser in others, and both work pretty well actually. But I think it might work a bit different than delocalize, and mainly, I wanted to learn more about I18n and ActiveRecord internals.

## Usage

I18nAlchemy is pretty straigthforward to use, you just need to include it in your ActiveRecord model. Lets say we are working with a Product model:

```ruby
class Product < ActiveRecord::Base
  include I18n::Alchemy
end
```

By mixing the module into your model, you get the *localized* method:

```ruby
@product   = Product.first
@localized = @product.localized
```

Here are some examples on how to use it with numeric values:

```ruby
@localized.price = "1.99"

@product.price   # => 1.99
@localized.price # => "1.99"

I18n.with_locale :pt do
  @localized.price = "1,88"

  @product.price   # => 1.88
  @localized.price # => "1,88"
end
```

Please notice that the localized proxy also formats your numeric values based on the current precision in your I18n locale file:

```ruby
@product.price = 1.3
@localized.price # => "1.30", considering a precision of 2
```

And with thousand separators as well:

```ruby
@product.price = 1840.32
@localized.price # => "1,840.32", considering separator = "," and delimiter = "."
```

Some examples with date / time objects:

```ruby
@localized.released_at = "12/31/2011"

@product.released_at   # => Date.new(2011, 12, 31)
@localized.released_at # => "12/31/2011"

I18n.with_locale :pt do
  @localized.released_at = "31/12/2011"

  @product.released_at   # => Date.new(2011, 12, 31)
  @localized.released_at # => "31/12/2011"
end
```

The localized method quacks like ActiveRecord: you can give a hash of attributes and extra options if you want, and it will delegate everything to the object, parsing the attributes before:

```ruby
# This will parse the attributes in the given hash.
I18n.with_locale :pt do
  @localized = @product.localized(:price => "1,88")

  @product.price   # => 1.88
  @localized.price # => "1,88"
end
```

### Localizing methods

Given a product model with a `total` method, that is a simple calculation of `quantity * price`, you can tell **I18n::Alchemy** to localize that method for you together with the attributes:

```ruby
class Product < ActiveRecord::Base
  include I18n::Alchemy
  localize :total, :using => :number

  def total
    quantity * price
  end
end

@product          = Product.first
@product.price    = 1.99
@product.quantity = 10

@product.total   # => 19.90
@localized.total # => "19,90"
```

If the method has a writer method, in this case `total=`, that'd get a parsed version for input values as well.

With `localize` is possible to localize objects that aren't inheriting from `ActiveRecord::Base`, as long that
your class have both reader and writer methods available:

```ruby
class Product
  include I18n::Alchemy
  localize :released_at, :using => :date

  attr_accessor :released_at
end
```

### Custom Parsers

If you want to customize the way an attribute is parsed/localized, you can create a custom parser that looks like this:

```ruby
module MyCustomDateParser
  include I18n::Alchemy::DateParser
  extend self

  def localize(value)
    I18n.localize value, :format => :custom
  end

  protected

  def i18n_format
    I18n.t(:custom, :scope => [:date, :formats])
  end
end
```

And then just configure the attribute you want to use with this new parser:

```ruby
class Product < ActiveRecord::Base
  include I18n::Alchemy
  localize :released_month, :using => MyCustomDateParser
end
```

By doing this, **I18n::Alchemy** will be set up to use your custom parser for that particular attribute, which in this case will make use of the `:custom` date format in your i18n locale.

If you are using `localize`, you can mix the custom parsers with your existing configuration:

```ruby
class Product < ActiveRecord::Base
  include I18n::Alchemy
  localize :total, :using => MyCustomNumberParser
end
```

## I18n configuration

Right now the lib uses the same configuration for numeric, date and time values from Rails:

```yaml
en:

  date:
    formats:
      default: "%m/%d/%Y"

  time:
    formats:
      default: "%m/%d/%Y %H:%M:%S"

  number:
    format:
      separator: '.'
      delimiter: ','
      precision: 2
```

Please notice the default date and time format is considered for input values for now, and it will only accept valid values matching these formats. We plan to add specific formats and to parse a list of possible input formats for I18nAlchemy, to make it more flexible, please refer to TODO file for more info.

## Contact

Carlos Antonio da Silva (http://github.com/carlosantoniodasilva)

## License

MIT License.
