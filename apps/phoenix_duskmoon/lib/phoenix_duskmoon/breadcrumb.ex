defmodule PhoenixDuskmoon.Breadcrumb do
  @moduledoc """
  render appbar

  """
  use PhoenixDuskmoon, :html

  @doc """
  Generates webcomponent breadcrumb
  ## Example
      <.wc_breadcrumb>
        <:crumb>Menu1</:crumb>
        <:crumb>Menu2</:crumb>
      </.wc_breadcrumb>
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

  slot(:icon,
    required: false,
    doc: """
    Render Icon
    """
  )

  slot(:crumb,
    required: true,
    doc: """
    Render menu
    """
  ) do
    attr(:id, :any)
    attr(:class, :string)
    attr(:to, :string)
  end

  def wc_breadcrumb(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> false end)
      |> assign_new(:class, fn -> "" end)

    ~H"""
    <div id={@id} class={[
      "flex flex-row justify-start items-center gap-2",
      "w-full px-4",
      @class,
    ]}>
      <%= if length(@icon) > 0 do %>
      <%= render_slot(@icon) %>
      <% else %>
      <PhoenixDuskmoon.Icons.wc_mdi name="home" class="w-4 h-4" />
      <% end %>
      <%= for {crumb, i} <- Enum.with_index(@crumb) do %>
      <span class="flex flex-row">
        <%= render_slot(crumb) %>
      </span>
      <%= if i + 1 < length(@crumb) do %>
      <span class="flex flex-row">
        /
      </span>
      <% end %>
      <% end %>
    </div>
    """
  end
end
