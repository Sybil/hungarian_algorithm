require 'minitest/autorun'
require 'hungarian_algorithm'

class HungarianAlgorithmTest < Minitest::Test
  def test_process_find_pairings_in_a_matrix
    initial_matrix = [
      [82, 83, 69, 92],
      [77, 37, 49, 92],
      [11, 69, 5, 86],
      [8, 9, 98, 23]
    ]

    assert_equal HungarianAlgorithm.new(initial_matrix).process.sort,
      [[0, 2], [1, 1], [2, 0], [3, 3]].sort
  end

  def test_process_works_when_having_pairings_with_undecidable_best_choice
    initial_matrix = [
      [0, 0, 1, 1, 1],
      [0, 1, 1, 1, 1],
      [1, 0, 1, 1, 1],
      [1, 1, 1, 0, 0],
      [1, 1, 1, 0, 0],
    ]

    assert_equal HungarianAlgorithm.new(initial_matrix).process.sort,
      [[0, 2], [1, 0], [2, 1], [3, 3], [4, 4]].sort
  end

  def test_process_works_with_complex_matrix
    initial_matrix = [
      [31, 89, 21, 26, 97, 16, 68, 53, 47, 75],
      [1, 91, 14, 59, 46, 68, 98, 14, 30, 59],
      [40, 98, 41, 57, 9, 53, 11, 51, 65, 25],
      [55, 39, 70, 23, 10, 73, 67, 98, 22, 46],
      [45, 5, 20, 86, 99, 97, 76, 29, 90, 94],
      [90, 7, 26, 12, 58, 44, 2, 8, 33, 53],
      [26, 44, 79, 97, 99, 69, 4, 36, 81, 41],
      [98, 31, 13, 70, 57, 50, 75, 79, 13, 33],
      [18, 98, 17, 45, 38, 99, 69, 7, 19, 26],
      [28, 69, 67, 76, 46, 98, 22, 47, 11, 29]
    ]

    assert_equal HungarianAlgorithm.new(initial_matrix).process.sort,
      [[0, 5], [1, 0], [2, 9], [3, 4], [4, 1], [5, 3], [6, 6], [7, 2], [8, 7], [9, 8]].sort
  end

  def test_process_works_for_basic_matrix
    initial_matrix = [
      [1, 2, 3],
      [2, 4, 6],
      [3, 6, 9],
    ]

    assert_equal HungarianAlgorithm.new(initial_matrix).process.sort,
      [[0, 2], [1, 1], [2, 0]].sort
  end
end

