$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "concerto_cas_auth/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "concerto_cas_auth"
  s.version     = ConcertoCasAuth::VERSION
  s.authors     = ["Gabe Perez"]
  s.email       = ["perez283@gmail.com"]
  s.homepage    = "http://www.concerto-signage.org"
  s.summary     = "Provides user authentication using CAS"
  s.description = "Authorize Concerto users with CAS"
  s.license     = "Apache-2.0"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.9"
  s.add_dependency "omniauth-cas"
  s.add_dependency "concerto_identity"

end
