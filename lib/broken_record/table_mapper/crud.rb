module BrokenRecord
  class TableMapper
    class CRUD
      def initialize(mapper)
        @mapper       = mapper
      end

      def create(params)
        raise unless record_class.new(:mapper => mapper,
                                      :fields => params).valid?

        id = table.insert(params)    
      
        find(id)
      end

      def update(id, params)
        raise unless record_class.new(:mapper => mapper,
                                      :fields => params,
                                      :key    => id).valid?

        table.update(:where  => { table.primary_key => id },
                     :fields => params)
      end

      def find(id)
        fields = table.where(table.primary_key => id).first

        return nil unless fields

        record_class.new(:mapper => mapper,
                         :fields => fields,
                         :key    => id)
      end

      def where(params)
        rows = table.where(params)

        rows.map do |fields|
          record_class.new(:mapper  => mapper,
                           :fields  => fields,
                           :key     => fields[table.primary_key])
        end
      end

      def destroy(id)
        table.delete(table.primary_key => id)
      end

      def all
        table.all.map do |e| 
          record_class.new(:mapper  => mapper,
                           :fields  => e,
                           :key     => e[table.primary_key])
        end
      end

      private

      attr_reader :mapper

      def table
        mapper.table
      end

      def record_class
        mapper.record_class
      end
    end
  end
end