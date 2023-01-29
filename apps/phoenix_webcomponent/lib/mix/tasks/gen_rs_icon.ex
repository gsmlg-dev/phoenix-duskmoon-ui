defmodule Mix.Tasks.PhxWc.GenRsIcons do
  # Generate Material Design Icons and Bootstrap Icons to yew components

  @moduledoc """
  Generate mdi.rs or bsi.rs fron svg files.
  """
  use Mix.Task

  @shortdoc "Generate mdi.rs or bsi.rs file"
  def run(["mdi"]) do
    Mix.Task.run("app.start")

    icons =
      File.ls!(Application.app_dir(:phoenix_webcomponent, "priv/mdi/svg"))
      |> Enum.filter(&String.ends_with?(&1, ".svg"))
      |> Enum.map(&String.trim(&1, ".svg"))

    icon_names = icons |> Enum.map(fn(name) ->
      name |> String.split("-") |> Enum.map(&String.capitalize/1) |> Enum.join("")
    end)

    quoted = EEx.compile_file("#{__DIR__}/yew_mdi.eex")
    {result, _bindings} = Code.eval_quoted(quoted, icons: icons, icon_names: icon_names)

    fl = Path.expand("../../../mdi.rs", __DIR__)

    File.write!(fl, result)
  end

  def run(["bsi"]) do
    Mix.Task.run("app.start")

    icons =
      File.ls!(Application.app_dir(:phoenix_webcomponent, "priv/bsi/svg"))
      |> Enum.filter(&String.ends_with?(&1, ".svg"))
      |> Enum.map(&String.trim(&1, ".svg"))

    icon_names = icons |> Enum.map(fn(name) ->
      name |> String.split("-") |> Enum.map(&String.capitalize/1) |> Enum.join("")
    end)

    quoted = EEx.compile_file("#{__DIR__}/yew_bsi.eex")
    {result, _bindings} = Code.eval_quoted(quoted, icons: icons, icon_names: icon_names)

    fl = Path.expand("../../../bsi.rs", __DIR__)

    File.write!(fl, result)
  end

  def run(_) do
    IO.puts("Use `mix phx_wc.gen_rs_icons bsi` or `mix phx_wc.gen_rs_icons mdi`")
  end
end
