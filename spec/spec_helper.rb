require 'rubygems'
require 'nokogiri'
require 'bacon'
require 'slidedown'

$SILENT = true

require File.dirname(__FILE__) + '/../lib/makers-mark'

module TestHelp
  def explain
    begin
      yield
    rescue => e
      puts e
      raise e
    end
  end

  def result(*args)
    MakersMark.generate(@markdown)
  end

  def with_markdown(markdown)
    @markdown = markdown.gsub(/^\s*\|/, '')
  end
end