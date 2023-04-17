FROM gsmlg/phoenix:alpine AS builder

ARG MIX_ENV=prod
ARG NAME=duskmoon_storybook
ARG RELEASE_VERSION=0.1.0

COPY . /build
WORKDIR /build

RUN apk update \
    && mix do deps.get, compile \
    && cd apps/phoenix_duskmoon && mix tailwind.install && cd ../.. \
    && cd apps/phoenix_duskmoon && npm install && mix prepublish && cd ../.. \
    && cd apps/duskmoon_storybook_web && npm install --prefix assets && mix assets.deploy && cd ../.. \
    && mix release storybook --version "${RELEASE_VERSION}" \
    && cp -r _build/prod/rel/storybook /app

FROM gsmlg/alpine:latest

ARG RELEASE_VERSION=0.1.0

LABEL maintainer="GSMLG <gsmlg.com@gmail.com>"
LABEL RELEASE_VERSION="${RELEASE_VERSION}"

ENV PORT=80 \
    REPLACE_OS_VARS=true \
    ERL_EPMD_PORT=4369 \
    POD_IP=127.0.0.1 \
    ERLCOOKIE=duskmoon_storybook \
    HOST=duskmoon-storybook.gsmlg.dev \
    POOL_SIZE=10 \
    PHX_SERVER=true \
    SECRET_KEY_BASE=duskmoon_storybook

COPY --from=builder /app /app

EXPOSE 80

CMD ["/app/bin/storybook", "start"]
