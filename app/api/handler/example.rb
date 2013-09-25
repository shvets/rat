class Handler::Example
  include Handler

  def example
    { :message => "Hello World!" }
  end

end
