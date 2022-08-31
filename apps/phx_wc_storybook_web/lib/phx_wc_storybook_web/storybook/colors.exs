defmodule PhxWCStorybookWeb.Storybook.Colors do
  use PhxLiveStorybook.Entry, :page
  def icon, do: "fat fa-swatchbook"

  def navigation do
    [
      {:default, "Default", ""},
    ]
  end

  def render(%{tab: :default}), do: render_color(%{color: Storybook.Colors.Default})

  defp render_color(assigns) do
    ~H"""
    <div class="grid grid-cols-6 gap-x-6 gap-y-12 max-w-3xl mx-auto">
      <div class="col-span-6 md:col-span-2">
        <div class={
          "p-2 text-white flex flex-col space-y-1 justify-center items-center rounded-md #{@color.info.name}"
        }>
          <code class="text-xl"><%= @color.info.main_color_hex %></code>
          <code class="text-base opacity-75"><%= @color.info.main_color %></code>
        </div>
      </div>

      <div class="col-span-6 md:col-span-4 text-lg flex flex-col justify-center">
        <%= @color.info.description %>
      </div>

      <div class="col-span-6 grid grid-cols-6 gap-x-6 gap-y-5">
        <%= for txt_style <- [:text, :text_secondary, :text_informative, :text_hover], txt_class = Map.get(@color.styles, txt_style) do %>
          <%= if txt_class do %>
            <div class="col-span-3">
              <div class="mb-3 font-medium"><%= txt_class %></div>
              <div class={txt_class}>
                Lorem ipsum dolor sit amet consectetur adipisicing elit.
              </div>
            </div>
          <% end %>
        <% end %>
      </div>

      <%= if border_class = Map.get(@color.styles, :border) do %>
        <div class="col-span-6">
          <div class="font-medium"><%= border_class %></div>
          <div class={"border-b-2 h-8 #{border_class}"}></div>
          <div class={"border-b-2 h-8 border-dashed #{border_class}"}></div>
        </div>
      <% end %>

      <div class="col-span-6 grid grid-cols-6 gap-x-6 gap-y-5">
        <%= for bg_style <- [:bg, :bg_hover, :bg_disabled], bg_class = Map.get(@color.styles, bg_style) do %>
          <%= if bg_class do %>
            <div class="col-span-6 md:col-span-3">
              <div class="mb-3 font-medium"><%= bg_class %></div>
              <div class={
                "p-4 text-white flex flex-col space-y-2 justify-center rounded-md #{bg_class}"
              }>
                <%= if text_class = Map.get(@color.styles, :text) do %>
                  <div class={text_class}>
                    Lorem Ipsum
                  </div>
                <% end %>
                <%= if text_secondary_class = Map.get(@color.styles, :text_secondary) do %>
                  <div class={text_secondary_class}>
                    dolor sit amet consectetur adipisicing elit. Ullam, voluptate.
                  </div>
                <% end %>
              </div>
            </div>
          <% end %>
        <% end %>
      </div>

      <%= for {btn_style, btn_name} <- [{:button, "Normal"}, {:button_hover, "Hover"}, {:button_focus, "Focus"}, {:button_disabled, "Disabled"}],
            btn_class = Map.get(@color.styles, btn_style) do %>
        <%= if btn_class do %>
          <div class="col-span-6 md:col-span-2">
            <div class="mb-3 font-medium"><%= String.split(btn_class, " ") |> hd() %></div>
            <div class={
              "py-2 px-4 border text-sm font-medium rounded-md text-center outline-none ring-2 ring-offset-2 #{btn_class}"
            }>
              <%= btn_name %>
            </div>
          </div>
        <% end %>
      <% end %>
    </div>

    """
  end
end

defmodule Storybook.Colors.Default do
  def info do
    %{
      name: "bg-default",
      main_color: "gray-600",
      main_color_hex: "#4B5563",
      description:
        "Default color will be used for almost all texts, borders and secondary actions."
    }
  end

  def styles do
    %{
      text: "text-default-txt",
      text_secondary: "text-default-txt-secondary",
      text_informative: "text-default-txt-informative",
      text_hover: "text-default-txt-hover",
      border: "border-default-border",
      bg: "bg-default-bg",
      bg_hover: "bg-default-bg-hover",
      bg_disabled: "bg-default-bg-disabled",
      button: "bg-white border-default-btn text-default-text ring-transparent",
      button_hover: "bg-default-btn-hover border-default-btn text-default-text ring-transparent",
      button_focus: "ring-default-btn-focus bg-white border-default-btn text-default-text",
      button_disabled:
        "bg-default-btn-disabled text-default-txt-informative ring-transparent cursor-not-allowed"
    }
  end
end
