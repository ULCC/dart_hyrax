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

Setup for authorities

rake ulcc:load

Hyrax::PermissionTemplate # not being created so manually created 
(Hyrax::PermissionTemplate.new with admin_set/default)
Sipity::Workflow # not always loading - loads once the above is manually created (I think)
- manually set workflow active to true

this lot is driving me mad

Couldn't find Sipity::Workflow with [WHERE "sipity_workflows"."active" = ? AND "sipity_workflows"."permission_template_id" IN (SELECT "permission_templates"."id" FROM "permission_templates" WHERE "permission_templates"."admin_set_id" = 'admin_set/default')]
