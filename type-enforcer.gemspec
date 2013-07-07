$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
version = File.read(File.expand_path('../VERSION', __FILE__)).strip

Gem::Specification.new do |gem|
  gem.name                  = 'type-enforcer'
  gem.version               = version
  gem.date                  = '2013-07-06'
  gem.summary               = 'nil-b-gone'
  gem.description           = 'A way to ensure things are the types you want them to be'
  gem.authors               = ['Kyle Lacy']
  gem.email                 = 'kylelacy@me.com'
  gem.files                 = ['lib/type-enforcer.rb', 'lib/type-enforcer/base.rb', 'lib/type-enforcer/matchers.rb']
  gem.required_ruby_version = ">= 2.0.0"
  gem.homepage              = 'https://github.com/kylewlacy/type-enforcer'
end
