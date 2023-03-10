defmodule Phoenix.WebComponent.LeftMenu do
  @moduledoc """
  Render left menu.
  """
  use Phoenix.WebComponent, :html

  @doc """
  Generates left menu
  ## Example
      <.wc_left_menu
        class="w-[200px] bg-[rgba(255,255,255,.7)] text-[14px]"
        active="actionbar"
      >
        <:title class="text-[#A1A7C4]">Phx WebComponents</:title>
        <:menu>actionbar</:menu>
        <:menu>appbar</:menu>
      </.wc_left_menu>
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

  attr(:active, :string,
    default: "",
    doc: """
    actvie menu id
    """
  )

  slot(:title,
    required: false,
    doc: """
    Render menu title.
    """
  ) do
    attr(:class, :string)
  end

  slot(:menu,
    required: false,
    doc: """
    Render menu
    """
  )

  def wc_left_menu(assigns) do
    ~H"""
    <nav
      id={@id}
      class={[
        "flex flex-col justify-start items-start",
        "h-full pt-4",
        @class,
      ]}
    >
    <%= if length(@title) > 0 do %>
      <div
        :for={{title, _i} <- Enum.with_index(@title)}
        class={[
          "flex flex-row justify-start items-center",
          "px-10 py-4 w-full",
          Map.get(title, :class, ""),
        ]}
      >
        <%= render_slot(title) %>
      </div>
    <% end %>
      <div
        :for={{m, _i} <- Enum.with_index(@menu)}
        class="flex flex-col justify-start items-start w-full"
      >
        <%= render_slot(m) %>
      </div>
    </nav>
    """
  end

  @doc """
  Generates left menu Group
  ## Example
      <.wc_left_menu_group active={"mdi"}>
        <:title>Icons</:title>
        <:menu id="mdi" to={~p"/icons/mdi"}>MD Icon</:menu>
        <:menu id="bsi" to={~p"/icons/bsi"}>BS Icon</:menu>
      </.wc_left_menu_group>
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

  attr(:active, :string,
    default: "",
    doc: """
    actvie menu id
    """
  )

  slot(:title,
    required: true,
    doc: """
    Render menu title.
    """
  ) do
    attr(:class, :string)
  end

  slot(:menu,
    required: false,
    doc: """
    Render menu
    """
  ) do
    attr(:id, :string)
    attr(:class, :string)
    attr(:to, :string)
  end

  def wc_left_menu_group(assigns) do
    assigns =
      assigns
      |> assign_new(:title, fn -> nil end)

    ~H"""
    <div
      id={@id}
      class={[
        "flex flex-col justify-start items-start",
        "w-full",
        @class,
      ]}
    >
      <div
        :for={{title, _i} <- Enum.with_index(@title)}
        class={[
          "px-10 py-4 w-full",
          Map.get(title, :class, ""),
        ]}
      >
        <%= render_slot(@title) %>
      </div>
      <div class="text-slate-800 px-4 w-full">
        <.link
          :for={{m, _i} <- Enum.with_index(@menu)}
          class={[
            "flex flex-row justify-start items-center",
            "px-6 py-4 rounded-lg w-full cursor-pointer",
            if(Map.get(m, :id, "") == @active, do: " bg-blue-100 text-blue-500 hover:text-blue-600", else: "hover:text-blue-600 "),
            Map.get(m, :class, "")
          ]}
          navigate={Map.get(m, :to, "")}
        >
          <span class="indent-2.5 flex flex-row justify-start items-center">
            <%= render_slot(m) %>
          </span>
        </.link>
      </div>
    </div>
    """
  end
end
