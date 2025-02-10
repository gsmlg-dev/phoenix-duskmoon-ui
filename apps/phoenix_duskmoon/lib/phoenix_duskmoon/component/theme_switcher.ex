defmodule PhoenixDuskmoon.Component.ThemeSwitcher do
  @moduledoc """
  Duskmoon UI ThemeSwitcher Component
  """
  use PhoenixDuskmoon.Component, :html

  @doc """
  A theme switcher component.
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

  attr(:theme, :string,
    default: "",
    doc: """
    The theme to use.
    """
  )

  def dm_theme_switcher(assigns) do
    assigns = assigns |> assign_new(:rid, fn -> Enum.random(0..999_999) end)

    ~H"""
    <div id={@id || "theme-switcher-#{@rid}"} class={["dropdown", @class]}>
      <div tabindex="0" role="button" class="btn btn-ghost">
        Theme
        <svg
          width="12px"
          height="12px"
          class="inline-block h-2 w-2 fill-current opacity-60"
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 2048 2048"
        >
          <path d="M1799 349l242 241-1017 1017L7 590l242-241 775 775 775-775z"></path>
        </svg>
      </div>
      <ul tabindex="0" class="dropdown-content z-1">
        <li>
          <input
            type="radio"
            name="theme-dropdown"
            class="theme-controller w-full btn btn-sm btn-secondary btn-block justify-center"
            aria-label="Auto"
            value="default"
            checked={@theme == "default"}
          />
        </li>
        <li>
          <input
            type="radio"
            name="theme-dropdown"
            class="theme-controller w-full btn btn-sm btn-secondary btn-block justify-center"
            aria-label="Sunshine"
            value="sunshine"
            checked={@theme == "sunshine"}
          />
        </li>
        <li>
          <input
            type="radio"
            name="theme-dropdown"
            class="theme-controller w-full btn btn-sm btn-secondary btn-block justify-center"
            aria-label="Moonlight"
            value="moonlight"
            checked={@theme == "moonlight"}
          />
        </li>
      </ul>
    </div>
    <script>
      (function() {
        const once = (cb) => {
          let called = false;
          requestAnimationFrame(() => {
            if (called === false) {
              called = true;
              cb();
            }
          });
        };
        const serverTheme = "<%= @theme %>";
        let theme = serverTheme || localStorage.getItem("theme") || "default";
        const themeSwitcher = document.getElementById("<%= @id || "theme-switcher-#{@rid}" %>");
        const themeControllers = themeSwitcher.querySelectorAll(".theme-controller");
        themeControllers.forEach(c => c.checked = theme === c.value);

        themeControllers.forEach(function(controller) {
          controller.addEventListener("change", function(event) {
            theme = event.target.value;
            requestAnimationFrame(() => {
              localStorage.setItem("theme", theme);
            });
          });
        });

      })();
    </script>
    """
  end
end
