require 'yaml'
# require 'rpi_gpio'

PIN_NUM = 15

class Mombi::Relay
  def initialize(configfile, debug=false)
    @configfile = configfile
    @debug      = debug
    setup_gpio
    reload

    $thing = self

    loop do
      sleep @config[:interval]
      turn_on(@config[:duration])
    end

  end

  def reload
    debug("Reloading config.")
    # cannot flock within a signal handler
    @config = YAML.load_file(@configfile) rescue {}
  end

  def blast
    puts 'blasting'
    turn_on(@config[:blast])
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

  Signal.trap("SIGHUP") {
    $thing.reload
  }

  Signal.trap("SIGALRM") {
    $thing.blast
  }
end
