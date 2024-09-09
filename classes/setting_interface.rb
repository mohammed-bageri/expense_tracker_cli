require 'singleton'

class SettingInterface
  include Singleton
  include Savable

  SETTING_PATH = '../setting.json'

  attr_accessor :setting

  def initialize
    self.setting = load_data(SETTING_PATH) || {}
  end

  def set_budget(budget)
    self.setting = {
      budget:
    }

    save_to_setting

    puts 'Setting saved successfully'
  end

  def save_to_setting
    save_data(SETTING_PATH, setting)
  end
end
