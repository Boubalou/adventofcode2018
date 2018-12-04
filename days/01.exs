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
    |> loop_reduce_while({0, [0], false})
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

    if Enum.member?(frequencies, new_frequency) do
      {:halt, {current_frequency, [new_frequency | frequencies], true}}
    else
      {:cont, {new_frequency, [new_frequency | frequencies], found}}
    end
  end
end

ExUnit.start()

defmodule SolutionTest do
  use ExUnit.Case

  alias SolutionPartOne, as: PartOne
  alias SolutionPartTwo, as: PartTwo

  test "Part I" do
    assert PartOne.solve(["+1", "+1", "+1"]) == 3
    assert PartOne.solve(["+1", "+1", "-2"]) == 0
    assert PartOne.solve(["-1", "-2", "-3"]) == -6
  end

  test "Part II" do
    assert PartTwo.solve(["+1", "-1"]) == 0
    assert PartTwo.solve(["+3", "+3", "+4", "-2", "-4"]) == 10
    assert PartTwo.solve(["-6", "+3", "+8", "+5", "-6"]) == 5
    assert PartTwo.solve(["+7", "+7", "-2", "-7", "-4"]) == 14
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
