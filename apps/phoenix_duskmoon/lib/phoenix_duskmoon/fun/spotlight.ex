defmodule PhoenixDuskmoon.Fun.Spotlight do
  @moduledoc """

  render Page footer

  """
  use PhoenixDuskmoon.Component, :html

  @doc """
  Generates a Page footer.

  ## Example

      <.dmf_spotlight>
        <:section class="">
          ABC
        </:section>
        <:copyright>
          (^_^)
        </:copyright>
      </.dmf_spotlight>

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

  slot(:section,
    required: false,
    doc: """
    Page footer section
    """
  ) do
    attr(:class, :string)
    attr(:title, :string)
    attr(:title_class, :string)
    attr(:body_class, :string)
  end

  slot(:copyright,
    required: false,
    doc: """
    Page footer right side copyright.
    """
  ) do
    attr(:class, :string)
    attr(:title, :string)
    attr(:title_class, :string)
    attr(:body_class, :string)
  end

  def dmf_spotlight(assigns) do
    ~H"""
    <dialog
      id="spotlight-search-dialog"
      class="spotlight-search modal-backdrop"
    >
      <label class="input input-bordered input-primary spotlight-input">
        <input
          id="spotlight-ipt"
          type="search"
          class="w-full text-base-content"
          placeholder="Type to search..."
        >
        <kbd class="kbd kbd-sm text-base-content">⌘</kbd>
        <kbd class="kbd kbd-sm text-base-content">↵</kbd>
      </label>
    </dialog>
    """
  end
end
