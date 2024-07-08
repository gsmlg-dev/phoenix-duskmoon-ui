defmodule PhoenixDuskmoon.Component.Card do
  @moduledoc """
  Render card.
  """
  use PhoenixDuskmoon.Component, :html

  import PhoenixDuskmoon.Component.Icons

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
        "card",
        @class
      ]}
    >
      <div class="card-body">
        <div
          :for={title <- @title}
          class={[
            "card-title",
            Map.get(title, :class, ""),
          ]}
        >
          <%= render_slot(title) %>
        </div>
        <%= render_slot(@inner_block) %>
      </div>
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
