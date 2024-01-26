module Pinot
  class Client
    attr_reader :host, :port, :controller_host, :controller_port, :protocol

    def initialize(host:, port:, controller_port:, controller_host: nil, protocol: :http)
      @host = host
      @port = port
      @controller_port = controller_port
      @controller_host = controller_host || host
      @protocol = protocol
    end

    def execute(sql)
      Response.new(JSON.parse(http.post(query_sql_uri, json: {sql: sql})))
    end

    def schema(name)
      url = "#{controller_uri}/schemas/#{name}"
      response = http.get(url)
      JSON.parse(response)
    end

    def delete_segments(name, type: :offline)
      type = type.to_s.upcase
      url = "#{controller_uri}/segments/#{name}?type=#{type}"
      response = http.delete(url)
      JSON.parse(response)
    end

    def create_table(schema)
      url = "#{controller_uri}/tables"
      response = http.post(url, body: schema)
      JSON.parse(response)
    end

    def delete_table(name, type: :offline)
      type = type.to_s.downcase
      url = "#{controller_uri}/tables/#{name}?type=#{type}"
      response = http.delete(url)
      JSON.parse(response)
    end

    def ingest_json(file, table:)
      url = "#{controller_uri}/ingestFromFile?tableNameWithType=#{table}&batchConfigMapStr=%7B%22inputFormat%22%3A%22json%22%7D"
      content_type = "multipart/form-data"
      response = HTTPX.post(
        url,
        form: {
          file: {
            filename: File.basename(file.path),
            content_type: content_type,
            body: file.read
          }
        }
      )
      JSON.parse(response)
    end

    def create_schema(schema, override: true, force: false)
      url = "#{controller_uri}/schemas?override=#{override}&force=#{force}"
      response = http.post(url, body: schema)
      JSON.parse(response)
    end

    def http(content_type: "application/json")
      HTTPX.with(headers: {"Content-Type" => content_type})
    end

    def uri
      "#{protocol}://#{host}:#{port}"
    end

    def controller_uri
      "#{protocol}://#{controller_host}:#{controller_port}"
    end

    def query_sql_uri
      "#{uri}/query/sql"
    end
  end
end
