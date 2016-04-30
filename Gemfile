source :gemcutter
gem "rails", "~> 2.3.11"
gem "sqlite3"

gem 'fastercsv'
gem 'adhearsion', '1.0.1', :git => 'https://github.com/adhearsion/adhearsion.git', :tag => '1.0.1'
# Newer versions of i18n break on Ruby 1.8 (Adhearsion requires i18n)
gem "i18n", "0.1.3", :git => "https://github.com/mattetti/i18n.git", :ref => "38d85ea3b8eec032c1b0898a30f8010917416d9d"
gem 'mysql', :require => false  # adhearsion uses it

# bundler requires these gems in all environments
# gem "nokogiri", "1.4.2"
# gem "geokit"

group :development do
  # bundler requires these gems in development
  # gem "rails-footnotes"
end

group :test do
  # bundler requires these gems while running tests
  # gem "rspec"
  # gem "faker"
end

