Gem::Specification.new do |s|
  s.name = "pmgmt"
  s.version = "1.1.0"
  s.date = "2018-12-09"
  s.summary = "Project management scripting library."
  s.description = "A library to make Ruby your preferred scripting language for dev scripts."
  s.authors = ["David Mohs"]
  s.email = "davidmohs@gmail.com"
  s.files = ["lib/pmgmt.rb", "lib/dockerhelper.rb", "lib/optionsparser.rb", "lib/syncfiles.rb"]
  s.homepage = "https://github.com/dmohs/project-management"
  s.license = "MIT"
  s.required_ruby_version = '>= 2'
  s.metadata    = { "source_code_uri" => "https://github.com/dmohs/project-management" }
end
