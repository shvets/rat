require File.expand_path(File.dirname(__FILE__) + '/../spec/support/spec_conf')

#Spork.prefork -- leave this line for the spork!!!! -- otherwise it will complain

SpecConf.with_spork do
  SpecConf.init_spec
end
