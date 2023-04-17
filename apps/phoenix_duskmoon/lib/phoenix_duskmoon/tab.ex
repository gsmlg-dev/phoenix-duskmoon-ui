defmodule PhoenixDuskmoon.Tab do
  @moduledoc """
  render tab

  """
  use PhoenixDuskmoon, :html

  import PhoenixDuskmoon.Link
  import PhoenixDuskmoon.Icons

  @doc """
  Generates tabs
  ## Example
      <.dm_tab active_tab="id1">
        <:tab id="id1">Menu1</:tab>
        <:tab id="id2">Menu2</:tab>
      </.dm_tab>
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

  attr(:active_tab, :integer,
    default: 0,
    doc: """
    the index of active tab
    """
  )

  attr(:active_tab_class, :any,
    default: "text-blue-400 border-x-0 border-t-0 border-b border-solid border-blue-400",
    doc: """
    class of active tab
    """
  )

  slot(:tab,
    required: false,
    doc: """
    Render menu
    """
  ) do
    attr :id, :string
    attr :class, :string
  end

  def dm_tab(assigns) do
    ~H"""
    <div
      id={@id}
      class={[
        "flex flex-row justify-start items-center gap-2",
        "w-full px-4",
        @class
      ]}
    >
      <%= for {tab, i} <- Enum.with_index(@tab) do %>
        <span class={[
          "flex flex-row",
          "py-4 px-2",
          if(@active_tab == i,
            do: @active_tab_class,
            else: "cursor-pointer"
          )
        ]}>
          <%= render_slot(tab) %>
        </span>
      <% end %>
    </div>
    """
  end
end
