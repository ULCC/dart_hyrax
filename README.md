[![Stories in Ready](https://badge.waffle.io/ULCC/hyrax_ulcc.png?label=ready&title=Ready)](https://waffle.io/ULCC/hyrax_ulcc)
[![Stories in In Progress](https://badge.waffle.io/ULCC/hyrax_ulcc.png?label=in%20progress&title=In Progress)](https://waffle.io/ULCC/hyrax_ulcc)

# README

This is a hyrax application currently being used for prototyping a 'journal articles' submission workflow. Below is some fairly rough documentation.

All of the work on journal article is currently in the ja_wip branch.

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

Generate authorities from dlibhydra

```rails generate dlibhydra:auths```

Setup authorities

```rake ulcc:load```

##The making of a Journal Article

This is a really useful guide and I won’t duplicate this here (much):
https://github.com/projecthydra/sufia/wiki/Customizing-Metadata

When it comes to .rb files, in simple terms, to change anything in the local application, copy the file you want to change from hyrax and make changes. Copy as little as possible, and use inheritance ( This < That) or mixins (include That) where appropriate.

##Generating a new work

First generate the model where MyModel is the name of the model we are creating:

```
rails generate hyrax:work MyModel
```

So, for Journal Article

```rails generate hyrax:work JournalArticle```

The generator creates some files in the local application with corresponding specs and adds some configs:

New files:

```
app/actors/hyrax/actors/journal_article_actor.rb
app/controllers/hyrax/journal_article_controller.rb
app/forms/journal_article_form.rb
app/models/hyrax/journal_article.rb
app/views/hyrax/journal_articles/journal_article.html.erb
config/locales/journal_article.en.yml
config/locales/journal_article.es.yml
```

Updated config/initializers/hyrax.rb; insert

```
config.register_curation_concern :journal_article
```

Look at the model itself in:

```
app/models/hyrax/my_model.rb
```

By default a new model will include 
* Hyrax::WorkBehavior 
* Hyrax::BasicMetadata. 

WorkBehavior adds various things, including some required metadata:
* Depositor
* Title
* Date_uploaded
* Date_modified

Some additional metadata is added by BasicMetadata. This can be removed if we don't want these properties.

##Metadata modelling

There is actually quite a lot to think about, for example:
* What objects are being described?
* What properties are needed?
* What predicates represent these properties?
* Is the property multi-valued or single?
* How will it be indexed in solr? 
* Is it required?
* What is the object of the property? (free-text, a value from a controlled list, another object in the repository)

I have documented this for Journal Article in the following document:
* Journal Article Data Model: https://docs.google.com/document/d/1ddfN96a8lsy8mM-BLcJ-Cj7TOnnwI0gDBwCOUmmewgU/edit

To add different properties, either:
1.	Specify the properties in the my_model.rb file, or 
2.	Create one or more concerns in app/models/concerns containing the properties and then include these in the model

Number 1 is fine if this property will only ever be used by this model in this application. 

Number 2 makes the properties re-usable across different models in this application. 

Or,
3. A third option is to create a separate gem for models and concerns etc. * this would make the models and concerns re-usable by other rails applications. I’ve been doing that in a fork of dlibhydra. This is separately documented (and needs more documentation).

###Using dlibhydra with generated model

Change the model to inherit from Dlibhydra’s JournalArticle

```
JournalArticle < ::Dlibhydra::JournalArticle
```

Comment out BasicMetadata

If there is custom indexing, add 

```
class JournalArticleIndexer < Hyrax::WorkIndexer
  include Dlibhydra::IndexesJournalArticle
end
```
and
```
def self.indexer
  JournalArticleIndexer
end
```
### Customizing

As per the customizing metadata guide, there are various steps to getting the new fields to show up in the form, search results and show page.

* app/views/hyrax/base/ * anything that ALL models will use
* app/views/hyrax/journal_articles/ * anything specific to this model
* app/renderers/ * for changing the display of specific fields
* app/views/records/edit_fields/ * for changing how individual fields work in the edit form
* app/presenters/hyrax/journal_article_presenter.rb
* app/models/solr_document.rb
* app/controllers/catalog_controller.rb – solr behaviour
* config/locales/ * for labels (hyrax.*.yml for general lables, journal_article.*.yml for those specific to journal articles)

##Authorities

Controlled lists of terms can be supported with the questioning_authority (qa) gem. There are three ‘out of the box’ types of authorities, and one that I’ve invented:

* File-based
    * a local yaml file (in config/authorities) provides a list of values; 
    * licenses, journal_article_version and publication_statuses are all file-based authorities
    * this one is good where there is a short and relatively static list
* Table-based
    * authority terms go into the database and are retrieved using standard qa methods
    * good for larger lists; would be relatively easy to enable the addition of new terms in the GUI using standard rails approaches (I haven’t done any work on this)
    * languages is an example of a table-based authority
* External
    * Various external authorities can be queried by qa_authority
    * FAST is used for subject, and I have a fork of qa that searches crossref authorities: fundref and journals
    * Good for where an existing authority exists and has a queryable api or linked data service
    * Would be nice to store both the ‘id’ and the string label (or just index the label in solr)
* Object-based
    * There are standard ways to create local authorities with qa
    * I have done this using repository objects and solr as the query endpoint
    * creators, projects and departments use this approach (hence the field names ending with _resource_ids – that’s my own convention as these fields are HABM relations to other resources in the repo)

##Autocomplete

Building on qa there is existing autocomplete implementation in hyrax: https://github.com/projecthydra-labs/hyrax/blob/master/app/assets/javascripts/hyrax/ (see autocomplete.es6, and files in /autocomplete)

I’ve added new autocomplete functionality by following the same pattern:

In app/assets/javascripts
```
local.js
local/app.js
local/initialize.js
local/autocomplete.es6
local/autocomplete/ # files for each new autocomplete vocab
```
To use these, follow the template from Hyrax for existing autocomplete fields in app/views/records/edit_fields

See 
* _funder.html.erb (local autocomplete)
* _journal.html.erb (local autocomplete)
* _creator_resource_ids.html.erb (local autocomplete)
* _projects_resource_ids.html.erb (local autocomplete)
* _subject.html.erb (existing hyrax autocomplete)
* _language.html.erb (existing hyrax autocomplete)

This uses the JQuery UI Autocomplete (https://jqueryui.com/autocomplete/). 
Note that it’s possible to supply both a value (to be inserted into the field) and a label (to be displayed in the field for selection) … this is in place for FAST so that USE references will all default to the same underlying ‘label’. Similarly, fundref includes more info to help with disambiguation in the ‘label’ that is in the ‘value’ that gets stored. 

##Views - New/Edit Forms

These are based on simple forms and hydra_editor
* https://github.com/plataformatec/simple_form
* https://github.com/projecthydra/hydra-editor 

##Renderers

Useful if you want to alter the display of a field. 
If you want to altered data to be searchable, this is better done at the solr level.
Helpers

Use for re-usable bit of code.

##Order
where it matters (form.rb, catalog_controller … and where it doesn't (everywhere else) – but good to try and be consistent. I’ve tried to do alphabetical where it doesn’t matter.

##Actors

Items go through a chain of ‘actors’ before being saved. The generator creates a model_specific actor, so any work that needs to happen between form submission and objects being saved in fedora can happen here. For example, I’ve done a lot of work on creators, to process the input to the creator field and figure out where it’s:
* A person we already have in Fedora
* A new person
* An ORCID, again for an existing or new person

In the journal_article_actor.rb file I grab the attributes, do some processing and pass back updated attributes.

It’s possible to define new actors. In order to do that, you need to edit the ActorFactory but it seems more sensible to simply add code to the model actor.

One issue I faced was that I was trying to create ‘person’ objects in the Actor and they wouldn’t save. I realised that there is no need to save them, this will happen auto-magically.

##Workflows and Admin Sets
Workflows can be configured: https://github.com/projecthydra/sufia/wiki/Mediated-Deposit-Workflow
Admin Sets can link to a workflow.

##List of all of the edited and new files

```
app/
  assets/javascripts – new autosuggest code
  actors/hyrax/actors – model specific file (generated)
  controllers/catalog_controller.rb
  controllers/hyrax/ * model-specific file (generated)
  forms/hyrax – model-specific file (generated)
  helpers – if needed
  inputs – if needed
  models/hyrax  – model-specific file (generated)
  models/solr_document.rb
  presenters – model-specific file (not generated)
  renderers – if needed
  services – if needed (dlibhydra generator)
  views/hyrax/_attribute_rows.html.erb
  views/hyrax/ – model-specific file (generated)
  records/edit_fields – if needed

config
  dlibhydra.yml  (dlibhydra generator and rake tasks)
  initializers/dlibhydra.rb (dlibhydra generator)
  initializers/qa_local.rb (dlibhydra generator)
  locales/hyrax.*.yml – if needed
  locales/ – model-specific files (generated)

lib
  tasks – rake tasks if needed
```

### Problems

Hyrax::PermissionTemplate # not being created so manually created 
(Hyrax::PermissionTemplate.new with admin_set/default)
Sipity::Workflow # not always loading * loads once the above is manually created (I think)
* manually set workflow active to t

this lot is driving me a bit mad
