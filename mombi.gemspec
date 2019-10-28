$:.unshift File.expand_path("../lib", __FILE__)
require 'mombi'
require 'date'

Gem::Specification.new do |s|
  s.name              = "mombi"
  s.version           = Mombi::VERSION
  s.date              = Date.today.to_s
  s.summary           = "A remote control and configuration utility for our pumpkinhead."
  s.homepage          = "https://github.com/binford2k/mombi"
  s.license           = 'Apache-2.0'
  s.email             = "binford2k@gmail.com"
  s.authors           = ["Ben Ford"]
  s.require_path      = "lib"
  s.executables       = %w( mombi )

  s.files             = %w( LICENSE README.md CHANGELOG.md )
  s.files            += Dir.glob("lib/**/*")
  s.files            += Dir.glob("bin/**/*")
  s.files            += Dir.glob("views/**/*")
  s.files            += Dir.glob("public/**/*")

  s.add_dependency      "rpi_gpio"
  s.add_dependency      "sinatra"

  s.description       = File.read(File.join(File.dirname(__FILE__), 'README.md'))
end
