require 'mombi'
begin
  require 'rpi_gpio'
rescue LoadError
  puts "Failed to load rpi_gpio: this is ok if testing in noop mode."
end

PIN_NUM = 15

class Mombi::Relay
  def initialize
    @logger = Mombi::logger
    @mutex  = Mutex.new

    setup_gpio
    reload

    Thread.new do
      loop do
        sleep Mombi::config[:interval]
        turn_on(Mombi::config[:duration])
      end
    end

  end

  def reload
    @logger.debug("Reloading config.")
    Mombi::loadconfig
  end

  def blast
    turn_on(Mombi::config[:blast])
  end

  def setup_gpio
    return if Mombi::config[:noop]

    RPi::GPIO.set_numbering :board
    RPi::GPIO.setup PIN_NUM, :as => :output
  end

  def turn_on(duration=5)
    return if @mutex.locked?

    @mutex.synchronize do
      @logger.debug("Starting fogger for #{duration} seconds.")
      RPi::GPIO.set_high PIN_NUM unless Mombi::config[:noop]
      sleep duration
      RPi::GPIO.set_low PIN_NUM unless Mombi::config[:noop]
      @logger.debug("Stopping fogger.")
    end
  end

  def debug(message)
    puts message if @debug
  end
end
