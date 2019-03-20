#!/bin/sh

# exit on error
set -e

PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
SINON_CHROME_BIN=/usr/bin/google-chrome-unstable


echo Setup
npm config set strict-ssl false
npm install

# install latest chrome unstable version
if node --version | grep -q '^v10'; then
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list.d/google.list
    apt-get -qq update
    apt-get -qq install -y --no-install-recommends google-chrome-stable
    apt-get -qq install -y --no-install-recommends google-chrome-unstable
fi

echo Pre-Test
if node --version | grep -q '^v10'; then
    npm run lint

    npm run test-headless -- --chrome $(which google-chrome-stable) --allow-chrome-as-root
    npm run test-webworker -- --chrome $(which google-chrome-stable) --allow-chrome-as-root
    npm run test-esm-bundle

    if [ -z "$CIRCLE_PULL_REQUESTS" ]; then
    npm run test-cloud
    fi
fi

npm run test-node
