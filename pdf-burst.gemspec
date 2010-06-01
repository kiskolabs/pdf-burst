require File.expand_path("../lib/pdf/burst/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "pdf-burst"
  s.version     = PDF::Burst::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Joao Carlos"]
  s.email       = ["mail@joao-carlos.com"]
  s.homepage    = "http://github.com/kiskolabs/pdf-burst"
  s.summary     = "Bursts a PDF into single page files"
  s.description = "Creates a PDF for each page from a PDF with multiple pages. Uses Ghostscript for the actual bursting. You'll need the following commands available on your system: gs (Ghostscript), pdfinfo (Poppler) and grep."

  s.required_rubygems_version = ">= 1.3.7"

  s.rubyforge_project         = "pdf-burst"

  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.rdoc"]
  s.require_path = "lib"

  s.executables = ["pdf-burst"]
end
