defmodule PhoenixDuskmoon.Fun.Element do
  @moduledoc """

  Render static Element components

  """
  use PhoenixDuskmoon.Component, :html

  @doc """
  Generates a eclipse effect

  ## Example

  ```heex
  <PhoenixDuskmoon.Fun.Element.dmf_eclipse />
  ```

  """
  @doc type: :component
  attr(:id, :any,
    default: nil,
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

  attr(:background, :string,
    default: "#09090b",
    doc: """
    Background color
    """
  )

  attr(:size, :string,
    default: "400px",
    doc: """
    size
    """
  )

  def dmf_eclipse(assigns) do
    ~H"""
    <div id={@id} class={["eclipse", @class]} style={"--bg-color: #{@background}; --size: #{@size};"}>
      <div class="layer layer-1"></div>
      <div class="layer layer-2"></div>
      <div class="layer layer-3"></div>
      <div class="layer layer-4"></div>
      <div class="layer layer-5"></div>
      <div class="layer layer-6"></div>
    </div>
    """
  end


  @doc """
  Generates a plasma ball effect

  ## Example

  ```heex
  <PhoenixDuskmoon.Fun.Element.dmf_plasma_ball />
  ```

  """
  @doc type: :component
  attr(:id, :any,
    default: nil,
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

  attr(:size, :string,
    default: "350px",
    doc: """
    size
    """
  )

  def dmf_plasma_ball(assigns) do
    ~H"""
    <div class="plasma-ball" style={"--size: #{@size};"}>
      <input type="checkbox" class="switcher" checked="checked" />
      <div class="glassball">
        <div class="electrode"></div>
        <div class="rays">
          <div class="ray">
            <span></span><span></span><span></span>
          </div>
          <div class="ray bigwave"><span></span><span></span></div>
          <div class="ray"><span></span><span></span><span></span></div>
          <div class="ray bigwave"><span></span><span></span></div>
          <div class="ray"><span></span><span></span><span></span></div>
        </div>
        <div class="rays">
          <div class="ray bigwave"><span></span><span></span></div>
          <div class="ray"><span></span><span></span><span></span></div>
          <div class="ray bigwave"><span></span><span></span></div>
          <div class="ray"><span></span><span></span><span></span></div>
          <div class="ray bigwave"><span></span><span></span></div>
        </div>
        <div class="rays">
          <div class="ray"><span></span><span></span><span></span></div>
          <div class="ray bigwave"><span></span><span></span></div>
          <div class="ray"><span></span><span></span><span></span></div>
          <div class="ray bigwave"><span></span><span></span></div>
          <div class="ray"><span></span><span></span><span></span></div>
        </div>
        <div class="rays">
          <div class="ray bigwave"><span></span><span></span></div>
          <div class="ray"><span></span><span></span><span></span></div>
          <div class="ray bigwave"><span></span><span></span></div>
          <div class="ray"><span></span><span></span><span></span></div>
          <div class="ray bigwave"><span></span><span></span></div>
        </div>
        <div class="rays">
          <div class="ray"><span></span><span></span><span></span></div>
          <div class="ray"><span></span><span></span><span></span></div>
          <div class="ray"><span></span><span></span><span></span></div>
        </div>
        <div class="rays">
          <div class="ray"><span></span><span></span><span></span></div>
          <div class="ray"><span></span><span></span><span></span></div>
          <div class="ray"><span></span><span></span><span></span></div>
        </div>

      </div>
      <div class="base">
        <div></div>
        <div></div><span></span>
      </div>
      <div class="switch"></div>
    </div>
    """
  end

  @doc """
  Generates a atom effect

  ## Example

  ```heex
  <PhoenixDuskmoon.Fun.Element.dmf_atom />
  ```

  """
  @doc type: :component
  attr(:id, :any,
    default: nil,
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

  attr(:size, :string,
    default: "200px",
    doc: """
    size
    """
  )
  def dmf_atom(assigns) do
    ~H"""
    <div id={@id} class={["atom", @class]}, style={"--atom-size: #{@size};"}>
      <div class="electron"></div>
      <div class="electron-alpha"></div>
      <div class="electron-omega"></div>
    </div>
    """
  end


  @doc """
  Generates a snow effect

  ## Example

  ```heex
  <PhoenixDuskmoon.Fun.Element.dmf_snow />
  ```

  """
  @doc type: :component
  attr(:class, :any,
    default: "",
    doc: """
    html attribute class for each snowflake
    """
  )

  attr(:count, :integer,
    default: 200,
    doc: """
    snowflake count
    """
  )
  def dmf_snow(assigns) do
    ~H"""
    <style>
    <%= for n <- 0..@count do %>
      <% random_x = Enum.random(1..1000000) * 0.0001 %>
      <% random_offset = Enum.random(-100000..100000) * 0.0001 %>
      .snowflake-<%= n %> {
        opacity: <%= Enum.random(1..10000) * 0.0001 %>;
        transform: translate(<%= random_x %>vw, -10px) scale(<%= Enum.random(1..10000) * 0.0001 %>);
        animation: snowflake-fall-<%= n %> <%= Enum.random(10..30) * 1 %>s <%= Enum.random(0..30) * -1 %>s linear infinite;
      }

      @keyframes snowflake-fall-<%= n %> {
        #{Enum.random(30000..80000) / 1000}% {
          transform: translate(<%= random_x + random_offset %>vw, <%= Enum.random(30000..80000) / 1000 %>vh) scale(<%= Enum.random(1..10000) * 0.0001 %>);
        }

        to {
          transform: translate(<%= random_x + random_offset / 2 %>vw, 100vh) scale(<%= Enum.random(1..10000) * 0.0001 %>);
        }
      }
    <% end %>
    </style>
    <div :for={n <- 0..@count} class={["snowflake", "snowflake-#{n}", @class]} />
    """
  end
end
