# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "mina-laravel"
  s.version     = '0.1'
  s.authors     = ["Kikyous"]
  s.email       = ["kikyous@163.com"]
  s.homepage    = "http://github.com/kikyous/mina-laravel"
  s.summary     = "Tools to deploy Laravel apps with mina."
  s.description = "Tools to deploy Laravel apps with mina."

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "mina"
end
