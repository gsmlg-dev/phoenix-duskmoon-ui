defmodule Phoenix.WebComponent.LeftMenu do
  @moduledoc """
  Render left menu.
  """
  use Phoenix.WebComponent, :html

  @doc """
  Generates left menu

  ## Example

      <.wc_left_menu active="left_menu" menus={[{"Components", [{"actionbar", "Actionbar", "/storybook/components/actionbar"}, {"card", "Card", "/storybook/components/card"}, {"left_menu", "Left Menu", "/storybook/components/left_menu"}, {"markdown", "Markdown", "/storybook/components/markdown"}, {"pagination", "Pagination", "/storybook/components/pagination"}, {"table", "Table", "/storybook/components/table"}]}]}>
        <:title>Menu Demo Components</:title>
      </.wc_left_menu>

  """
  @doc type: :component
  attr(:id, :any,
    default: false,
    doc: """
    html attribute id
    """
  )

  attr(:class, :string,
    default: "",
    doc: """
    html attribute class
    """
  )

  attr(:active, :string,
    default: "",
    doc: """
    actvie menu id
    """
  )

  attr(:menus, :list,
    default: [],
    doc: """
    menu list
    ```elixir
    [
      {"Components",
        [
          {"actionbar", "Actionbar", "/storybook/components/actionbar"},
          {"card", "Card", "/storybook/components/card"},
          {"left_menu", "Left Menu", "/storybook/components/left_menu"},
          {"markdown", "Markdown", "/storybook/components/markdown"},
          {"pagination", "Pagination", "/storybook/components/pagination"},
          {"table", "Table", "/storybook/components/table"}
        ]
      }
    ]
    ```
    """
  )

  slot(:title,
    required: false,
    doc: """
    Render menu title.
    """
  )

  def wc_left_menu(assigns) do
    assigns =
      assigns
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
          <.link
            navigate={url}
            class={"px-6 py-4 rounded-lg w-full flex flex-row justify-start items-center hover:text-blue-600 cursor-pointer" <> if(@active == id, do: " bg-blue-600 text-white hover:text-slate-300", else: "")}
          >
            <span data-menu-id={id} class="indent-2.5"><%= menu %></span>
          </.link>
        <% end %>
        </div>
      </div>
    <% end %>
    </nav>
    """
  end
end
