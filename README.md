# Character Generator

This is the source repository for a Halberds & Helmets character
generator.

The character generator is currently
[installed on Campaign Wiki](http://campaignwiki.org/halberdsnhelmets).
Take a look at the Help page. It comes with links to examples of what
this web application can do.

If you want to report bugs, provide feedback, fix typos or collaborate
in any other way, feel free to
[contact me](https://alexschroeder.ch/wiki/Contact).

## Running it locally

Generate an SVG file:

```sh
./character-sheet-generator random > test.svg
```

Run a web service at localhost:3040:

```sh
make run
```

## Face Generator

You can run the
[Face Generator](https://alexschroeder.ch/cgit/face-generator)
and use its faces. Check it out and run it locally.

```sh
make run
```

It runs on port 3020. Change the local config file for the Character
Sheet Generator and add the Face Generator URL:

```perl
{
  loglevel => 'info',
  contrib => 'share',
  face_generator_url => "http://localhost:3020",
}
```

Now you can start the Character Sheet Generator and it uses the images
generated by the running Face Generator.

```sh
make run
```

For production you would of course not use "localhost" for the URL,
but the actual URL where Face Generator is available.

Note that if you install the character sheet generator on a website
using HTTPS, then you have to install the face generator in the same
domain, because browsers refuse to download images from a different
domain when using HTTPS.

## Posting 20 Characters to Campaign Wiki

Example (English):

```bash
for i in $(seq 20); do
	f=$(mktemp /tmp/char.XXXX)
	character-sheet-generator random > $f
	name=$(grep name: $f | cut -c 7-)
	class=$(grep class: $f | cut -c 8-)
	if curl --head --silent "https://campaignwiki.org/wiki/Greyheim/$name" | grep --silent "^HTTP/1.1 404"; then
		echo "|[[$name]] | | 0| 0| $class 1| ?|[[Greyheim]] | – | |"
		curl -F ns=Greyheim -F title=$name -F frodo=1 -F username=Alex -F summary="New character" -F "text=<$f" https://campaignwiki.org/wiki
		sleep 1
	fi
done
```

## Dependencies

The CGI script depends on [Mojolicious](http://mojolicio.us/) and some
other Perl modules. You can install everything via `cpan` or `cpanm`,
or if you're on a Debian system, try the following:

```sh
sudo apt-get install git libmodern-perl-perl \
  libmojolicious-perl libi18n-acceptlanguage-perl \
  libfile-sharedir-perl libfile-slurper-perl \
  libxml-libxml-perl
```

## Development

If you want to tinker with the code, use `morbo` to run the
application because that restarts the application every time you make
a change.

```sh
morbo script/character-sheet-generator
```

### Production

This runs the script as a server on port 8080, writing a pid file:

```sh
hypnotoad script/character-sheet-generator
```

Whenever you repeat this `hypnotoad` command, the server will be
restarted. There's no need to kill it.

You can configure `hypnotoad` to listen on a different port by adding
an additional item to the config file,
`character-sheet-generator.conf`. Here's an example:

```perl
{
  hypnotoad => {listen => ['http://*:8083'],},
}
```

This is great for production. If you have multiple Mojolicious
applications, you can either run them all with their own Hypnotoad, or
you can use [Toadfarm](https://metacpan.org/pod/Toadfarm).

## Docker

### Quickstart

If you don’t know anything about Docker, this is how you set it up.

```bash
# install docker on a Debian system
sudo apt install docker.io
# add the current user to the docker group
sudo adduser $(whoami) docker
# if groups doesn’t show docker, you need to log in again
su - $(whoami)
```

### Running the latest Character Sheet Generator

There is a Dockerfile in the repository. Check out the repository,
change into the working directory, and build a docker image, tagging
it `test/character-sheet-generator`:

```bash
git clone https://alexschroeder.ch/cgit/character-sheet-generator
cd character-sheet-generator
docker build --tag test/character-sheet-generator .
```

If you remove the `--notest` argument in the Dockerfile, this is a
good way to check for missing dependencies. 😁

To run the application on it:

```bash
docker run --publish=3020:3020 --publish=3040:3040 test/character-sheet-generator
```

This runs the web application in the container and has it listen on
`http://127.0.0.1:3040` – and you can access it from the host.
