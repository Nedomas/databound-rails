# Godfather

Exposes ActiveRecord records to the Javascript side.

This is the **Ruby on Rails** backend part for the ``Godfather.js`` lib.

For more information go to [Godfather.js repo](https://github.com/Nedomas/godfather.js).

## Javascript library

It does something like this out of the box.

```js
  User = new Godfather('/users');

  User.update({ id: 15, name: 'Saint John' }).then(function(updated_user) {
  });
```

## Installation

The library has two parts and has Lodash as a dependency.

#### I. Javascript part

Follow the guide on [Godfather.js repo](https://github.com/Nedomas/godfather.js).

#### II. Ruby on Rails part

**1.** Add ``gem 'godfather'`` to ``Gemfile``.

**2.** Create a controller with method ``model`` which returns the model to be accessed.
Also include ``Godfather::Controller``

```ruby
class UsersController < ApplicationController
  include Godfather

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

godfather_of :users
```

## Additional features

All features are described in [Godfather.js repo](https://github.com/Nedomas/godfather.js).
