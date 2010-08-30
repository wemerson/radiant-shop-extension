#
# Nested tag helper is used to test tags that can be declared inside other tags.
#
# @example
#   tag = NestedTagHelper.new
#   tag.push '<div>', '</div>'
#   tag.push '<h1>', '</h1>'
#   tag.push 'Title'
#   tag.to_s => '<div><h1>Title</h1></div>'
#
class NestedTagHelper

  def initialize
    @tag_stack = []
  end

  def push(opening, closing = nil)
    @tag_stack.push Tag.new(opening, closing)
  end

  def to_s
    closing_tags = []
    @tag_stack.collect do |tag|
      closing_tags.unshift tag.closing
      tag.opening
    end.join('') + closing_tags.join('')
  end

private #######################################################################

  Tag = Struct.new(:opening, :closing)

end
