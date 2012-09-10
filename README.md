ruby-http-file-server
=====================

# A simple Ruby app serving files over HTTP

## Description

This is super simple ruby app to serve files over http, useful as a basic file server to quickly share files

Spec:

* use http
* provide a list of files as html and json
* serve files as individual files
* minimal config


## Contents

This repository contains the following files:

1. http-file-server.rb - the application file

## Pre-requisites

The only Ruby gems required are;

* sinatra
* json

## Getting started

How to use:

Using this could not be simpler, that is the idea...

1) Obtain an copy of the app, git clone or whatever

2) Edit the path to the directory of files to served in config section

```
FILE_SERVER_DIR_PATH = '/path/to/dir'
```

3) Download any pre-requisite gems that are required;

```
gem install sinatra
gem install json
```

4) Fire up the app with this simple line

```
ruby http-file-server.rb
```

4) Identify the port used (Hint: see line 3) and connect eg: http://localhost:4567/files.html

```
[2012-09-07 22:12:51] INFO  WEBrick 1.3.1
[2012-09-07 22:12:51] INFO  ruby 1.9.3 (2012-04-20) [i686-linux]
== Sinatra/1.3.3 has taken the stage on 4567 for development with backup from WEBrick
[2012-09-07 22:12:51] INFO  WEBrick::HTTPServer#start: pid=4060 port=4567
```

## Configured routes

* http://host:port/files.html - will display list of files as html
* http://host:port/files.json - will return list of files in json
* http://host:port/files/:id eg http://localhost:4567/files/2 - will initiate download of file id



## Contributions

Please use the GitHub pull-request mechanism to submit contributions.

## License

This project is available for use under the MIT software license.
See LICENSE