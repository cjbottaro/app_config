require 'app_config'

::AppConfig = ApplicationConfiguration.new("#{Rails.root}/config/app_config.yml",
                                           "#{Rails.root}/config/environments/#{Rails.env}.yml")