# Dominion Tournament

[![Build Status](https://circleci.com/gh/autopp/dominion_tournament.svg?style=shield&circle-token=59a34b90560a1c510e5a0e096d9b68f12b8e4e29)](https://circleci.com/gh/autopp/dominion_tournament)

A simple web application for swiss-system tournament of dominion.

## Environment

Tested at:

- OS X 10.12.3
- Ruby 2.3.3
- Bunder 1.14.3

## Run

```
$ git clone git@github.com:autopp/dominion_tournament.git && cd dominion_tournament
$ bundle install --path vendor/bundle
$ bundle exec rake db:migrate
$ bundle exec rails s -b 0.0.0.0
```

## License
MIT License.

This application uses some code of [Rails Tutorial (Copyright (c) 2016 Michael Hartl)](https://bitbucket.org/railstutorial/sample_app_4th_ed/src/521772b63b80da4f6b62ce3bccf98e9fdbf7f98f/LICENSE.md?fileviewer=file-view-default).

## Author

[AuToPP](https://twitter.com/AuToPP)
