## Ferver = File-Server

#### Ferver: A simple web app to serve files over HTTP packaged as a Ruby gem.

[![Build Status](https://travis-ci.org/rob-murray/ferver.svg?branch=master)](https://travis-ci.org/rob-murray/ferver)
[![Code Climate](https://codeclimate.com/github/rob-murray/ferver.png)](https://codeclimate.com/github/rob-murray/ferver)
[![Coverage Status](https://coveralls.io/repos/rob-murray/ferver/badge.svg?branch=master&service=github)](https://coveralls.io/github/rob-murray/ferver?branch=master)
[![Dependency Status](https://gemnasium.com/rob-murray/ferver.svg)](https://gemnasium.com/rob-murray/ferver)
[![Gem Version](https://badge.fury.io/rb/ferver.svg)](http://badge.fury.io/rb/ferver)

### Description

This is super, simple ruby gem to serve files over **http**, useful as a basic file server to quickly share files on your local network or something over the web. Just install the gem and go!

Here's the spec for **ferver**:

* available over http
* provide a list of files as html and json
* ignore directories
* ignore dotfiles - turn off with setting
* serve files as individual files
* minimal config
* able to specify the directory to serve files from

### Getting started

Using **ferver** could not be simpler - just install the **ferver** gem.

```bash
$ gem install ferver
```

### Usage

You can run **ferver** from any directory, just pass in the directory you want to serve files from as a command line argument or leave blank to use the current directory.

##### Use the current directory

```bash
$ ferver
````

##### Use a specific directory

For exmple, to serve files from **/Users/rob/Projects/ferver/** directory pass the path in as below using the `--directory` option.

```bash
$ ferver -d /Users/rob/Projects/ferver/
````

##### Serve all files

By default, dotfiles will be hidden. Use the `--all` option to serve all files.

```bash
$ ferver -a
````

##### Configure webserver

If required, you can configure the bind address or port number used by the webserver. By default this is `0.0.0.0` and port `4567` which means the server is accessible from outside your machine (if firewall permits). For example if you used the configuration below then it would only be accessible from local machine and on port `9999`.

```bash
$ ferver -p 9999 -b 127.0.0.1
````

> Note that zero size files will always be hidden.

##### Command line help

For a list of arguments just use the `--help` switch.

```bash
$ ferver -h
````

### Accessing files

The **ferver** gem uses [Sinatra](http://www.sinatrarb.com/) and runs on default port configuration so just point your browser to `http://localhost:4567` to list the files.

> If you are unable to connect then please check any firewall settings or the configured bind address or port number!

#### HTML

List available files in your browser.

`http://localhost:4567/files`

#### JSON

Requesting content-type `json`, for example passing the header `Accept: application/json` will return the list of files as json.

```bash
curl -i -H "Accept: application/json" http://localhost:4567/files
```

#### Download a file

Files are available via their zero based index in the list, e.g. `http://localhost:4567/files/:id`

For example to download file appearing third in the list displayed earlier, request `http://localhost:4567/files/2`

### Contributions

Please use the GitHub pull-request mechanism to submit contributions.

After cloning the repo, you can run the web application without having to publish and then install the gem package by calling the executable as per normal.


### License

This project is available for use under the MIT software license.
See LICENSE
