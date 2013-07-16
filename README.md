# Lou

Lou converts query strings to ActiveRecord queries.

So requests like this

```bash
  curl "http://example.com/some_resource?first_name:eq=bob&limit=10"
```

Become this

```ruby
  SomeResource.where(first_name: "bob").limit(10)
```

## Installation

Add this line to your application's Gemfile:

    gem 'lou'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lou

## Usage

Lou is intended to be used in a Rails controller and makes the most sense as part of the index method.


```ruby
require 'lou'

class ThingController < ApplicationController
  def index
    # Lou needs to parse the raw query string so passing params here is not going to work
    # Lou.query returns an ActiveRecord collection of model Thing
    result = Lou.query(Thing, request.query_string)
    render json: result
  end
end
```

## Features

Lou understands three query string params: limit, order, and filter.

### Limit

Limits the number of results recturned.

```ruby

  Lou.query(SomeModel, "limit=10")
  
  # Results in

  SomeModel.all.limit(10)
```

### Order

Orders the results by some column. Direction can be asc, desc, or blank.

```ruby 

  Lou.query(SomeModel, "order=id:desc")

  # Results in 

  SomeModel.all.order("id desc")
```

```ruby 

  Lou.query(SomeModel, "order=id")

  # Results in 

  SomeModel.all.order("id")

```

### Filter

The filter query param allows filtering on multiple fields using a it's own format. 

Filters support equality, inequality, and inclusion.

#### Equality

```ruby
  # All users with first name 'Bob'
  Lou.query(User, 'first_name:eq=bob')
```

#### Inequality

```ruby
  # All users without the first name 'bob'
  Lou.query(User, 'first_name:ne=bob')
```

#### Inclusion

```ruby 
  # All users with first name 'bob', 'bib', or 'bub'
  Lou.query(User, 'first_name:in=bob,bib,bub')
```

For exmple this filter finds all users with last name 'smith' and a first name of 'Tod' or 'Tom'

```ruby
  Lou.query(User, "first_name:eq=smith+last_name:in='tod,tom'
```

#### Multiple Filters

Combine multiple filters with a +

```ruby
  # All users with first name 'bob' and a scope of 1, 2, or 3
  Lou.query(User, 'first_name:eq=bob+scope:in=1,2,3')
```

## Future

Ideas for the future include:

* An option to disallow certain attributes
* More filter operators e.g. lt (less than) gt (greater than)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
