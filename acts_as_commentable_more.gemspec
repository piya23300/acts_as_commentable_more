$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_as_commentable_more/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_as_commentable_more"
  s.version     = ActsAsCommentableMore::VERSION
  s.authors     = ["piya23300"]
  s.email       = ["piya23300@gmail.com"]
  s.homepage    = "https://github.com/piya23300/acts_as_commentable_more"
  s.summary     = "gem that provides comment functionality."
  s.description = "gem that provides comment functionality."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.autorequire = %q{acts_as_commentable_more}

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'


  s.add_dependency "rails", "~> 4.1.8"

  s.add_development_dependency "pg"
  # s.add_development_dependency "acts_as_commentable"

end
