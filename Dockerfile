FROM alpine

LABEL \
  "name"="GitHub Pull Request Action" \
  "homepage"="https://github.com/marketplace/actions/github-pull-request" \
  "repository"="https://github.com/repo-sync/pull-request" \
  "maintainer"="Wei He <github@weispot.com>"

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
  apk add --no-cache git hub bash curl jq

RUN LATEST_VERSION=$(curl --silent https://api.github.com/repos/cli/cli/releases/latest | jq -r '.tag_name' | sed -E 's/v(.+)/\1/') \
  && curl -Lo /tmp/ghlinux.tar.gz https://github.com/cli/cli/releases/download/v${LATEST_VERSION}/gh_${LATEST_VERSION}_linux_amd64.tar.gz \
  && mkdir -p /tmp/gh \
  && tar --strip-components=1 -xf /tmp/ghlinux.tar.gz -C /tmp/gh \
  && cp /tmp/gh/bin/gh /usr/bin/gh \
  && rm -r /tmp/ghlinux.tar.gz /tmp/gh \
  && chmod +x /usr/bin/gh

ADD *.sh /

ENTRYPOINT ["/entrypoint.sh"]
