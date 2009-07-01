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
    @config = convert(conf)
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
  
  # Recursively converts Hashes to ClosedStructs (including Hashes inside Arrays)
  def convert(h) #:nodoc:
    s = ClosedStruct.new(h.keys)
    h.each do |k, v|
      if v.instance_of?(Hash)
        s.send( (k+'=').to_sym, convert(v))
      elsif v.instance_of?(Array)
        converted_array = v.collect { |e| e.instance_of?(Hash) ? convert(e) : e }
        s.send( (k+'=').to_sym, converted_array)
      else
        s.send( (k+'=').to_sym, v)
      end
    end
    s
  end
  
  # Recursively merges hashes.  h2 will overwrite h1.
  def recursive_merge(h1, h2) #:nodoc:
    h1.merge(h2){ |k, v1, v2| v2.kind_of?(Hash) ? recursive_merge(v1, v2) : v2 }
  end
  
end