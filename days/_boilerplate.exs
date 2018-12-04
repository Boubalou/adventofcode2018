defmodule SolutionPartOne do
  def solve(input) do
    input
  end
end

defmodule SolutionPartTwo do
  def solve(input) do
    input
  end
end

ExUnit.start()

defmodule SolutionTest do
  use ExUnit.Case

  alias SolutionPartOne, as: PartOne
  alias SolutionPartTwo, as: PartTwo

  test "Part I" do
    input = 'test'
    result = 'test'

    assert PartOne.solve(input) == result
  end

  test "Part II" do
    input = 'test'
    result = 'test'

    assert PartTwo.solve(input) == result
  end
end

input = 'Foobar'

IO.puts("Solving Part I")
IO.puts("--------------")
input
|> SolutionPartOne.solve()
|> IO.puts()

IO.puts("\nSolving Part II")
IO.puts("---------------")
input
|> SolutionPartTwo.solve()
|> IO.puts()
