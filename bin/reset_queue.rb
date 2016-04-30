#!/usr/bin/env ruby
# A backward compatibility wrapper for this as a Rake task
puts "Warning: bin/reset_queue is deprecated; use rake queue:reset instead"
load File.dirname(__FILE__)+'/../Rakefile'
Rake::Task['queue:reset'].invoke
