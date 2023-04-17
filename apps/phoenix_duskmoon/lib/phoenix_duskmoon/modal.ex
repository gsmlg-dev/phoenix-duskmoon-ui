defmodule PhoenixDuskmoon.Modal do
  use PhoenixDuskmoon, :html

  alias Phoenix.LiveView.JS
  import PhoenixDuskmoon.Icons

  @doc """
  Open ad dialog modal.

  ## Examples

  ```heex
  <.dm_modal>
    <:trigger let={f}>
      <button phx-click={f}>Open</button>
    </:trigger>
    <:title>PhoenixDuskmoon</:title>
    <:body>PhoenixDuskmoon Storybook</:body>
  </.dm_modal>
  ```

  """
  @doc type: :component
  attr(:id, :any, doc: "Modal id")

  attr(:class, :any,
    default: "",
    doc: "Modal class"
  )

  slot(:trigger, doc: "Modal trigger")

  slot(:title, doc: "Modal title") do
    attr(:class, :any, doc: "html class")
  end

  slot(:body, doc: "Modal content", required: true)

  slot(:footer, doc: "Modal footer, buttons") do
    attr(:class, :any, doc: "html class")
  end

  def dm_modal(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "modal-#{Enum.random(0..999_999)}" end)

    ~H"""
    <%= if length(@trigger) > 0 do %>
      <%= render_slot(@trigger, JS.dispatch("modal:open", to: "##{@id}")) %>
    <% end %>
    <dialog
      id={@id}
      class={[
        "modal relative",
        "p-4 min-h-[200px] min-w-[420px]",
        @class
      ]}
    >
      <a class="absolute right-2 top-2 cursor-pointer" phx-click={JS.dispatch("modal:close", to: "##{@id}")}>
        <.dm_mdi name={"window-close"} class="w-4 h-4" />
      </a>
      <section class="flex flex-col absolute inset-4">
        <%= if length(@title) > 0 do %>
          <header :for={title <- @title} class={[
            "flex flex-row font-bold",
            Map.get(title, "class", "")
          ]}>
            <%= render_slot(@title) %>
          </header>
        <% end %>
        <%= render_slot(@body) %>
        <%= if length(@footer) > 0 do %>
          <footer :for={footer <- @footer} class={[
            "justify-self-end	",
            Map.get(footer, "class", "")
          ]}>
          <%= render_slot(@footer) %>
          </footer>
        <% end %>
      </section>
    </dialog>
    """
  end
end
