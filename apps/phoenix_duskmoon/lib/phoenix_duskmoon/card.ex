defmodule PhoenixDuskmoon.Card do
  @moduledoc """
  Render card.
  """
  use PhoenixDuskmoon, :html

  # alias Phoenix.LiveView.JS

  @doc """
  Generates card

  ## Example

      <.wc_card>
        <:title>
        Star Wars
        </:title>
        Star Wars is an American epic space opera multimedia
        franchise created by George Lucas,
        which began with the eponymous 1977 film and
        quickly became a worldwide pop-culture phenomenon.
      </.wc_card>

  """
  @doc type: :component
  attr(:id, :any,
    default: false,
    doc: """
    html attribute id
    """
  )

  attr(:class, :any,
    default: "",
    doc: """
    html attribute class
    """
  )

  slot(:title,
    required: false,
    doc: """
    Render a card title.
    """
  ) do
    attr(:class, :any, doc: "title class")
  end

  def wc_card(assigns) do
    assigns =
      assigns
      |> assign_new(:title, fn -> nil end)

    ~H"""
    <div
      id={@id}
      class={[
        "m-4 p-6 flex flex-col",
        "bg-white shadow-lg dark:bg-black dark:shadow-slate-600",
        @class
      ]}
    >
      <div
        :for={{title, _i} <- Enum.with_index(@title)}
        class={[
          "w-full text-xl",
          "flex flex-row justify-start items-center",
          "h-10 mb-4",
          Map.get(title, :class, ""),
        ]}
      >
        <%= render_slot(title) %>
      </div>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
