## Ferver = File-Server

[![Build Status](https://travis-ci.org/rob-murray/ferver.png?branch=master)](https://travis-ci.org/rob-murray/ferver) [![Code Climate](https://codeclimate.com/github/rob-murray/ferver.png)](https://codeclimate.com/github/rob-murray/ferver) [![Coverage Status](https://coveralls.io/repos/rob-murray/ferver/badge.png)](https://coveralls.io/r/rob-murray/ferver)

#### Ferver: A simple Ruby app serving files over HTTP

### Description

This is super, simple ruby app to serve files over **http**, useful as a basic file server to quickly share files on your local network or something.

Spec:

* available over http
* provide a list of files as html and json
* serve files as individual files
* minimal config


### Contents

This repository contains the following files:

1. `src/ferver.rb` - the application file
2. `run.rb` - a quick wrapper to 
2. `spec` - the tests

## Pre-requisites

The only Ruby gems required are... wait... and... applause;

* [Sinatra](http://www.sinatrarb.com/)

### Getting started

How to use this util:

Using this could not be simpler, that is the idea... (soon to be even simpler!)

1) Obtain an copy of the app file `src/ferver.rb`, git clone, `wget` or whatever you want.

2) Edit the path to the directory of files to served in config section.

```ruby
FILE_SERVER_DIR_PATH = '/path/to/dir'
```

3) Install the Sinatra gem if not present already;

```bash
gem install sinatra
```

4) Either grab the `run.rb` file or concoct your own `config.ru` file (see Sinatra docs)


** Identify the port used (Hint: see line 4 below) and connect eg: http://localhost:4567/files.html

```bash
Puma 1.6.3 starting...
* Min threads: 0, max threads: 16
* Environment: development
* Listening on tcp://localhost:4567
== Sinatra/1.4.4 has taken the stage on 4567 for development with backup from Puma
```

### Configured routes

Here is how to access the files and file list.

* http://host:port/files.html - will display list of files as html
* http://host:port/files.json - will return list of files in json
* http://host:port/files/:id e.g. http://localhost:4567/files/2 - will initiate download of file id



### Contributions

Please use the GitHub pull-request mechanism to submit contributions.

### License

This project is available for use under the MIT software license.
See LICENSE