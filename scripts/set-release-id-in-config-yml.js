"use strict";
var configYmlPath = "docs/_config.yml";
var UTF8 = "utf8";

var semver = require("semver");
var fs = require("fs");
var yaml = require("js-yaml");
var releaseId = require("../package.json").version;
var majorVersion = semver.major(releaseId);
var config = yaml.safeLoad(fs.readFileSync(configYmlPath, UTF8));

config.sinon.current_release = "v" + majorVersion; // eslint-disable-line camelcase

fs.writeFileSync(configYmlPath, yaml.safeDump(config), UTF8);
