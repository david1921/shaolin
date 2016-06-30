module FactoriesLoader
  @@factories_loaded = false

  def self.load_once
    unless @@factories_loaded
      FactoryGirl.find_definitions
      @@factories_loaded = true
    end
  end
end

FactoriesLoader.load_once