require 'data_mapper'



module DataMapped
  module Model

    def self.included(other)
      other.class_eval do
        include DataMapper::Resource
        property :id, DataMapper::Property::Serial
        property :created_at, DataMapper::Property::DateTime
        property :updated_at, DataMapper::Property::DateTime
      end
    end

  end
end
