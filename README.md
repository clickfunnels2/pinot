# Pinot

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add pinot

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install pinot

## Usage

To configure our client, we must have some data about our pinot cluster, its broken and controller host, and which port/protocol both services are using. After having this information, we can setup the client to use it.

```ruby
host = "localhost"
controller_host = "localhost"
client = Pinot::Client.new(host: host, port: 443, protocol: :https, controller_host: controller_host, controller_port: 443)
```

After setting up your client, we can start using it to query the cluster.

```ruby
client.execute("select * from table;")
```

After querying, it returns a `HTTPX::ErrorResponse` in case of any HTTP error, like a timeout, or connection refused, we are returning the client's error to make easier to troubleshoot any problem and handle it accordingly.

In case of success, it returns a `Pinot::Response`, an enumerable where you can interact over the returned rows.

Each row is an array with row's values.

```ruby
result = client.execute("select id, name, age from people;")
result.each do |row|
  puts row[0] # id
  puts row[1] # name
  puts row[2] # age
end
```

If the column names and types are needed, can call `columns` method on the response.

```ruby
result = client.execute("select count(*) from people;")
resp.columns
# {"count(*)"=>"LONG"}
```

It's not on the public API, but the instance variable `@payload` contains all information returned from the Pinot cluster in case can help with troubleshooting

### Query Options

In case there's the need to pass any Pinot [query options](https://docs.pinot.apache.org/users/user-guide-query/query-options), it's can be done when initializing the client.

```ruby
client = Pinot::Client.new(query_options: {use_multistage_engine: true}, **options)
```

Any of the query options on the documentation is supported, remember to use its name with underscore formatting.

### Authentication

In case your pinot cluster is using authentication bearer token, you can specify it on the client constructor

```ruby
client = Pinot::Client.new(bearer_token: "my-secret", **client_args)
```

### Socks5

Using Pinot cluster inside a VPC and need to jump through a bastion host using socks5? We got your back!

```ruby
client = Pinot::Client.new(socks5_uri: "socks5://localhost:80", **client_args)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/clickfunnels2/pinot. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/clickfunnels2/pinot/blob/main/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the Pinot project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/clickfunnels2/pinot/blob/main/CODE_OF_CONDUCT.md).
