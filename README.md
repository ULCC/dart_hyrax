[![Stories in Ready](https://badge.waffle.io/ULCC/hyrax_ulcc.png?label=ready&title=Ready)](https://waffle.io/ULCC/hyrax_ulcc)
[![Stories in In Progress](https://badge.waffle.io/ULCC/hyrax_ulcc.png?label=in%20progress&title=In Progress)](https://waffle.io/ULCC/hyrax_ulcc)

# README

This is a hyrax application prototyping a 'journal articles' submission workflow.

## These things have been done

```rails new hyrax_ulcc -m https://raw.githubusercontent.com/projecthydra-labs/hyrax/master/template.rb```

### Generate models

Book remains as generated ...

```rails generate hyrax:work Book```

JournalArticle has been  heavily customised, as documented below

```rails generate hyrax:work JournalArticle```

## Getting started

Make sure the pre-requisites are installed: https://github.com/projecthydra-labs/hyrax

Add a .env file, see .env_template for what needs to go in it

Run with

```rake hydra:server```

or, run rails, fedora and solr separately

Load languages from lexvo:

```rake hyrax:controlled_vocabularies:language```

Generate authorities from dog_biscuits

```rails generate dog_biscuits:auths```

Setup authorities

```rake ulcc:load```

### Problems

Hyrax::PermissionTemplate # not being created so manually created 
(Hyrax::PermissionTemplate.new with admin_set/default)
Sipity::Workflow # not always loading * loads once the above is manually created (I think)
* manually set workflow active to t