defmodule SolutionPartOne do
  def solve(input) do
    input
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end
end

defmodule SolutionPartTwo do
  def solve(input) do
    input
    |> Enum.map(&String.to_integer/1)
    |> loop_reduce_while({0, [], false})
    |> elem(1)
    |> List.first()
  end

  defp loop_reduce_while(input, acc) do
    input
    |> Enum.reduce_while(acc, &cumulate_frequencies/2)
    |> case do
       {frequency, frequencies, found} when found == false -> loop_reduce_while(input, {frequency, frequencies, found})
       result -> result
     end
  end

  defp cumulate_frequencies(value, {current_frequency, frequencies, found}) do
    new_frequency = current_frequency + value

    case Enum.find(frequencies, nil, fn frequency -> frequency == new_frequency end) do
      nil -> {:cont, {new_frequency, [new_frequency | frequencies], found}}
      _ -> {:halt, {current_frequency, [new_frequency | frequencies], true}}
    end
  end
end

ExUnit.start()

defmodule SolutionTest do
  use ExUnit.Case

  alias SolutionPartOne, as: PartOne
  alias SolutionPartTwo, as: PartTwo

  test "Part I" do
    input = ["1", "2", "3", "-1"]
    result = 5

    assert PartOne.solve(input) == result
  end

  test "Part II" do
    input = ["1", "2", "-3", "-1", "4"]
    result = 3

    assert PartTwo.solve(input) == result
  end

  test "Part II loop" do
    input = ["1", "2", "-3", "-1"]
    result = 0

    assert PartTwo.solve(input) == result
  end
end

input =
  "days/01.input.txt"
  |> File.stream!()
  |> Stream.map(&String.trim_trailing/1)
  |> Enum.to_list()

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
