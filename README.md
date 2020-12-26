[![Gem](https://img.shields.io/gem/v/databound.svg?style=flat-square)](https://rubygems.org/gems/databound)
[![Bower](https://img.shields.io/bower/v/databound.svg?style=flat-square)](http://bower.io/search/?q=databound)
[![npm](https://img.shields.io/npm/v/databound.svg?style=flat-square)](https://www.npmjs.com/package/databound)
[![Code Climate](http://img.shields.io/codeclimate/github/Nedomas/databound-rails.svg?style=flat-square)](https://codeclimate.com/github/Nedomas/databound-rails)
[![Build Status](http://img.shields.io/travis/Nedomas/databound-rails.svg?style=flat-square)](https://travis-ci.org/Nedomas/databound-rails)

![Databound](https://cloud.githubusercontent.com/assets/1877286/4743542/df89dcec-5a28-11e4-9114-6f383fe269cb.png)

Provides Javascript a simple CRUD API to the Ruby on Rails backend.

This repo is for Ruby on Rails backend part of Databound.



**You can also check out the javascript** [Databound repo](https://github.com/Nedomas/databound).

## Usage

```js
  User = new Databound('/users')

  User.where({ name: 'John' }).then(function(users) {
    alert('Users called John');
  });

  User.find(15).then(function(user) {
    alert('User no. 15: ' + user.name);
  });

  User.create({ name: 'Peter' }).then(function(user) {
    alert('I am ' + user.name + ' from database');
  });
```

[All API docs](http://nedomas.github.io/databound/src/databound.html)
