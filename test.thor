# file: test.thor
class Test < Thor
  desc "example", "an example task"
  def example
    puts "I'm a thor task!"
  end
end

