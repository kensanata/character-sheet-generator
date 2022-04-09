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

```
./character-sheet-generator random > test.svg
```

Run a web service at localhost:3040:

```
make run
```

The config file in the working directory assumes that the
[Face Generator](https://alexschroeder.ch/cgit/face-generator) is
running on port 3020. If you check it out and run it locally, that
should be the default port.

```
make run
```

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

```
sudo apt-get install git libmojolicious-perl \
  libi18n-acceptlanguage-perl libxml-libxml-perl
```

I fear the default Mojolicious package might be too old, though. The
last time these lines were checked, I used 7.09. Here's how to check
the version you have installed:

```
perl -mMojolicious -e 'print "$Mojolicious::VERSION\n";'
```

If you you want to upgrade and you have never developed Perl code, you
might want to do the following:

```
apt-get install liblocal-lib-perl cpanminus
echo 'eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"' >>~/.bashrc
cpanm Mojolicious
```

This should install the lastest Mojolicious in you `~/perl5` directory
without requiring root permissions, and it should have added the
necessary environment variable settings to your shell init script.

## Installation

### Home Use

If you just want to tinker with it at home, here's what I suggest:

```
mkdir ~/src
cd ~/src
git clone https://github.com/kensanata/halberdsnhelmets.git
cd ~/src/halberdsnhelmets/Characters
MOJO_HOME=. perl halberdsnhelmets.pl daemon
```

If everything went according to plan, you should see output like the
following:

```
[Thu Dec  8 14:38:59 2016] [info] Listening at "http://*:3000"
Server available at http://127.0.0.1:3000
```

Visit the link and you should see the application. If you do not,
contact me and we'll figure it out.

### Tinkering at Home

If you want to tinker with the code, use `morbo` to run the
application because that will restart the application every time you
make a change.

```
MOJO_HOME=. morbo halberdsnhelmets.pl daemon
```

### Production

This runs the script as a server on port 8080, writing a pid file:

```
hypnotoad halberdsnhelmets.pl
```

Whenever you repeat this `hypnotoad` command, the server will be
restarted. There's no need to kill it.

You can configure `hypnotoad` to listen on a different port by adding
an additional item to the config file, `halberdsnhelmets.conf`. Here's
an example:

```
{
  hypnotoad => {listen => ['http://*:8083'],},
}
```

This is great for production. If you have multiple Mojolicious
applications, you can either run them all with their own Hypnotoad, or
you can use [Toadfarm](https://metacpan.org/pod/Toadfarm).

## Images

The character portraits are made by
the [face generator](https://campaignwiki.org/face). If you install
the character generator on a website using HTTPS, then you will have
to install the face generator in the same domain, because browsers
will refuse to download images from a different domain when using
HTTPS.

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
