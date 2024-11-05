# BulletTrain::Domains
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "bullet_train-domains"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install bullet_train-domains
```

To copy over the migrations run:
```bash
bin/rails bullet_train_domains:install:migrations
```

Add the following environment variables:

```
DOMAIN_INTERNAL: example.page
DOMAIN_CNAME: secure.example.page # This is the domain that the cname needs to point to
CLOUDFLARE_ZONE_ID: abcdef # in case you use Cloudflare
CLOUDFLARE_ACCOUNT_ID: abcdef # in case you use Cloudflare
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
