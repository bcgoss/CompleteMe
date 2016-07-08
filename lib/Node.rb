class Node
  attr_reader :substring
  attr_accessor :children, :is_a_word, :frequency_list

  def initialize(value = "")
    @children = {}
    @substring = value
    @frequency_list = Hash.new(0)
  end

  def list_children
    @children.keys
  end

  def add (child)
    @children[child] = Node.new(substring+child) unless @children.has_key? child
  end

  def get_child(key)
    @children[key]
  end
end
