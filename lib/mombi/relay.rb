require 'yaml'

class Mombi::Relay
  def initialize(configfile)
    @configfile = configfile
    reload

    Thread.new do
      loop do
        sleep @config[:interval]
        puts "futzing for #{@config[:duration]} seconds."
      end
    end

  end

  def reload
    @config = YAML.load_file(@configfile) rescue {}
  end

  def blast
    puts 'blasting'
  end

end
