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

  attr(:hide_close, :boolean,
    default: false,
    doc: "Hide top right close button"
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
        "modal",
        "p-4",
        @class
      ]}
    >
      <%= unless @hide_close do %>
      <a class="absolute right-2 top-2 cursor-pointer" phx-click={JS.dispatch("modal:close", to: "##{@id}")}>
        <.dm_mdi name={"window-close"} class="w-4 h-4" />
      </a>
      <% end %>
      <section class="flex flex-col min-h-[200px] min-w-[420px]">
        <header :for={title <- @title} class={[
          "flex flex-row font-bold w-full text-2xl",
          Map.get(title, :class, "")
        ]}>
          <%= render_slot(title, JS.dispatch("modal:close", to: "##{@id}")) %>
        </header>
        <div :for={body <- @body} class={[
          "flex flex-1",
          Map.get(body, :class, "")
        ]}>
          <%= render_slot(body, JS.dispatch("modal:close", to: "##{@id}")) %>
        </div>
        <footer :for={footer <- @footer} class={[
          "flex justify-end gap-4",
          Map.get(footer, :class, "")
        ]}>
          <%= render_slot(footer, JS.dispatch("modal:close", to: "##{@id}")) %>
        </footer>
      </section>
    </dialog>
    """
  end
end
