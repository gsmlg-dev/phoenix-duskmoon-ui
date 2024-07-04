defmodule PhoenixDuskmoon.Card do
  @moduledoc """
  Render card.
  """
  use PhoenixDuskmoon, :html

  import PhoenixDuskmoon.Icons

  # alias Phoenix.LiveView.JS

  @doc """
  Generates card

  ## Example

      <.dm_card>
        <:title>
        Star Wars
        </:title>
        Star Wars is an American epic space opera multimedia
        franchise created by George Lucas,
        which began with the eponymous 1977 film and
        quickly became a worldwide pop-culture phenomenon.
      </.dm_card>

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

  def dm_card(assigns) do
    assigns =
      assigns
      |> assign_new(:title, fn -> nil end)

    ~H"""
    <div
      id={@id}
      class={[
        "m-4 p-6 flex flex-col",
        "shadow-lg dark:shadow-slate-600",
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

  @doc """
  Renders a card with async value.

  ## Examples

      <.dm_async_card :let={data} assign={@data}>
      </.dm_async_card>

  """
  attr(:id, :any, default: nil)
  attr(:class, :any, default: "")
  attr(:assign, :any, default: nil)
  slot(:inner_block, required: true)

  def dm_async_card(assigns) do
    ~H"""
    <.async_result assign={@assign}>
      <:loading>
        <.dm_card>
          <div class="skeleton w-full min-h-32"></div>
        </.dm_card>
      </:loading>
      <:failed :let={reason}>
        <div role="alert" class="alert alert-error shrink-0">
          <.dm_bsi name="exclamation-circle" class="w-5 h-5" />
          <div class="flex flex-col">
            <span class=""><%= reason |> inspect() %></span>
          </div>
        </div>
      </:failed>
      <%= render_slot(@inner_block, Map.get(@assign, :result)) %>
    </.async_result>
    """
  end
end
