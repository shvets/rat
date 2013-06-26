require "highline"

module CommonLib

  private

  def ask_password user
    @terminal.ask("Enter password for #{user}:  ") { |q| q.echo = "*" }
  end

  def terminal
    @terminal ||= HighLine.new
  end

  def snow_leopard?
    RUBY_PLATFORM =~ /darwin10.8.0/
  end

  def mountain_lion?
    RUBY_PLATFORM =~ /darwin12.3.0/
  end

end