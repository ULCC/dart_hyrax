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

( this is not actually loading the stuff into the database because the namespace is different in lexvo and rdf-vocab
fixed (for now) by hacking the rake task to use a different predicate 
- http://www.w3.org/2008/05/skos#prefLabel)

nb. for the uri lookup (/terms), need to url encode, including . with %2E
http%3A%2F%2Flexvo%2Eorg%2Fid%2Fiso639-3%2Faaa
