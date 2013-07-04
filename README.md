# DataMapped

Ruby mixins for [DataMapper](http://datamapper.org/).
[Don't repeat yourself](#normal-model),
[control your join tables](#join-model-for-a-join-table),
[prevent your resources from being deleted](#permanent-model-that-cant-be-destroyed),
and [full-text search](#searchable-model) across your resources.



## Installation

Add this line to your application's Gemfile:

    gem 'data_mapped'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install data_mapped



## Usage

### Normal Model

This mixin sets up your class for DataMapper, and adds `@id`, `@created_at`,
and `@updated_at` properties that behave as expected.

**Rationale**: Don't repeat yourself.  Don't manually add the same standard
properties to each of your models.

    require 'data_mapped/model'
    
    class Movie
		include DataMapped::Model
		property :title, String, required: true
		property :description, Text
    end

### Join Model (for a Join Table)

This mixin sets up your class for DataMapper, and adds `@created_at` and
`@updated_at` properties that behave as expected.  This join model differs
from the [normal model](#normal-model) in that the join model doesn't add an
`@id` property, as it expects for your class to define a composite primary key
using `#belongs_to` relationships.

**Rationale**: Tightly control your many-to-many associations.  This is a
helpful pattern to do something to a movie resource any time an actor is
associated with it.

	require 'data_mapped/join'
	require 'data_mapped/model'
    
	class Movie
		include DataMapped::Model
		property :title, String, required: true
		property :description, Text
		has n, :actors, through: Resource
	end
    
	class Actor
		include DataMapped::Model
		property :name, String, required: true
		has n, :movies, through: Resource
	end
    
	class ActorMovie
		include DataMapped::Join
		belongs_to :actor, key: true
		belongs_to :movie, key: true
	end

**Integration note**: Your join model class name must be a
[Pascal case](http://c2.com/cgi/wiki?PascalCase), alphabetized concatenation
of the names of the two models that you're joining.  Internally, DataMapper
introspects your join model class name and uses it to determine the name of
the join table in your database.

### Permanent Model (that Can't be Destroyed)

This mixin prevents resources of your class from being destroyed (at least in
the typical fashion using
[`#destroy`](http://rubydoc.info/github/datamapper/dm-core/master/DataMapper/Resource#destroy-instance_method)).
It's meant to be used in conjunction with either the
[normal model](#normal-model) or the
[join model](#join-model-for-a-join-table) mixin.

**Rationale**: Prevent accidentally deleting resources that shouldn't be
deleted, if you have itchy fingers and play around too much in `irb` on
production like I do.  Our use case is that movies should be created, read,
and updated, but never deleted.

	require 'data_mapped/model'
	require 'data_mapped/permanent'
	
	class Movie
		include DataMapped::Model
		include DataMapped::Permanent
		property :title, String, required: true
		property :description, Text
	end

**Integration note**: You can still delete permanent models with
[`#destroy!`](http://rubydoc.info/github/datamapper/dm-core/master/DataMapper/Resource#destroy%21-instance_method).
In general, make a practice out of staying away from DataMapper's unsafe bang
(!) methods.  These
[bang methods don't run validators or callbacks](http://datamapper.org/docs/create_and_destroy.html).
:-(

### Searchable Model

This mixin duct tapes your class together with
[Sunspot](http://sunspot.github.io/) and
[Solr](https://lucene.apache.org/solr/), and makes your class's resources
indexed and searchable.  It's meant to be used in conjunction with the
[normal model](#normal-model) mixin.

**Rationale**: Everyone loves full-text search, and this makes it easy to get
DataMapper to talk to Sunspot.  Include this mixin, define your model, then
use
[Sunspot's powerful DSL](http://sunspot.github.io/docs/index.html#Indexing_In_Depth)
to define what should be indexed and how it should be weighted.

	require 'data_mapped/model'
	require 'data_mapped/searchable'
	
	class Movie
		include DataMapped::Model
		include DataMapped::Searchable
		property :title, String, required: true
		property :description, Text
		has n, :actors, through: Resource
		
		searchable auto_index: true, auto_remove: true do
			text :title, boost: 2.0
			text :description
			text :actor_names, boost: 1.5 do
				self.actors.map(&:name).join(', ')
			end
		end
	end
	
	class Actor
		include DataMapped::Model
		property :name, String, required: true
		has n, :movies, through: Resource
	end



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
