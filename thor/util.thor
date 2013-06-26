require 'script_executor/executable'

class Util < Thor
  include Executable

  desc "pg_setup", "pg_setup"
  def pg_setup
    execute(:sudo => true) do
      %Q(
        sysctl -w kern.sysv.shmall=65536
        sysctl -w kern.sysv.shmmax=16777216
      )
    end

    execute do
      %Q(
        launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
        launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
      )
    end
  end

  desc "krb", "krb"
  def krb
    execute(:sudo => true) do
      %Q(
        cp /etc/krb5.conf.bad  /etc/krb5.conf
      )
    end
  end

  desc "local_host", "local_host"
  def local_host
   puts get_localhost
  end

  private

  def get_localhost
    orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true # turn off reverse DNS resolution temporarily

    UDPSocket.open do |s|
      s.connect '10.111.54.71', 1
      s.addr.last
    end
  ensure
    Socket.do_not_reverse_lookup = orig
  end
end
