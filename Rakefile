# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "bio-old-biofetch-emulator"
  gem.homepage = "http://github.com/ngoto/bioruby-old-biofetch-emulator"
  gem.license = "MIT"
  gem.summary = %Q{Emulates as if old BioRuby BioFetch alives}
  gem.description = %Q{Emulator that emulates Bio::Fetch object in BioRuby as if old BioRuby BioFetch server were still alive. It overrides methods and objects in Bio::Fetch, and if the old BioRuby BioFetch server's URL is given, it intercepts all requests and converts them into existing web services such as TogoWS, KEGG REST API, NCBI E-Utilities, and GenomeNet(genome.jp).}
  gem.email = "ng@bioruby.org"
  gem.authors = ["Naohisa Goto"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['test'].execute
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "bio-old-biofetch-emulator #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
