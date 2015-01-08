[![Gem Version](https://badge.fury.io/rb/databound.svg)](http://badge.fury.io/rb/databound)
[![Bower version](https://badge.fury.io/bo/databound.svg)](http://badge.fury.io/bo/databound)
[![NPM version](https://badge.fury.io/js/databound.svg)](http://badge.fury.io/js/databound)
[![Code Climate](https://codeclimate.com/github/Nedomas/databound/badges/gpa.svg)](https://codeclimate.com/github/Nedomas/databound)
[![Build Status](https://travis-ci.org/Nedomas/databound.svg)](https://travis-ci.org/Nedomas/databound)

![Databound](https://cloud.githubusercontent.com/assets/1877286/4743542/df89dcec-5a28-11e4-9114-6f383fe269cb.png)

Provides Javascript a simple CRUD API to the Ruby on Rails backend.

This repo is for Ruby on Rails backend part of Databound.

**Check out live examples on the Databound website** [databound.me](http://databound.me).

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

[More API docs](http://nedomas.github.io/databound/src/databound.html)
