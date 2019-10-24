require 'yaml'
require 'rpi_gpio'

PIN_NUM = 15

class Mombi::Relay
  def initialize
    @debug = Mombi::overrides[:debug]
    @mutex = Mutex.new

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
    debug("Reloading config.")
    Mombi::loadconfig
  end

  def blast
    turn_on(Mombi::config[:blast])
  end

  def setup_gpio
    RPi::GPIO.set_numbering :board
    RPi::GPIO.setup PIN_NUM, :as => :output
  end

  def turn_on(duration=5)
    return if @mutex.locked?
    @mutex.synchronize do
      debug("Starting fogger for #{duration} seconds.")
      RPi::GPIO.set_high PIN_NUM
      sleep duration
      RPi::GPIO.set_low PIN_NUM
      debug("Stopping fogger.")
    end
  end

  def debug(message)
    puts message if @debug
  end
end
