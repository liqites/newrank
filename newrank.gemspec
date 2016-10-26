Gem::Specification.new do |s|
  s.name        = 'newrank'
  s.version     = '0.3.0'
  s.date        = '2016-10-25'
  s.summary     = "Newrank Crawler"
  s.description = "A Crawler for NewRank"
  s.authors     = ["Tesla Lee"]
  s.email       = 'leechee89@gmail.com'
  s.files       = ["lib/newrank.rb"]
  s.homepage    =
    'https://github.com/liqites/newrank_crawler'
  s.license       = 'MIT'
  s.add_runtime_dependency "rkelly-remix", [">= 0.0.1"]
  s.add_runtime_dependency "nokogiri", [">= 1.4"]
  s.add_runtime_dependency "rest-client", [">= 1.0"]
  s.add_runtime_dependency "execjs", [">= 1.0.0"]
end
