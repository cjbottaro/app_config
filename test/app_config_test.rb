require 'test/unit'
require 'app_config'

class AppConfigTest < Test::Unit::TestCase
  
  def test_missing_files
    config = ApplicationConfiguration.new('not_here1', 'not_here2')
    assert_equal OpenStruct.new, config.instance_variable_get("@config")
  end
  
  def test_empty_files
    config = ApplicationConfiguration.new('test/empty1.yml', 'test/empty2.yml')
    assert_equal OpenStruct.new, config.instance_variable_get("@config")
  end
  
  def test_common
    config = ApplicationConfiguration.new('test/app_config.yml')
    assert_equal 1, config.size
    assert_equal 'google.com', config.server
  end
  
  def test_override
    config = ApplicationConfiguration.new('test/app_config.yml', 'test/development.yml')
    assert_equal 2, config.size
    assert_equal 'google.com', config.server
  end
  
  def test_nested
    config = ApplicationConfiguration.new('test/development.yml')
    assert_equal 3, config.section.size
  end
  
  def test_array
    config = ApplicationConfiguration.new('test/development.yml')
    assert_equal 'yahoo.com', config.section.servers[0].name
    assert_equal 'amazon.com', config.section.servers[1].name
  end
  
  def test_erb
    config = ApplicationConfiguration.new('test/development.yml')
    assert_equal 6, config.computed
  end
  
  def test_recursive_merge
    config = ApplicationConfiguration.new('test/app_config.yml', 'test/development.yml')
    assert_equal 'support@domain.com', config.emails.support
    assert_equal 'webmaster@domain.com', config.emails.webmaster
    assert_equal 'feedback@domain.com', config.emails.feedback
  end
  
  def test_exception_on_non_existant_values
    config = ApplicationConfiguration.new('test/app_config.yml')
    assert_raise(NoMethodError){ config.not_here1 = "blah" }
    assert_raise(NoMethodError){ config.not_here2 }
  end
  
  def test_reload
    config = ApplicationConfiguration.new('test/app_config.yml')
    config.size = 2
    assert_equal 2, config.size
    config.reload!
    assert_equal 1, config.size
  end
  
  def test_environments
    config = ApplicationConfiguration.new('test/environments.yml')
    config.use_environment!("development")
    assert_equal 2, config.size
    assert_equal "google.com", config.server
    assert_equal 6, config.computed
    assert_equal 3, config.section.size
    assert_equal "yahoo.com", config.section.servers[0].name
    assert_equal "amazon.com", config.section.servers[1].name
    assert_equal "webmaster@domain.com", config.emails.webmaster
    assert_equal "feedback@domain.com", config.emails.feedback
    assert_raise(NoMethodError){ config.emails.support }
  end
  
  def test_use_environment_override_with
    config = ApplicationConfiguration.new('test/environments.yml')
    config.use_environment!("development", :override_with => "test/override_with.yml")
    assert_equal 10, config.size
    assert_equal "over.com", config.section.servers[0].name
    assert_equal "ride.com", config.section.servers[1].name
    assert_equal "google.com", config.server
    assert_equal 6, config.computed
    assert_equal "webmaster@domain.com", config.emails.webmaster
    assert_equal "feedback@domain.com", config.emails.feedback
    assert_raise(NoMethodError){ config.emails.support }
  end
  
  def test_use_environment_override_with_no_file
    config = ApplicationConfiguration.new('test/environments.yml')
    config.use_environment!("development", :override_with => "test/non_existant.yml")
    assert_equal 2, config.size
    assert_equal "google.com", config.server
    assert_equal 6, config.computed
    assert_equal 3, config.section.size
    assert_equal "yahoo.com", config.section.servers[0].name
    assert_equal "amazon.com", config.section.servers[1].name
    assert_equal "webmaster@domain.com", config.emails.webmaster
    assert_equal "feedback@domain.com", config.emails.feedback
    assert_raise(NoMethodError){ config.emails.support }
  end
  
end
