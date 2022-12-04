defmodule Phoenix.WebComponent.Card do
  @moduledoc """
  Render card.
  """
  use Phoenix.WebComponent, :html

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

  attr(:class, :string,
    default: "",
    doc: """
    html attribute class
    """
  )

  attr(:fit, :boolean,
    default: false,
    doc: """
    set width and height to fit-content
    """
  )

  slot(:title,
    required: false,
    doc: """
    Render a card title.
    """
  )

  def wc_card(assigns) do
    assigns =
      assigns
      |> assign_new(:title, fn -> nil end)

    ~H"""
    <div id={@id} class={[
        if(@fit, do: "w-fit h-fit", else: "w-auto h-auto"),
        "m-4 p-6 flex flex-col",
        "bg-white shadow",
        @class
      ]}
    >
      <%= unless is_nil(@title) do %>
      <div class="w-full text-xl flex flex-row justify-start items-center h-10 mb-4">
        <%= render_slot(@title) %>
      </div>
      <% end %>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
