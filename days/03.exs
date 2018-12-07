defmodule Claim do
  @claim_regex ~r/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/

  def parse(value) do
    [id, x, y, w, h] = Regex.run(@claim_regex, value, capture: :all_but_first)

    %{
      id: id,
      x: String.to_integer(x),
      y: String.to_integer(y),
      w: String.to_integer(w),
      h: String.to_integer(h)
    }
  end

  def cumulate(%{x: x, y: y, w: w, h: h}, acc) do
    Enum.reduce(x..(x + w - 1), acc, fn (x, acc) ->
      Enum.reduce(y..(y + h - 1), acc, fn (y, acc) ->
        key = build_key(x, y)

        Map.update(acc, key, 0, &(&1 + 1))
      end)
    end)
  end

  defp build_key(x, y) do
    "#{x}_#{y}"
  end
end

defmodule SolutionPartOne do
  def solve(input) do
    input
    |> Enum.map(&Claim.parse/1)
    |> Enum.reduce(%{}, &Claim.cumulate/2)
    |> Enum.filter(fn value -> elem(value, 1) > 0 end)
    |> length()
  end
end

defmodule SolutionPartTwo do
  def solve(input) do
    claimed_surfaces =
      input
      |> Enum.map(&Claim.parse/1)
      |> Enum.reduce(%{}, &Claim.cumulate/2)

    input
    |> Enum.reduce_while(nil, &find_good_claim(claimed_surfaces, &1, &2))
  end

  defp find_good_claim(surfaces, claim, _) do
    claim
    |> Claim.parse()
    |> Claim.cumulate(%{})
    |> Enum.reduce_while(%{match_another_claim: false}, fn value, acc ->
      if Map.get(surfaces, elem(value, 0)) > 0 do
        {:halt, %{match_another_claim: true}}
      else
        {:cont, acc}
      end
    end)
    |> case do
      %{match_another_claim: true} -> {:cont, nil}
      _ -> {:halt, Claim.parse(claim).id}
    end
  end
end

ExUnit.start()

defmodule SolutionTest do
  use ExUnit.Case

  alias SolutionPartOne, as: PartOne
  alias SolutionPartTwo, as: PartTwo

  test "Part I" do
    assert PartOne.solve(["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"]) == 4
  end

  test "Part II" do
    assert PartTwo.solve(["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"]) == "3"
  end
end

input =
  "days/03.input.txt"
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
