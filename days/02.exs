defmodule SolutionPartOne do
  def solve(input) do
    value =
      input
      |> Enum.reduce(%{double: 0, triple: 0}, fn value, %{double: acc_double, triple: acc_triple} ->
        {double, triple} = count_double_and_triple_letters(value)

        %{double: acc_double + double, triple: acc_triple + triple}
      end)

    value.double * value.triple
  end

  defp count_double_and_triple_letters(value) do
    value
    |> String.graphemes()
    |> Enum.reduce(%{}, fn char, acc ->
      Map.update(acc, char, 1, &(&1 + 1))
    end)
    |> Map.to_list()
    |> Enum.reduce({0, 0}, fn value, acc ->
      case value do
        {_, 2} -> put_elem(acc, 0, 1)
        {_, 3} -> put_elem(acc, 1, 1)
        _ -> acc
      end
    end)
  end
end

defmodule SolutionPartTwo do
  def solve(input) do
    input_letters = Enum.map(input, &String.graphemes/1)
    letters_count = Enum.count(List.first(input_letters))

    input_letters
    |> Enum.reduce_while(nil, fn left_letters, _ ->
      Enum.reduce_while(input_letters, nil, fn right_letters, _ ->
        left_letters
        |> Enum.with_index()
        |> Enum.reject(fn {value, index} ->
          value != Enum.fetch!(right_letters, index)
        end)
        |> build_box_id(letters_count)
      end)
      |> case do
        nil -> {:cont, nil}
        value -> {:halt, value}
      end
    end)
  end

  defp build_box_id(letters, letters_count) when length(letters) == letters_count - 1 do
    {:halt, Enum.map(letters, fn value -> elem(value, 0) end) |> Enum.join()}
  end

  defp build_box_id(_, _), do: {:cont, nil}
end

ExUnit.start()

defmodule SolutionTest do
  use ExUnit.Case

  alias SolutionPartOne, as: PartOne
  alias SolutionPartTwo, as: PartTwo

  test "Part I" do
    assert PartOne.solve(["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"]) == 12
  end

  test "Part II" do
    assert PartTwo.solve(["abcde", "fghij", "klmno", "pqrst", "fguij", "axcye", "wvxyz"]) == "fgij"
  end
end

input =
  "days/02.input.txt"
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
