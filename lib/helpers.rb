include Nanoc::Helpers::Rendering
include Nanoc::Helpers::Tagging

## copy static assets outside of content instead of having nanoc process them
def copy_static
  targetDir = 'output/content/assets/'
  FileUtils.mkdir_p targetDir
  FileUtils.cp_r 'content/assets/.', targetDir
end

## set pandoc options here (passing them with params hash currently does not work)
class DwPandoc < Nanoc::Filter
  identifier :pandoc_dw

  require 'pandoc-ruby'

  def run(content, params={})
    templateFile = Dir.getwd + '/layouts/pandocTemplate.html'
    PandocRuby.convert(content, {:from => :markdown, :to => :html},
                       :no_wrap, :table_of_contents, :mathjax, :standalone,
                       { "template" => templateFile })
  end
end

## the following tags/category helpers are based on Anouar Adlani's nanoc-toolbox
## https://github.com/aadlani/nanoc-toolbox/blob/master/lib/nanoc/toolbox/helpers/tagging_extra.rb
def count_tags(items=nil)
  items ||= @items
  tags = items.map { |i| i[:tags] }.flatten.delete_if{|t| t.nil?}
  tags.inject(Hash.new(0)) {|h,i| h[i] += 1; h }
end

def count_categories(items=nil)
  items ||= @items
  categories = items.map { |i| i[:categories] }.flatten.delete_if{|t| t.nil?}
  categories.inject(Hash.new(0)) {|h,i| h[i] += 1; h }
end

def has_category?(item, category)
  return false if item[:categories].nil?
  item[:categories].include? category
end

def items_with_category(category, items=nil)
  items = @items if items.nil?
  items.select { |item| has_category?( item, category ) }
end
