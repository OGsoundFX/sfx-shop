source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'
gem 'dotenv-rails', groups: [:development, :test]

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# /note/👇 removed for rails 7 upgrade
# gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
# ! 👇upgrading to rails 7
gem 'rails', '~> 7.1.2' # or the latest 7.1.x

# Use postgresql as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
# /note/👇 removed for rails 7 upgrade
# gem 'sass-rails', '>= 6'
# ! 👇upgrading to rails 7
gem 'sassc-rails'

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'psych', '< 4'
# /note/👇 removed for rails 7 upgrade
# gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# /note/👇 removed for rails 7 upgrade
# gem 'turbolinks', '~> 5'
# ! 👇upgrading to rails 7
gem 'turbo-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]


# gems added by myself:
gem 'simple_form'
gem 'devise'
gem 'money-rails', '~>1.12'
gem 'stripe'
# gem 'stripe_event'
gem 'bootstrap', '~> 4.5.2'
gem 'font-awesome-rails'
gem "font-awesome-sass", "~> 5.7"
gem 'cloudinary', '~> 1.16.0'
gem 'ngrok', '~> 1.6', '>= 1.6.1'
gem 'gibbon'
gem 'pg_search', '~> 2.3.0'
gem 'kaminari'

gem 'aws-sdk-s3', '~> 1.103'
gem 'aws-sdk-ec2', '~> 1.0.0.rc3'
gem 'rubyzip', '~> 1.2'

gem 'net-smtp', require: false
gem 'net-imap', require: false
gem 'net-pop', require: false
gem 'pry', '~> 0.14.1'

gem 'rails_admin', '~> 3.1', '>= 3.1.2'

gem 'sitemap_generator'

# ! 👇upgrading to rails 7
gem 'jsbundling-rails'   # for JS (esbuild/webpack/rollup)
gem 'cssbundling-rails'  # for CSS (tailwind/sass/postcss)
gem 'stimulus-rails'     # if using Stimulus
