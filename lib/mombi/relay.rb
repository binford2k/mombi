require 'yaml'
# require 'rpi_gpio'

PIN_NUM = 15

class Mombi::Relay
  def initialize(configfile, debug=false)
    @configfile = configfile
    @config     = YAML.load_file(@configfile) rescue {}
    @debug      = debug
    setup_gpio

    Thread.new do
      loop do
        sleep @config[:interval]
        turn_on(@config[:duration])
      end
    end

  end

  def save(params={})
    params.each do |key, value|
      key   = key.to_sym
      value = value.to_i if [:interval, :duration].include? key

      @config[key] = value
    end
    File.write(@configfile, @config.to_yaml)
  end

  def blast
    puts 'blasting'
  end

  def setup_gpio
#     RPi::GPIO.set_numbering :board
#     RPi::GPIO.setup PIN_NUM, :as => :output
  end

  def turn_on(duration=5)
    debug("Starting fogger for #{duration} seconds.")
#     RPi::GPIO.set_high PIN_NUM
    sleep duration
#     RPi::GPIO.set_low PIN_NUM
    debug("Stopping fogger.")
  end

  def debug(message)
    puts message if @debug
  end

end
