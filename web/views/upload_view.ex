defmodule Klausurenarchiv.UploadView do
  use Klausurenarchiv.Web, :view

  def upload_file_url(file) do
    rel_path = Path.relative_to(
      file, Application.get_env(:klausurenarchiv, :store)[:path])

    "/data/#{rel_path}"
  end

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
