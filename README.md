## Ferver = File-Server

#### Ferver: A simple web app to server files over HTTP packaged as a Ruby gem.

[![Build Status](https://travis-ci.org/rob-murray/ferver.png?branch=master)](https://travis-ci.org/rob-murray/ferver) [![Code Climate](https://codeclimate.com/github/rob-murray/ferver.png)](https://codeclimate.com/github/rob-murray/ferver) [![Coverage Status](https://coveralls.io/repos/rob-murray/ferver/badge.png)](https://coveralls.io/r/rob-murray/ferver) [![Dependency Status](https://gemnasium.com/rob-murray/ferver.png)](https://gemnasium.com/rob-murray/ferver)

### Description

This is super, simple ruby gem to serve files over **http**, useful as a basic file server to quickly share files on your local network or something. Just install the gem and go!

Here's the spec for **ferver**:

* available over http
* provide a list of files as html and json
* ignore directories
* serve files as individual files
* minimal config
* able to specify the directory to serve files from

### Getting started

Using **ferver** could not be simpler; 

Install the **ferver** gem

```bash
$ gem install ferver
```

### Usage

You can run **ferver** from any directory, just pass in the directory you want to serve files from or if leave blank to use the current directory.

##### Use the current directory

```bash
$ ferver
````

##### Use a specific directory

For exmple, to serve files from **/Users/rob/Projects/ferver/** directory pass the path in as below;

```bash
# Serve files from a specific directory
$ ferver /Users/rob/Projects/ferver/
````

### Accessing files

The **ferver** gem uses [Sinatra](http://www.sinatrarb.com/) and runs on default port configuration so just point your browser to `http://localhost:4567` to list the files.

#### HTML

`http://localhost:4567/files` - List available files

#### JSON

Passing the header `Accept: application/json` will return the list of files as json.

```bash
curl -i -H "Accept: application/json" http://localhost:4567/files
```

#### Download a file

Files are available via their index in the list, e.g. `http://localhost:4567/files/:id`

For example to download file appearing third in the list displayed earlier, request `http://localhost:4567/files/2`

### Contributions

Please use the GitHub pull-request mechanism to submit contributions.

### License

This project is available for use under the MIT software license.
See LICENSE
