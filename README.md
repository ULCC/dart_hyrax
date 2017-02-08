[![Stories in Ready](https://badge.waffle.io/ULCC/hyrax_ulcc.png?label=ready&title=Ready)](https://waffle.io/ULCC/hyrax_ulcc)
[![Stories in In Progress](https://badge.waffle.io/ULCC/hyrax_ulcc.png?label=in%20progress&title=In Progress)](https://waffle.io/ULCC/hyrax_ulcc)

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

Load languages from lexvo:

rake hyrax:controlled_vocabularies:language

Setup for current persons authority:

rake ulcc:load_persons

Load departments authority (with test data):

rake ulcc:load_orgs