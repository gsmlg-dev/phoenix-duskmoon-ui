defmodule Phoenix.WebComponent.Card do
  @moduledoc """
  Render card.
  """
  use Phoenix.WebComponent, :component

  # alias Phoenix.LiveView.JS

  @doc """
  Generates card
  """
  def wc_card(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> false end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:title, fn -> nil end)

    ~H"""
    <div id={@id} class={"bg-white w-auto h-fit m-4 p-6 flex flex-col shadow #{@class}"}>
      <%= unless is_nil(@title) do %>
      <div class="w-full text-xl flex flex-row justify-start items-center h-10 mb-4">
        <%= render_slot(@title) %>
      </div>
      <% end %>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
