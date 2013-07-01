require "highline"

module CommonLib

  private

  def ask_password user
    @terminal.ask("Enter password for #{user}: ") { |q| q.echo = "*" }
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

  def get_localhost
    orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true # turn off reverse DNS resolution temporarily

    UDPSocket.open do |s|
      s.connect '192.168.1.1', 1
      s.addr.last
    end
  ensure
    Socket.do_not_reverse_lookup = orig
  end

  def localhost? hostname
    ['localhost', get_localhost].include?(hostname)
  end

end