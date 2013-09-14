// Karma configuration

module.exports = function(config) {
    return config.set({
        // base path, that will be used to resolve all patterns, eg. files, exclude
        basePath: '.',

        // frameworks to use
        frameworks: ['jasmine', 'commonjs'],

        // list of files / patterns to load in the browser

        files: [
            // external libraries

            // process.env.GEM_HOME + '/gems/jquery-rails-3.0.4/vendor/assets/javascripts/jquery.js',

            // project libraries

            'app/assets/javascripts/commonjs/**/*.js',
            'app/assets/javascripts/*.js',

            // specs

            { pattern: 'spec/javascripts/*_spec.js', included: true },
            { pattern: 'spec/javascripts/*_spec.coffee', included: true },
            { pattern: 'spec/javascripts/*Spec.js.coffee', included: true },
            { pattern: 'spec/javascripts/commonjs/*_spec.js', included: true },

            // fixtures

            'spec/javascripts/fixtures/**/*.html', 'app/assets/javascripts/commonjs/*.js'
        ],

        // list of files to exclude
        exclude: [],

        preprocessors: {
            '**/*.coffee': ['coffee'],
            '**/*.html': ['html2js'],
            'app/assets/javascripts/commonjs/*.js': ['commonjs'],
            'spec/javascripts/commonjs/*_spec.js': ['commonjs'],
            'app/assets/javascripts/*.js': ['coverage']
        },

        //test results reporter to use
        // possible values: 'dots', 'progress', 'junit', 'growl', 'coverage'

        reporters: ['dots', 'coverage'],


        coverageReporter: {
            type: 'html',
            dir: 'coverage'
        },

        port: 9876, // web server port

        colors: true, // enable / disable colors in the output (reporters and logs)

        // level of logging
        // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
        logLevel: config.LOG_INFO,

        //enable / disable watching file and executing tests whenever any file changes

        autoWatch: true,

        // Start these browsers, currently available:
        // - Chrome
        // - ChromeCanary
        // - Firefox
        // - Opera
        // - Safari (only Mac)
        // - PhantomJS
        // - IE (only Windows)
        browsers: ["PhantomJS"],

        // If browser does not capture in given timeout [ms], kill it
        captureTimeout: 60000,

        // Continuous Integration mode
        // if true, it capture browsers, run tests and exit
        singleRun: true,

        // report which specs are slower than 500ms
        // CLI --report-slower-than 500
        reportSlowerThan: 500
    });
};
