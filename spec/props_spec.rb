#require 'spec_helper'
#
#require 'stringio'
#
#describe Props do
#  it "should read props file and parse it" do
#    source = StringIO.new <<-TEXT
#      database: database1
#      username: username1
#      password: password1
#    TEXT
#
#    subject.load(source)
#
#    subject['database'].should == 'database1'
#  end
#
#end