#-----------------------------------------------------------------------------#
#   searchable.rb                                                             #
#                                                                             #
#   Copyright (c) 2013, Rajiv Bakulesh Shah.                                  #
#-----------------------------------------------------------------------------#



require 'active_support/all'
require 'data_mapper'
require 'sunspot'
require 'sunspot/rails'



module DataMapped
  module Searchable

    class DataAccessor < Sunspot::Adapters::DataAccessor
      def load(id)
        @clazz.get(id)
      end

      def load_all(ids)
        @clazz.all(id: ids)
      end
    end

    class InstanceAdapter < Sunspot::Adapters::InstanceAdapter
      def id
        @instance.id
      end
    end

    def self.included(other)
      other.class_eval { alias_method(:new_record?, :new?) }
      other.extend Sunspot::Rails::Searchable::ActsAsMethods
      Sunspot::Adapters::DataAccessor.register(DataAccessor, other)
      Sunspot::Adapters::InstanceAdapter.register(InstanceAdapter, other)

      other.class.instance_eval do
        %w[before_save after_save after_destroy].each do |method_name|
          define_method(method_name) do |*args, &block|
            preposition, verb = method_name.split('_').map(&:to_sym)
            method(preposition).call(verb, *args, &block)
          end
        end
      end

      def other.find_in_batches(options = {})
        batch_size, total, offset = options.delete(:batch_size), count, 0
        while offset < total
          yield all(offset: offset, limit: batch_size)
          offset += batch_size
        end
      end

      def other.logger
        ::DataMapper.logger
      end
    end

    def reindex
      Sunspot.index(self)
      Sunspot.commit
    end

  end
end
