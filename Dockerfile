FROM ghcr.io/gsmlg-dev/phoenix:alpine AS builder

ARG MIX_ENV=prod
ARG NAME=duskmoon_storybook
ARG RELEASE_VERSION=1.0.0

COPY . /build
WORKDIR /build

RUN <<EOF
set -ex
apk update
mix deps.get
npm install
sed -i 's%@version "[0-9\.]\+"%@version "${RELEASE_VERSION}"%' mix.exs;
sed -i 's%@version "[0-9\.]\+"%@version "${RELEASE_VERSION}"%' apps/duskmoon_storybook_web/mix.exs;
sed -i 's%@version "[0-9\.]\+"%@version "${RELEASE_VERSION}"%' apps/duskmoon_storybook/mix.exs;
sed -i 's%@version "[0-9\.]\+"%@version "${RELEASE_VERSION}"%' apps/phoenix_duskmoon/mix.exs;
cd /build/apps/phoenix_duskmoon
mix prepublish
cd /build/apps/duskmoon_storybook_web
mix tailwind.install
mix assets.deploy
cd /build
mix release storybook --version "${RELEASE_VERSION}"
cp -r _build/prod/rel/storybook /app
EOF

FROM ghcr.io/gsmlg-dev/alpine:latest

ARG RELEASE_VERSION=1.0.0

LABEL maintainer="GSMLG <gsmlg.com@gmail.com>"
LABEL RELEASE_VERSION="${RELEASE_VERSION}"

LABEL org.opencontainers.image.source="https://github.com/gsmlg-dev/phoenix-duskmoon-ui"
LABEL org.opencontainers.image.description="Duskmoon UI Demo and Storybook"
LABEL org.opencontainers.image.licenses=MIT

ENV PORT=80
ENV REPLACE_OS_VARS=true
ENV ERL_EPMD_PORT=4369
ENV POD_IP=127.0.0.1
ENV ERLCOOKIE=duskmoon_storybook
ENV HOST=duskmoon-storybook.gsmlg.dev
ENV POOL_SIZE=10
ENV PHX_SERVER=true
ENV SECRET_KEY_BASE=duskmoon_storybook

COPY --from=builder /app /app

EXPOSE 80

CMD ["/app/bin/storybook", "start"]
