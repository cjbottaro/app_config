require 'closed_struct'
require 'yaml'
require 'erb'

class ApplicationConfiguration
  
  # Create a new ApplicationConfiguration object.  <tt>conf_path_1</tt> is the path to your YAML configuration file.
  # If <tt>conf_path_2</tt> is given, the contents are recursively merged with the contents of <tt>conf_path_1</tt>.
  # This allows you to have a "base" configuration with settings that are overrided by "environment specific"
  # (developement, test, production, etc) settings.
  #
  # Ex:
  #  ApplicationConfiguration.new(RAILS_ROOT+"/config/base.yml", RAILS_ROOT+"/environments/#{RAILS_ENV}_config.yml")
  def initialize(conf_path_1, conf_path_2 = nil)
    @conf_path_1, @conf_path_2 = conf_path_1, conf_path_2
    reload!
  end
  
  # Rereads your configuration files and rebuilds your ApplicationConfiguration object.  This is useful
  # for when you edit your config files, but don't want to restart your web server.
  def reload!
    conf1 = load_conf_file(@conf_path_1)
    conf2 = load_conf_file(@conf_path_2)
    conf  = recursive_merge(conf1, conf2)
    @config = ClosedStruct.r_new(conf)
  end
  
  def use_environment!(environment)
    if @config.respond_to?(environment)
      @config = @config.send(environment)
    else
      raise ArgumentError, "environment doesn't exist in app config: #{environment}"
    end
  end
  
private
  
  def method_missing(name, *args)
    if @config.respond_to?(name)
      @config.send(name, *args)
    else
      super
    end
  end
  
  def load_conf_file(conf_path)
    return {} if !conf_path or conf_path.empty?
    File.open(conf_path, "r") do |file|
      YAML.load(ERB.new(file.read).result) || {}
    end
  end
  
  # Recursively merges hashes.  h2 will overwrite h1.
  def recursive_merge(h1, h2) #:nodoc:
    h1.merge(h2){ |k, v1, v2| v2.kind_of?(Hash) ? recursive_merge(v1, v2) : v2 }
  end
  
end