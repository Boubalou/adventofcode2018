defmodule SolutionPartOne do
  def solve(input), do: input
end

defmodule SolutionPartTwo do
  def solve(input), do: input
end

ExUnit.start()

defmodule SolutionTest do
  use ExUnit.Case

  alias SolutionPartOne, as: PartOne
  alias SolutionPartTwo, as: PartTwo

  test "Part I" do
    assert PartOne.solve('test') == 'test'
  end

  test "Part II" do
    assert PartTwo.solve('test') == 'test'
  end
end

input = 'Foobar'

IO.puts("Part I")
input
|> SolutionPartOne.solve()
|> IO.puts()

IO.puts("\nPart II")
input
|> SolutionPartTwo.solve()
|> IO.puts()
