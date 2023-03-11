defmodule PhoenixDuskmoon.Modal do
  use PhoenixDuskmoon, :html

  alias Phoenix.LiveView.JS

  slot(:title, doc: "Modal title")
  slot(:body, doc: "Modal content", required: true)
  slot(:button, doc: "Modal buttons, displayed in footer")

  def dm_modal(assigns) do
    ~H"""
    <div id="modal-overlay" class="hidden z-10 fixed inset-0 backdrop-blur-lg bg-black/20"></div>
    <div id="modal-container" class="hidden fixed inset-0 z-20 overflow-y-auto">
      <div
        class={[
          "flex items-end sm:items-center justify-center",
          "min-h-full p-4 text-center sm:p-0",
        ]}
      >
        <div
          id="modal-content"
          phx-click-away={dm_hide_modal()}
          class={[
            "relative bg-white rounded-lg",
            "px-4 pt-5 pb-4",
            "text-left overflow-hidden shadow-xl",
            "transform transition-all",
            "sm:my-8 sm:max-w-sm sm:w-full sm:p-6"
          ]}
        >
          <div>
            <div class="mt-3 text-center sm:mt-5">
              <h3
                :for={t <- @title}
                class="text-lg leading-6 font-medium text-gray-900"
              ><%= render_slot(t) %></h3>
              <div class="mt-2">
                <p class="text-sm text-gray-500">
                  <%= render_slot(@body) %>
                </p>
              </div>
            </div>
          </div>
          <%= if assigns[:button] do %>
            <div class="mt-5 sm:mt-6 flex justify-end space-x-2">
              <%= for button <- @button do %>
                <%= render_slot(button) %>
              <% end %>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  def dm_hide_modal() do
    %JS{}
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.hide(to: "#modal-overlay")
    |> JS.hide(
      transition: {
        "ease-in duration-200",
        "opacity-100 translate-y-0 md:scale-100",
        "opacity-0 translate-y-4 md:translate-y-0 md:scale-95"
      },
      to: "#modal-content"
    )
    |> JS.hide(to: "#modal-container")
  end

  def dm_show_modal(js \\ %JS{}) do
    js
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.show(to: "#modal-container")
    |> JS.show(to: "#modal-overlay")
    |> JS.show(
      transition: {
        "transition ease-in-out duration-200",
        "opacity-0 translate-y-4",
        "opacity-100 translate-y-0"
      },
      to: "#modal-content"
    )
  end
end
