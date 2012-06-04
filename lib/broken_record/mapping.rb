require_relative "composable"

module BrokenRecord
  module Mapping
    include Composable

    def initialize(params)
      features << RowMapper.new(params)
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      include Composable

      def map_to_table(table_name)
        features << TableMapper.new(:name         => table_name,
                                    :db           => BrokenRecord.database,
                                    :record_class => self)
      end
    end
  end
end
