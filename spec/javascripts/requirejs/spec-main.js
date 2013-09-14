//var specs = Object.keys(window.__karma__.files).filter(function (file) {
//  return /spec\.js$/.test(file);
//});

var specs = [];

for (var file in window.__karma__.files) {
  if (window.__karma__.files.hasOwnProperty(file)) {
    if (/spec\.js$/.test(file)) {
      specs.push(file);
    }
  }
}

console.log(specs);

requirejs.config({
  // Karma serves files from '/base'
  baseUrl: '/base/app/assets/javascripts/requirejs',

  paths: {
    'jquery': process.env.GEM_HOME + '//gems/jquery-rails-3.0.4/vendor/assets/javascripts/jquery'
  },

  shim: {
    'underscore': {
      exports: '_'
    }
  },
  // Translate CommonJS to AMD
//  cjsTranslate: true,

  // ask Require.js to load these files (all our tests)
  deps: specs,

  // start test run, once Require.js is done
  callback: window.__karma__.start
});

