module Pinot
  class Response
    include Enumerable

    def initialize(payload)
      @payload = payload
    end

    def rows
      @payload.dig("resultTable", "rows")
    end

    def columns
      names = @payload.dig("resultTable", "dataSchema", "columnNames")
      types = @payload.dig("resultTable", "dataSchema", "columnDataTypes")
      return {} if @payload["exceptions"].any?
      ix = 0
      names ||= []
      names.map do |name|
        ret = [name, types[ix]]
        ix += 1
        ret
      end.to_h
    end

    def each(&block)
      rows.each do |row|
        block.call(row)
      end
    end
  end
end
