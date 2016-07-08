require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'

require './lib/node.rb'

class NodeTest < Minitest::Test

  def test_Nodes_exist
    assert Node.new
  end

  def test_nodes_have_children
    node = Node.new
    assert node.children
  end

  def test_nodes_have_values
    node = Node.new
    assert_equal "", node.substring
  end

  def test_child_nodes_can_be_added
    node = Node.new
    node.add("a")
    node.add("b")
    assert_equal ["a","b"], node.list_children.sort
  end

  def test_child_nodes_are_nodes
    node = Node.new
    node.add("a")
    child = node.get_child("a")
    assert_equal Node, child.class
    assert_equal node.list_children, [child.substring]
  end

end
