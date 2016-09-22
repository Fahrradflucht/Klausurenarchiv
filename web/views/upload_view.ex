defmodule Klausurenarchiv.UploadView do
  use Klausurenarchiv.Web, :view

  def year_list do
    2005..DateTime.utc_now.year
    |> Enum.to_list()
    |> Enum.flat_map(fn(y) ->
      [to_short_string(y), "#{to_short_string(y)}/#{to_short_string(y+1)}"]
    end)
  end

  defp to_short_string(year) do
    year
    |> to_string()
    |> String.slice(-2..-1)
  end
end
