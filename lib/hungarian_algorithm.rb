# frozen_string_literal: true

require "hungarian_algorithm/version"
require 'matrix'

class HungarianAlgorithm
  # https://users.cs.duke.edu/~brd/Teaching/Bio/asmb/current/Handouts/munkres.html

  def initialize(nested_array)
    @matrix = Matrix[*nested_array]
    @mask_matrix = Matrix.zero(matrix_size)
    @covered_rows = Array.new(matrix_size, 0)
    @covered_columns = Array.new(matrix_size, 0)

    validate
  end

  def process
    p 'Hungarian algo start'
    minimize_rows
    star_zeros
    p 'Hungarian algo end'
    stars
  end

  private

  attr_accessor :matrix

  def validate
    raise NotImplementedError unless matrix.square?
  end

  def on_each_cell
    @matrix.each_with_index { |cell, i, j| yield(cell, i, j) }
  end

  def on_each_mask_cell
    @mask_matrix.each_with_index { |cell, i, j| yield(cell, i, j) }
  end

  def reset_covered_columns
    @covered_columns = Array.new(matrix_size, 0)
  end

  def reset_covered_rows
    @covered_rows = Array.new(matrix_size, 0)
  end

  def reset_all_primes
    on_each_mask_cell do |cell, i, j|
      @mask_matrix[i, j] = 0 if cell == 2
    end
  end

  def matrix_size
    @matrix_size ||= matrix.row_vectors.size
  end

  # Step 1 : Minimize rows/columns
  def minimize_rows
    p 'Step 1: Minimizing rows'
    @matrix.row_vectors.each_with_index do |row, i|
      min = row.min
      next if min.zero?

      row.each_with_index { |cell, j| matrix[i, j] = cell - min }
    end
  end

  # Step 2 : Star all zero which are not on a row/coulmn with another already starred zero
  def star_zeros
    p 'Step 2: star uncovered zeros'

    on_each_cell do |cell, i, j|
      next if [@covered_rows[i], @covered_columns[j], cell].any?(&:nonzero?)
      star_cell(i, j)
    end

    reset_covered_columns
    reset_covered_rows
    cover_stars
  end

  def star_cell(i, j)
    @mask_matrix[i, j] = 1
    @covered_rows[i] = 1
    @covered_columns[j] = 1
  end

  def cover_stars
    p 'Step 3: cover columns with stars'

    on_each_mask_cell do |cell, i, j|
      next unless cell == 1

      @covered_columns[j] = 1
    end
    return if assignment_done?

    prime_zeros
  end

  def assignment_done?
    solved_assigments = @covered_columns.select { |v| v == 1 }.size
    solved_assigments == matrix_size
  end

  def prime_zeros
    @uncovered_min ||= matrix.max

    loop do
      uncovered_zeros = false
      p 'Step 4: prime zeros located on rows with starred zeros'

      on_each_cell do |cell, i ,j|
        next if @covered_rows[i].nonzero? || @covered_columns[j].nonzero?

        if cell.nonzero?
          @uncovered_min = cell if cell < @uncovered_min
          next
        end

        uncovered_zeros = true

        @mask_matrix[i, j] = 2
        if star = star_in_row(i)
          @covered_rows[i] = 1
          @covered_columns[star[1]] = 0
        else
          search_for_optimal_path_from(i, j)
          return if assignment_done?
        end
      end

      break unless uncovered_zeros
    end

    minimize_uncovered_values
  end

  def star_in_row(i)
    j = @mask_matrix.row(i).find_index(1)
    [i, j] unless j.nil?
  end

  def search_for_optimal_path_from(i, j)
    p 'Step 5: looks for optimal path accross stars and primes'
    primes_in_path = [[i, j]]
    stars_in_path = []

    loop do
      if star_after_prime = star_in_column(j)
        stars_in_path << star_after_prime
        prime_after_star = prime_in_row(star_after_prime[0])
        primes_in_path << prime_after_star
        i, j = prime_after_star
      else
        stars_in_path.each { |i, j| @mask_matrix[i, j] = 0 }
        primes_in_path.each { |i, j| @mask_matrix[i, j] = 1 }
        reset_covered_columns
        reset_covered_rows
        reset_all_primes

        break cover_stars
      end
    end
  end

  def star_in_column(j)
    i = @mask_matrix.column(j).find_index(1)
    [i, j] unless i.nil?
  end

  def prime_in_row(i)
    j = @mask_matrix.row(i).find_index(2)
    [i, j] unless j.nil?
  end

  def minimize_uncovered_values
    p 'Step 6: Minimize uncovered cells'

    on_each_cell do |cell, i, j|
      @matrix[i, j] += @uncovered_min if @covered_rows[i] == 1
      @matrix[i, j] -= @uncovered_min if @covered_columns[j] == 0
    end

    prime_zeros
  end

  def stars
    stars = []
    on_each_mask_cell do |cell, i, j|
      next if cell != 1
      stars << [i, j]
    end
    stars
  end
end

