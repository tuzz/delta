Gem::Specification.new do |s|
  s.name        = "delta"
  s.version     = "2.1.0"
  s.licenses    = ["MIT"]
  s.summary     = "Delta"
  s.description = "Calculates the delta between two collections of objects."
  s.author      = "Chris Patuzzo"
  s.email       = "chris@patuzzo.co.uk"
  s.homepage    = "https://github.com/tuzz/delta"
  s.files       = ["README.md"] + Dir["lib/**/*.*"]

  s.add_development_dependency "rake", "~> 10.4"
  s.add_development_dependency "rspec", "~> 3.2"
  s.add_development_dependency "rubocop", "~> 0.31"
  s.add_development_dependency "pry", "~> 0.10"
  s.add_development_dependency "activerecord", "~> 4.2"
  s.add_development_dependency "sqlite3", "~> 1.3"
end
