require 'app_config'

::AppConfig = ApplicationConfiguration.new(RAILS_ROOT+"/config/app_config.yml",
                                           RAILS_ROOT+"/config/environments/#{RAILS_ENV}.yml")