# dokku firefox

A headless browser service with firefox and geckodriver for dokku.

This is largely inspired by [dokku-chrome](https://github.com/lazyatom/dokku-chrome) and takes most of 
the code from it.

This service runs a firefox + geckodriver browser via the [instrumentisto/geckodriver](https://hub.docker.com/r/instrumentisto/geckodriver) image from Docker. This image is kindly provided by [browserless](https://browserless.io),

## Requirements

- dokku 0.8.1+
- docker 1.8.x

## Installation

```shell
# on 0.4.x+
sudo dokku plugin:install https://github.com/yageek/dokku-firefox.git firefox
```

## Commands

```
firefox:app-links <app>          List all chrome service links for a given app
firefox:create <name>            Create a chrome service with environment variables
firefox:destroy <name>           Delete the service, delete the data and stop its container if there are no links left
firefox:enter <name> [command]   Enter or run a command in a running chrome service container
firefox:exists <service>         Check if the chrome service exists
firefox:expose <name> [port]     Expose a chrome service on custom port if provided (random port otherwise)
firefox:info <name>              Print the connection information
firefox:link <name> <app>        Link the chrome service to the app
firefox:linked <name> <app>      Check if the chrome service is linked to an app
firefox:list                     List all chrome services
firefox:logs <name> [-t]         Print the most recent log(s) for this service
firefox:promote <name> <app>     Promote service <name> as CHROME_URL in <app>
firefox:restart <name>           Graceful shutdown and restart of the chrome service container
firefox:start <name>             Start a previously stopped chrome service
firefox:stop <name>              Stop a running chrome service
firefox:unexpose <name>          Unexpose a previously exposed chrome service
firefox:unlink <name> <app>      Unlink the chrome service from the app
firefox:upgrade <name>           Upgrade service <service> to the specified version
```

## Rsage

```shell
# Create a chrome service named lolipop
dokku firefox:create lolipop

# You can also specify the image and image
# version to use for the service
# it *must* be compatible with the
# official browserless/chrome image
export FIREFOX_IMAGE="browserless/chrome"
export FIREFOX_IMAGE_VERSION="1.6.2"
dokku firefox:create lolipop

# You can also specify custom environment
# variables to start the chrome service
# in semi-colon separated form
export CHROME_CUSTOM_ENV="MAX_CONCURRENT_SESSIONS=10"
dokku firefox:create lolipop

# Get connection information as follows
dokku firefox:info lolipop

# You can also retrieve a specific piece of service info via flags
dokku firefox:info lolipop --config-dir
dokku firefox:info lolipop --data-dir
dokku firefox:info lolipop --dsn
dokku firefox:info lolipop --exposed-ports
dokku firefox:info lolipop --id
dokku firefox:info lolipop --internal-ip
dokku firefox:info lolipop --links
dokku firefox:info lolipop --service-root
dokku firefox:info lolipop --status
dokku firefox:info lolipop --version

# A bash prompt can be opened against a running service
# filesystem changes will not be saved to disk
dokku firefox:enter lolipop

# You may also run a command directly against the service
# filesystem changes will not be saved to disk
dokku firefox:enter lolipop ls -lah /

# A chrome service can be linked to a
# container this will use native docker
# links via the docker-options plugin
# here we link it to our 'playground' app
# NOTE: this will restart your app
dokku firefox:link lolipop playground

# The following environment variables will be set automatically by docker (not
# on the app itself, so they won’t be listed when calling dokku config)
#
#   DOKKU_CHROME_LOLIPOP_NAME=/random_name/CHROME
#   DOKKU_CHROME_LOLIPOP_PORT=tcp://172.17.0.1:3000
#   DOKKU_CHROME_LOLIPOP_PORT_3000_TCP=tcp://172.17.0.1:3000
#   DOKKU_CHROME_LOLIPOP_PORT_3000_TCP_PROTO=tcp
#   DOKKU_CHROME_LOLIPOP_PORT_3000_TCP_PORT=3000
#   DOKKU_CHROME_LOLIPOP_PORT_3000_TCP_ADDR=172.17.0.1
#
# and the following will be set on the linked application by default
#
#   CHROME_URL=http://dokku-chrome-lolipop:3000
#
# NOTE: the host exposed here only works internally in docker containers. If
# you want your container to be reachable from outside, you should use `expose`.

# Another service can be linked to your app
dokku firefox:link other_service playground

# Since CHROME_URL is already in use, another environment variable will be
# generated automatically
#
#   DOKKU_CHROME_BLUE_URL=http://dokku-chrome-other-service:3000

# You can then promote the new service to be the primary one
# NOTE: this will restart your app
dokku firefox:promote other_service playground

# This will replace CHROME_URL with the url from other_service and generate
# another environment variable to hold the previous value if necessary.
# you could end up with the following for example:
#
#   CHROME_URL=http://dokku-chrome-other-service:3000
#   DOKKU_CHROME_BLUE_URL=http://dokku-chrome-other-service:3000
#   DOKKU_CHROME_SILVER_URL=http://dokku-chrome-lolipop:3000

# You can also unlink a chrome service
# NOTE: this will restart your app and unset related environment variables
dokku firefox:unlink lolipop playground

# You can tail logs for a particular service
dokku firefox:logs lolipop
dokku firefox:logs lolipop -t # to tail

# Finally, you can destroy the container
dokku firefox:destroy lolipop
```

## Disabling `docker pull` calls

If you wish to disable the `docker pull` calls that the plugin triggers, you may set the `FIREFOX_DISABLE_PULL` environment variable to `true`. Once disabled, you will need to pull the service image you wish to deploy as shown in the `stderr` output.

Please ensure the proper images are in place when `docker pull` is disabled.

## Thanks

This is largely inspired by [dokku-chrome](https://github.com/lazyatom/dokku-chrome) and takes most of 
the code from it.