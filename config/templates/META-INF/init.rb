ENV['GEM_HOME'] ||= $servlet_context.getRealPath('/WEB-INF/gems')

ENV['BUNDLE_GEMFILE'] ||= $servlet_context.getRealPath('/WEB-INF/Gemfile-jruby')

ENV['BUNDLE_WITHOUT'] = "<%= config[:groups_to_reject].join(':') %>"

ENV['RAILS_ENV'] ||= "<%= config[:rails_env] %>"

