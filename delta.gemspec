Gem::Specification.new do |s|
  s.name        = "delta"
  s.version     = "1.0.0"
  s.summary     = "Delta"
  s.description = "Calculates the delta between two collections of objects."
  s.author      = "Chris Patuzzo"
  s.email       = "chris@patuzzo.co.uk"
  s.homepage    = "https://github.com/tuzz/delta"
  s.files       = ["README.md"] + Dir["lib/**/*.*"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "pry"
  s.add_development_dependency "activerecord", "~> 4.2.1"
  s.add_development_dependency "sqlite3"
end
