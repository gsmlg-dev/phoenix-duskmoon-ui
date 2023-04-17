defmodule PhoenixDuskmoon.Tab do
  @moduledoc """
  render tab

  """
  use PhoenixDuskmoon, :html

  @doc """
  Generates tabs
  ## Example
      <.dm_tab active_tab_index={0}>
        <:tab>Menu1</:tab>
        <:tab>Menu2</:tab>
        <:tab_content>Menu1 Content</:tab_content>
        <:tab_content>Menu2 Content</:tab_content>
      </.dm_tab>
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

  attr(:header_class, :any,
    default: "",
    doc: """
    header html attribute class
    """
  )

  attr(:orientation, :string,
    default: "horizontal",
    values: ["horizontal", "vertical"],
    doc: """
    header html attribute class
    """
  )

  attr(:active_tab_index, :integer,
    default: 0,
    doc: """
    the index of active tab, if active_tab_name is not set, this will be used
    """
  )

  attr(:active_tab_name, :string,
    default: "",
    doc: """
    the name of active tab, use for match tab and tab_content
    """
  )

  attr(:active_tab_class, :any,
    doc: """
    class of active tab
    """
  )

  slot(:tab,
    required: false,
    doc: """
    Render tab
    """
  ) do
    attr(:id, :any)
    attr(:class, :any)
    attr(:name, :string)
  end

  slot(:tab_content,
    required: false,
    doc: """
    Render tab content
    """
  ) do
    attr(:id, :any)
    attr(:class, :any)
    attr(:name, :string)
  end

  def dm_tab(assigns) do
    assigns =
      assigns
      |> assign_new(:active_tab_class, fn ->
        if assigns[:orientation] == "horizontal" do
          "text-blue-400 border-x-0 border-t-0 border-b border-solid border-blue-400"
        else
          "text-blue-400 border-y-0 border-l-0 border-r border-solid border-blue-400"
        end
      end)

    ~H"""
    <section
      id={@id}
      class={[
        "flex gap-2",
        "w-full px-4",
        if(@orientation == "horizontal", do: "flex-col", else: "flex-row"),
        @class
      ]}
    >
      <header
        class={[
          "flex justify-start items-center gap-2",
          if(@orientation == "horizontal", do: "flex-row", else: "flex-col"),
          @header_class
        ]}
      >
      <%= for {tab, i} <- Enum.with_index(@tab) do %>
        <span
          id={Map.get(tab, :id, false)}
          class={[
            "flex flex-row",
            "py-4 px-2",
            Map.get(tab, :class, ""),
            if(@active_tab_name != "",
              do: if(@active_tab_name == Map.get(tab, :name, ""),
                do: @active_tab_class,
                else: "cursor-pointer"),
              else: if(@active_tab_index == i,
                do: @active_tab_class,
                else: "cursor-pointer"))
          ]}
          phx-click={Map.get(tab, :phx_click, nil)}
        >
          <%= render_slot(tab) %>
        </span>
      <% end %>
      </header>
      <%= for {tab_content, i} <- Enum.with_index(@tab_content) do %>
        <%= if @active_tab_name != "" do %>
          <%= if @active_tab_name == Map.get(tab_content, :name, "") do %>
            <%= render_slot(tab_content) %>
          <% end %>
        <% else %>
          <%= if @active_tab_index == i do %>
            <%= render_slot(tab_content) %>
          <% end %>
        <% end %>
      <% end %>
    </section>
    """
  end
end
