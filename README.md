# hugo-docker

The minimalist of docker images for Hugo!

Clocking in at about 4MB this docker image contains
a `hugo` binary and nothing else!

Also, automated builds will be off until https://hub.docker.com
updates their version of docker to a version that supports
multi-stage docker builds.

## Example Usage

### Statically generate your site!

NOTE: Site located at `$(pwd)`

```shell
docker run --rm -v "$(pwd):/v -w /v seemethere/hugo-docker
```

Static site generated at "$(pwd)/public"

## TODO

- [ ] Figure out why the development server isn't working
