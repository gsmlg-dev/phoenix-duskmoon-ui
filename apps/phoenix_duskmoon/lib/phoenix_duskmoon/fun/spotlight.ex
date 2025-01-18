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

  attr(:loading, :boolean,
    default: false,
    doc: """
    Loading state
    """
  )

  attr(:sugguestions, :list,
    required: false,
    doc: """
    Page footer section
    """
  )

  def dmf_spotlight(assigns) do
    assigns =assigns |> assign_new(:id, fn -> PhoenixDuskmoon.Component.generate_id() end)
    ~H"""
    <dialog
      id={@id}
      class={["spotlight-search", @class]}
    >
      <label class="input input-bordered input-primary spotlight-input">
        <input
          type="search"
          class="w-full"
          placeholder="Type to search..."
        >
        <kbd class="kbd kbd-sm text-base-content">⌘</kbd>
        <kbd class="kbd kbd-sm text-base-content">↵</kbd>
      </label>
      <div :if={@loading} class="spotlight-loading"></div>
      <div :if={is_list(assigns[:sugguestions])} class="spotlight-suggestion-list">
        <div :for={sug <- @sugguestions} class="item"></div>
      </div>
    </dialog>
    <script type="module">
    const ssd = document.getElementById('<%= @id %>');
    window.addEventListener('keydown', (evt) => {
      if (evt.metaKey && evt.code == 'KeyK') {
        ssd.showModal();
        const cb = (evt) => {
          if (evt.code === 'Escape') {
            ssd.close();
          }
          window.removeEventListener('keydown', cb);
        };
        window.addEventListener('keydown', cb);
      }
    });
    </script>
    """
  end
end
