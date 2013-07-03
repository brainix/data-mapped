# DataMapped

Ruby mixins for [DataMapper](http://datamapper.org/).



## Installation

Add this line to your application's Gemfile:

    gem 'data_mapped'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install data_mapped



## Usage

### Normal Model

This mixin sets up your class for DataMapper, and adds `id`, `created_at`, and
`updated_at` properties that behave as expected.

    require 'data_mapped/model'
    
    class Movie
		include DataMapped::Model
		property :title, String, required: true, unique: true, unique_index: true
		property :description, Text
		has n, :actors, through: Resource
    end

### Join Model (for a Join Table)

This mixin sets up your class for DataMapper, and adds `created_at` and
`updated_at` properties that behave as expected.  This join model differs from
the normal model (above) in that the join model doesn't add an `id` property,
as it expects for your class to define a composite primary key using
`belongs_to` properties.

	require 'data_mapped/join'
	require 'data_mapped/model'
    
	class Movie
		include DataMapped::Model
		property :title, String, required: true, unique: true, unique_index: true
		property :description, Text
		has n, :actors, through: Resource
	end
    
	class Actor
		include DataMapped::Model
		property :name, String, required: true, unique: true, unique_index: true
		has n, :movies, through: Resource
	end
    
	class ActorMovie
		include DataMapped::Join
		belongs_to :actor, key: true
		belongs_to :movie, key: true
	end

### Permanent Model (that Can't be Destroyed)

This mixin prevents resources of your class from being destroyed (at least in
the typical fashion using
[`#destroy`](http://rubydoc.info/github/datamapper/dm-core/master/DataMapper/Resource#destroy-instance_method)).
It's meant to be used in conjunction with either the normal model or the join
model mixin (above).

	require 'data_mapped/model'
	require 'data_mapped/permanent'
	
	class Movie
		include DataMapped::Model
		include DataMapped::Permanent
		property :title, String, required: true, unique: true, unique_index: true
		property :description, Text
		has n, :actors, through: Resource
	end

### Searchable Model

This mixin duct tapes your class together with
[Sunspot](http://sunspot.github.io/) and
[Solr](https://lucene.apache.org/solr/), and makes your class's resources
indexed and searchable.  It's meant to be used in conjunction with the normal
model mixin (above).

	require 'data_mapped/join'
	require 'data_mapped/model'
	
	class Movie
		include DataMapped::Model
		include DataMapped::Searchable
		property :title, String, required: true, unique: true, unique_index: true
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
		property :name, String, required: true, unique: true, unique_index: true
		has n, :movies, through: Resource
	end



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
