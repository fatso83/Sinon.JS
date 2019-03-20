#!/bin/sh

# exit on error
set -e

PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
SINON_CHROME_BIN=/usr/bin/google-chrome-unstable

echo Setup
npm config set strict-ssl false
#npm install # need to uncomment this when editing mochify to pass `dumpio: true`

# Download Chrome 71
#wget -O google-chrome-stable_v71.deb https://www.slimjet.com/chrome/download-chrome.php?file=files%2F71.0.3578.80%2Fgoogle-chrome-stable_current_amd64.deb
#dpkg -i google-chrome-stable_v71.deb

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google.list
apt-get -qq update
apt-get -qq install -y --no-install-recommends google-chrome-stable
apt-get -qq install -y --no-install-recommends google-chrome-unstable

echo Pre-Test
# Hangs here after successfull test run
npm run test-headless -- --chrome $(which google-chrome-stable) --allow-chrome-as-root

npm run test-webworker -- --chrome $(which google-chrome-stable) --allow-chrome-as-root
npm run test-esm-bundle

npm run test-node
