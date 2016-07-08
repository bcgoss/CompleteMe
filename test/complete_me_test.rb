require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/complete_me.rb'

class CompletemeTest < Minitest::Test
  def test_CompleteMe_exists
    assert CompleteMe.new
  end

  def test_it_has_a_root
    completion = CompleteMe.new
    assert completion.root
  end

  def test_words_are_inserted
    completion = CompleteMe.new
    assert completion.insert("pizza")
  end

  def test_it_counts_words
    completion = CompleteMe.new
    completion.insert("pizza")
    assert_equal 1, completion.count
  end

  def test_it_finds_words
    completion = CompleteMe.new
    completion.insert("pizza")
    assert completion.is_word?("pizza")
    refute completion.is_word?("piz")
  end

  def test_it_suggests_words_for_empty_string
    completion = CompleteMe.new
    completion.insert("pizza")
    completion.insert("pizzeria")
    assert_equal ["pizza", "pizzeria"], completion.suggest("")
  end

  def test_it_suggests_words
    completion = CompleteMe.new
    completion.insert("pizza")
    completion.insert("pizzeria")
    assert_equal ["pizza", "pizzeria"], completion.suggest("piz")
  end

  def test_it_reads_many_words
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    assert completion.populate(dictionary)
    assert_equal 235886, completion.count
  end

  def test_it_suggests_many_words
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)
    expected = ["pizza", "pizzeria", "pizzicato", "pizzle", "pize"].sort
    assert_equal expected, completion.suggest("piz")
  end

  def test_you_select_a_word_for_a_substring
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)
    assert completion.select("piz", "pizzeria")

  end
  def test_nodes_list_how_often_they_are_used
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)
    completion.select("piz", "pizzeria")
    completion.select("piz", "pizzeria")
    completion.select("piz", "pizzeria")

    completion.select("pi", "pizza")
    completion.select("pi", "pizza")
    completion.select("pi", "pizzicato")

    node = completion.go_to_substring("pizza")
    expected = {"pi" => 2}

    assert_equal expected, node.frequency_list
  end

  def test_selecting_words_changes_order_of_suggestions
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)
    first_run = completion.suggest("piz")
    completion.select("piz","pizzeria")
    second_run = completion.suggest("piz")
    refute first_run == second_run
  end

  def test_each_substring_change_suggestions_differently
    completion = CompleteMe.new

    dictionary = File.read("/usr/share/dict/words")

    completion.populate(dictionary)

    completion.select("piz", "pizzeria")
    completion.select("piz", "pizzeria")
    completion.select("piz", "pizzeria")

    completion.select("pi", "pizza")
    completion.select("pi", "pizza")
    completion.select("pi", "pizzicato")

    suggestions_for_piz = completion.suggest("piz")
    assert_equal "pizzeria", suggestions_for_piz.first
    suggestions_for_pi = completion.suggest("pi")
    assert_equal "pizza", suggestions_for_pi.first
    refute suggestions_for_pi == suggestions_for_piz
  end

  def test_it_can_use_addresses
    dictionary = File.read("./AddressList")
    completion = CompleteMe.new
    completion.populate(dictionary)
    completion.select("421 ", '421 N Dexter St')
    suggestions_for_421 = completion.suggest("421 ")
    assert suggestions_for_421.length > 1
  end
end
