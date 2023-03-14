# Purpose

This application fetches all _inactive_ campaigns _starting in 2022_ from Platform161, using their REST API.

# Requirements

The application runs with Ruby 2.6+. Required gems are defined in file `Gemfile`, which requires Bundler.
To install Bundler, manually run:
```
$ gem install bundler
```

Replace the dummy password once in `config/platform161.yml` (line 5).

# Usage

Simply run the following command line:
```
$ ruby list_campaigns.rb
```

# To do

Not sure this app exactly works as expected, so we still need to add some testing, I guess..