FROM ghcr.io/gsmlg-dev/phoenix:alpine AS builder

ARG MIX_ENV=prod
ARG NAME=duskmoon_storybook
ARG RELEASE_VERSION=1.0.0

COPY . /build
WORKDIR /build

RUN <<EOF
apk update
mix deps.get
npm install
export project_dir=$(pwd)
cd $project_dir/apps/phoenix_duskmoon
mix tailwind.install
mix prepublish
cd $project_dir/apps/duskmoon_storybook_web
mix assets.deploy
cd $project_dir
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
