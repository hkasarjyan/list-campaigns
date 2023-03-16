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

# Items Completed
1) Fixed code to make it run and return correct results
2) Implemented using unit test 2 positive functional testcases (see tc_positive.rb)
3) Filled one defect, see bug.report
4) Created TCs for the app. (see Testcases.txt)