require 'fileutils'
require 'yaml'

class Mombi
  VERSION = '0.0.1'

  @@configfile = File.expand_path('~/.config/mombi/config.yaml')
  @@defaults  = {
      :port     => 8080,
      :duration => 3,
      :interval => 90,
      :blast    => 5,
  }
  @@config = {}
  @@overrides = {}

  def self.configpath
    @@configfile
  end

  def self.configpath=(path)
    @@configfile = File.expand_path(path)
  end

  def self.set(setting, value)
    @@config[setting] = value
  end

  def self.override(setting, value)
    @@overrides[setting] = value
  end

  def self.config
    @@config
  end

  def self.overrides
    @@config.merge(@@overrides)
  end

  def self.loadconfig
    @@config = @@defaults.merge(YAML.load_file(@@configfile)).merge(@@config)
  end

  def self.save
    File.open(@@configfile, File::RDWR|File::CREAT, 0644) do |file|
      file.flock(File::LOCK_EX)
      file.write(@@config.to_yaml)
      file.flush
      file.truncate(file.pos)
    end
  end

end
