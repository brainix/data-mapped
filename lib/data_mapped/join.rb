#-----------------------------------------------------------------------------#
#   join.rb                                                                   #
#                                                                             #
#   Copyright (c) 2013, Rajiv Bakulesh Shah.                                  #
#-----------------------------------------------------------------------------#



require 'data_mapper'



module DataMapped
  module Join

    def self.included(other)
      other.class_eval do
        include DataMapper::Resource
        property :created_at, DataMapper::Property::DateTime
        property :updated_at, DataMapper::Property::DateTime
      end
    end

  end
end
