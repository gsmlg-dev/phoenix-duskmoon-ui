defmodule PhoenixDuskmoon.Component.Button do
  @moduledoc """
  render button

  """
  use PhoenixDuskmoon.Component, :html
  import PhoenixDuskmoon.Component.Icons

  @spec dm_btn(map()) :: Phoenix.LiveView.Rendered.t()
  @doc """
  Generates a button.
  [INSERT LVATTRDOCS]
  ## Examples
  ```heex
  <.dm_btn id="show-btn">Show</.dm_btn>
  ```
  ```heex
  <.dm_btn id="remove-btn" confirm_action={JS.push("remove", value: %{"id" => @id})}>Remove</.dm_btn>
  ```
  """
  @doc type: :component
  attr(:id, :string, required: true)
  attr(:class, :any, default: nil, doc: "the class of the button")

  attr(:confirm_class, :any,
    default: nil,
    doc: "the class of the confirm action button in dialog"
  )

  attr(:cancel_class, :any, default: nil, doc: "the class of the cancel action button in dialog")
  attr(:confirm_title, :string, default: "")
  attr(:confirm, :string, default: "")

  attr(:confirm_action, :string, doc: "the action of the confirm action button in dialog")

  attr(:rest, :global,
    doc: """
    Additional attributes to confirm action button.
    """
  )

  slot(:inner_block,
    required: true,
    doc: """
    The content rendered inside of the `button` tag.
    """
  )

  def dm_btn(%{confirm: confirm} = assigns) when confirm != "" do
    ~H"""
    <button
      id={@id}
      class={["btn", @class]}
      onclick={"document.getElementById('confirm-dialog-#{@id}').showModal()"}
      {@rest}
    ><%= render_slot(@inner_block) %></button>
    <dialog id={"confirm-dialog-#{@id}"} class="modal">
      <div class="modal-box">
        <form method="dialog">
          <button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">
            <.dm_mdi class="w-4 h-4" name="close" />
          </button>
        </form>
        <h3
          :if={String.length(@confirm_title) > 0}
          class="font-bold text-lg text-primary"
        >
          <%= @confirm_title %>
        </h3>
        <p class="py-4">
          <%= @confirm %>
        </p>
        <div class="modal-action">
          <form method="dialog">
            <button class={["btn", @confirm_class]} {@rest}>
              Yes
            </button>
          </form>
          <form method="dialog">
            <button class={["btn", @cancel_class]}>
              No
            </button>
          </form>
        </div>
      </div>
    </dialog>
    """
  end

  def dm_btn(%{} = assigns) do
    ~H"""
    <button
      id={@id}
      class={["btn", @class]}
      {@rest}
    ><%= render_slot(@inner_block) %></button>
    """
  end
end
