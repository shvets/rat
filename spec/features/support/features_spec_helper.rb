require File.expand_path("#{File.dirname(__FILE__)}/../../support/spec_conf")

SpecConf.with_spork do
  @@support = SpecConf.init_features_spec
end