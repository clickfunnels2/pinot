module Pinot
  class Client
    class QueryOptions
      class InvalidOption < StandardError; end

      OPTIONS = [:timeout_ms, :enable_null_handling, :explain_plan_verbose, :use_multistage_engine, :max_execution_threads, :num_replica_groups_to_query, :min_segment_group_trim_size, :min_server_group_trim_size, :skip_indexes, :skip_upsert, :use_star_tree, :and_scan_reordering, :max_rows_in_join, :in_predicate_pre_sorted, :in_predicate_lookup_algorithm, :max_server_response_size_bytes, :max_query_response_size_bytes]

      OPTIONS.each do |opt|
        attr_reader opt
      end

      def initialize(options = {})
        process_options_hash(options)
      end

      def available_options
        OPTIONS
      end

      def to_query_options
        query_options = []
        available_options.each do |opt|
          if (value = send(opt))
            query_options << "#{camelize_option(opt)}=#{value}"
          end
        end

        return nil if query_options.empty?

        query_options.join(";")
      end

      private

      # avoid monkeypatch String#camelize
      def camelize_option(option)
        string = option.to_s
        string = string.sub(/^(?:(?=\b|[A-Z_])|\w)/) { |match| match.downcase }
        string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub("/", "::")
      end

      def process_options_hash(options)
        options.each_pair do |k, v|
          raise InvalidOption.new("`#{k}' is not a valid option for Pinot Client") unless available_options.include?(k.to_sym)

          instance_variable_set(:"@#{k}", v)
        end
      end
    end
  end
end
