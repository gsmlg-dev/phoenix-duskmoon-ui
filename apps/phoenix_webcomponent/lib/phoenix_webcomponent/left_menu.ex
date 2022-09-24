defmodule Phoenix.WebComponent.LeftMenu do
  @moduledoc """
  Render left menu.
  """
  use Phoenix.WebComponent, :component

  @doc """
  Generates left menu
  """
  def wc_left_menu(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> false end)
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:active, fn -> false end)
      |> assign_new(:menus, fn -> [] end)
      |> assign_new(:title, fn -> nil end)

    ~H"""
    <nav id={@id} class={"flex flex-col justify-start items-start bg-white h-full pt-4 shadow-sm z-10 #{@class}"}>
    <%= unless is_nil(@title) do %>
      <div class="w-full text-xl flex flex-col justify-center items-center mb-4">
        <%= render_slot(@title) %>
      </div>
    <% end %>
    <%= for {group, subMenu} <- @menus do %>
      <div class="flex flex-col justify-start items-start w-full">
        <div class="text-slate-400 px-10 py-4 w-full"><%= group %></div>
        <div class="text-slate-800 px-4 w-full">
        <%= for {id, menu, url} <- subMenu do %>
          <%= live_redirect to: url, class: "px-6 py-4 rounded-lg w-full flex flex-row justify-start items-center hover:text-blue-600 cursor-pointer" <> if(@active == id, do: " bg-blue-600 text-white hover:text-slate-300", else: "") do %>
            <span data-menu-id={id} class="indent-2.5"><%= menu %></span>
          <% end %>
        <% end %>
        </div>
      </div>
    <% end %>
    </nav>
    """
  end
end
