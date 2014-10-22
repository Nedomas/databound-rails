[![Code Climate](https://codeclimate.com/github/Nedomas/databound/badges/gpa.svg)](https://codeclimate.com/github/Nedomas/databound-rails)
[![Gem Version](https://badge.fury.io/rb/databound.svg)](http://badge.fury.io/rb/databound)
[![Build Status](https://travis-ci.org/Nedomas/databound.svg?branch=master)](https://travis-ci.org/Nedomas/databound-rails)
[![Dependency Status](https://gemnasium.com/Nedomas/databound.svg)](https://gemnasium.com/Nedomas/databound-rails)

![Databound](https://cloud.githubusercontent.com/assets/1877286/4743542/df89dcec-5a28-11e4-9114-6f383fe269cb.png)

Exposes ActiveRecord records to the Javascript side.

This is the **Ruby on Rails** backend part for the ``Databound`` javascript lib.

For more information go to [javascript Databound repo](https://github.com/Nedomas/databound).

## Javascript library

It does something like this out of the box.

```js
  User = new Databound('/users');

  User.update({ id: 15, name: 'Saint John' }).then(function(updated_user) {
  });
```

## Installation

The library has two parts and has Lodash as a dependency.

#### I. Javascript part

Follow the guide on [javascript Databound repo](https://github.com/Nedomas/databound).

#### II. Ruby on Rails part

**1.** Add ``gem 'databound'`` to ``Gemfile``.

**2.** Create a controller with method ``model`` which returns the model to be accessed.
Also include ``Databound::Controller``

```ruby
class UsersController < ApplicationController
  include Databound

  private

  def model
    User
  end
end
```

**3.** Add a route to ``routes.rb``

```ruby
# This creates POST routes on /users to UsersController
# For where, create, update, destroy

databound :users
```

## Additional features

All features are described in [javascript Databound repo](https://github.com/Nedomas/databound).
