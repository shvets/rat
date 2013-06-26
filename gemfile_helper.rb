module GemfileHelper
  def ruby19?
    RUBY_VERSION.include? "1.9"
  end

  def linux?
    RUBY_PLATFORM =~ /linux/
  end

  def mac?
    RbConfig::CONFIG["target_os"] =~ /darwin/i
  end
end
