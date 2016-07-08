require './lib/Node.rb'
require 'pry'

class CompleteMe
  attr_accessor :root
  attr_reader :word_count

  def initialize
    @root = Node.new
    @word_count = 0
  end

  def insert(word)
    current_node = @root
    word.chars.each do |letter|
      current_node.add(letter)
      current_node = current_node.get_child(letter)
    end
    set_word(current_node)
  end

  def set_word(node)
    @word_count += 1 unless node.is_a_word
    node.is_a_word = true
  end

  def remove_word(node)
    node.is_a_word = false
    @word_count -= 1
    #prune_tree(node)
  end

  def prune_tree(node)
    child_words = recursive_count(node)
    if child_words == 0
      node.children = {}
    end
  end

  def count
    @word_count
    #total = recursive_count(@root)
  end

  # def recursive_count(node)
  #   total_words = 0
  #   total_words += 1 if node.is_a_word
  #   node.children.keys.each do |child_node|
  #     total_words += recursive_count(child_node)
  #   end
  #   total_words
  # end

  def suggest(substring)
    parent = go_to_substring(substring)
    word_list = collect_words(parent, substring)
    sorted_list = word_list.sort_by do |weight_and_content|
      [-weight_and_content[0], weight_and_content[1]]
    end
    return sorted_list.map { |item| item[1] }
  end

  def collect_words(node, original_substring)
    word_list = []
    if node.is_a_word
      word_list += [[node.frequency_list[original_substring], node.substring]]
    end
    node.list_children.each do |child|
      next_node = node.get_child(child)
      word_list += collect_words(next_node, original_substring)
    end
    word_list
  end

  def is_word?(word)
    working_node = go_to_substring(word)
    working_node.is_a_word
  end

  def go_to_substring(substring)
    working_node = @root
    substring.chars.each do |letter|
      if working_node.list_children.include?(letter)
        working_node = working_node.get_child(letter)
      else
        return false
      end
    end
    return working_node
  end

  def populate(word_list)
    word_list.split("\n").each do |word|
      insert(word)
    end
  end

  def select(substring, word)
    node = go_to_substring(word)
    node.frequency_list[substring] += 1
  end
end
