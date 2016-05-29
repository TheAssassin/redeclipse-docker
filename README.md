# Docker container for Red Eclipse server

This repository provides a Dockerfile that allows the creation of containers for Red Eclipse.
This is useful if you want to host more than one server without having to take care of init
scripts, maintaining multiple installations or managing any data storage.

This project contains some of the ideas of the
[Red Eclipse Dockerfile](https://github.com/erasche/docker-recipes/) provided by
[Eric Rasche](https://github.com/erasche/), but has been written from scratch to be more
efficient and more maintainable.

Thanks to [zaquest](https://github.com/zaquest/) for his
[patches and backports](https://github.com/zaquest/repatches/) for Red Eclipse v1.5.3. This
Dockerfile uses the backport of the `/duelmaxqueued` setting and the fix for the IRC relay's
colour filter.

At the moment the Dockerfile builds Red Eclipse v1.5.3 which is the latest stable version that
has been released.


## Usage

The easiest way to persist server configurations and manage your server containers is to use
[docker-compose](https://docs.docker.com/compose/). An example `docker-compose.yml` is included
in this repository.

To use it, just copy it (e.g. `cp docker-compose.yml.example docker-compose.yml`), edit it to
fit your needs and run `docker-compose up`.

All configuration keys in the default `servinit.cfg` are available as uppercase environment
variables and can be set in your `docker-compose.yml`.

A documentation of more complex configurations (like e.g. IRC relay configuration) will
follow as soon as possible.

If you want to host more than one server, you should clone this repository as often as you
need and repeat the steps listed above.
