defmodule PhoenixDuskmoon.Component.Card do
  @moduledoc """
  Duskmoon UI Card Component
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

  attr(:body_class, :any,
    default: "",
    doc: """
    card body attribute class
    """
  )

  slot(:title,
    required: false,
    doc: """
    Render a card title.
    """
  ) do
    attr(:id, :any, doc: "title id")
    attr(:class, :any, doc: "title class")
  end

  slot(:action,
    required: false,
    doc: """
    Render a card action.
    """
  ) do
    attr(:id, :any, doc: "action id")
    attr(:class, :any, doc: "action class")
  end

  def dm_card(assigns) do
    ~H"""
    <div
      id={@id}
      class={[
        "card",
        @class
      ]}
    >
      <div class={["card-body", @body_class]}>
        <div
          :for={title <- @title}
          id={Map.get(title, :id)}
          class={[
            "card-title",
            Map.get(title, :class, ""),
          ]}
        >
          <%= render_slot(title) %>
        </div>
        <%= render_slot(@inner_block) %>
        <div
          :for={action <- @action}
          id={Map.get(action, :id)}
          class={[
            "card-actions",
            Map.get(action, :class, ""),
          ]}
        >
          <%= render_slot(action) %>
        </div>
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
  attr(:body_class, :any, default: "")
  attr(:skeleton_class, :any, default: "")
  attr(:assign, :any, default: nil)
  slot(:inner_block, required: true)

  slot(:title,
    required: false,
    doc: """
    Render a card title.
    """
  ) do
    attr(:id, :any, doc: "title id")
    attr(:class, :any, doc: "title class")
  end

  slot(:action,
    required: false,
    doc: """
    Render a card action.
    """
  ) do
    attr(:id, :any, doc: "action id")
    attr(:class, :any, doc: "action class")
  end

  def dm_async_card(assigns) do
    ~H"""
    <.async_result assign={@assign}>
      <:loading>
        <div id={@id} class={["card", @class]}>
          <div class={["card-body", @body_class]}>
            <div
              :for={title <- @title}
              id={Map.get(title, :id)}
              class={[
                "card-title",
                Map.get(title, :class, ""),
              ]}
            >
              <%= render_slot(title) %>
            </div>
            <div class={["skeleton w-full h-full", @skeleton_class]}></div>
          </div>
        </div>
      </:loading>
      <:failed :let={reason}>
        <div id={@id} class={["card", @class]}>
          <div class={["card-body", @body_class]}>
            <div
              :for={title <- @title}
              id={Map.get(title, :id)}
              class={[
                "card-title",
                Map.get(title, :class, ""),
              ]}
            >
              <%= render_slot(title) %>
            </div>
            <div role="alert" class="alert alert-error shrink-0">
              <.dm_bsi name="exclamation-circle" class="w-5 h-5" />
              <div class="flex flex-col">
                <span class=""><%= reason |> inspect() %></span>
              </div>
            </div>
          </div>
        </div>
      </:failed>
      <div
        id={@id}
        class={[
          "card",
          @class
        ]}
      >
        <div class={["card-body", @body_class]}>
          <div
            :for={title <- @title}
            id={Map.get(title, :id)}
            class={[
              "card-title",
              Map.get(title, :class, ""),
            ]}
          >
            <%= render_slot(title) %>
          </div>
          <%= render_slot(@inner_block, Map.get(@assign, :result)) %>
          <div
            :for={action <- @action}
            id={Map.get(action, :id)}
            class={[
              "card-actions",
              Map.get(action, :class, ""),
            ]}
          >
            <%= render_slot(action, Map.get(@assign, :result)) %>
          </div>
        </div>
      </div>
    </.async_result>
    """
  end
end
