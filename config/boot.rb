# frozen_string_literal: true

# Load db config and establish connection
db_config = YAML.safe_load(File.read('config/database.yml'), [], [], true)
db_config = db_config.with_indifferent_access[ENV['CURRENT_ENV']]
ActiveRecord::Base.establish_connection(**db_config)

# Setup logger for activerecord
ActiveRecord::Base.logger = Application.logger

Dir[File.expand_path('lib/*.rb')].sort.each do |file|
  require file
end

Dir[File.expand_path('config/initializers/*.rb')].sort.each do |file|
  require file
end

Dir[File.expand_path('app/**/*.rb')].sort.each do |file|
  require file
end
