#-----------------------------------------------------------------------------#
#   permanent.rb                                                              #
#                                                                             #
#   Copyright (c) 2013, Rajiv Bakulesh Shah.                                  #
#-----------------------------------------------------------------------------#



require 'data_mapper'



module DataMapped
  module Permanent

    module InstanceMethods
      def vomit_before_destruction
        DataMapper::logger.error '[ERROR] permanent model resource cannot be deleted'
        throw :halt
      end
    end

    DataMapper::Model.append_inclusions(InstanceMethods)

    def self.included(other)
      other.class_eval do
        before :destroy, :vomit_before_destruction
      end
    end

  end
end
