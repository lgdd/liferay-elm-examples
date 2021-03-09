const spawn = require('cross-spawn');
const fs = require('fs');
const rimraf = require('rimraf');

const srcLiferayDir = 'src.liferay';
const srcLiferayFileContent = `// Require webpack bundles generated by create-elm-app build.
const runtime = require("./static/js/runtime~main.js");
const vendors = require("./static/js/vendors~main.chunk.js");
const main = require("./static/js/main.chunk.js");

// Load Elm and runtime engine modules.
runtime();
vendors();

// Require our adapt runtime support module
var _ADAPT_RT_ = require("./adapt-rt");

// Invoke Angular main module passing Liferay's standard entry point arguments.
module.exports = function(_LIFERAY_PARAMS_) {
  main(_LIFERAY_PARAMS_, _ADAPT_RT_);
};`;

if (fs.existsSync('build.liferay')) rimraf.sync('build.liferay');

fs.mkdirSync(srcLiferayDir);

fs.writeFileSync(srcLiferayDir + '/adapt-rt.js', srcLiferayFileContent);
fs.writeFileSync(srcLiferayDir + '/index.js', srcLiferayFileContent);

spawn.sync('yarn', ['run', 'liferay-npm-bundler'], { stdio: 'inherit' });

rimraf('src.liferay', function() {});
