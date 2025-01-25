defmodule PhoenixDuskmoon.Fun.Spotlight do
  @moduledoc """

  Render Spotlight search dialog

  """
  use PhoenixDuskmoon.Component, :html

  @doc """
  Generates a spotlight style search.

  ## Example

  ```heex
      <PhoenixDuskmoon.Fun.Spotlight.dmf_spotlight />
  ```

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

  slot(:sugguestion,
    required: false,
    doc: """
    Search sugguestion slot
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
      <div :if={length(assigns[:sugguestion]) > 0} class="spotlight-suggestion-list">
        <div :for={sug <- @sugguestion} class="item">
          {render_slot(sug)}
        </div>
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
