defmodule Phoenix.WebComponent.PageHeader do
  @moduledoc """

  render Page Header

  """
  use Phoenix.WebComponent, :html

  @doc """
  Generates a Page header.

  ## Example

      <.wc_page_header>
        <:menu to={~p"/storybook"}>
          Storybook
        </:menu>
        <:user_profile>
          (^_^)
        </:user_profile>
      </.wc_page_header>

  """
  @doc type: :component
  attr(:id, :string,
    default: "wc-page-header-header",
    doc: """
    html attribute id
    """
  )
  attr(:nav_id, :string,
    default: "wc-page-header-nav",
    doc: """
    nav html attribute id
    """
  )

  attr(:class, :string,
    default: "",
    doc: """
    html attribute class
    """
  )
  attr(:nav_class, :string,
    default: "",
    doc: """
    nav html attribute class
    """
  )


  slot(:menu,
    required: false,
    doc: """
    Appbar menus
    """
  ) do
    attr(:class, :string)
    attr(:to, :string)
  end

  slot(:user_profile,
    required: false,
    doc: """
    Appbar right side user_profile.
    """
  )

  def wc_page_header(assigns) do

    ~H"""
    <nav
      id={@nav_id}
      class={[
        "w-full h-12",
        "flex items-center flex-none",
        "transition-all",
        "fixed hidden",
        @nav_class
      ]}
    >
      <div class={["container mx-auto", "flex flex-row justify-between items-center"]}>
        <div class="flex flex-row gap-4">
          <a
            :for={menu <- @menu}
            class={[
              "py-2 px-6",
              "text-lg font-semibold leading-6 text-center",
              "hover:opacity-50",
              Map.get(menu, :class, "")
            ]}
            href={Map.get(menu, :to, false)}
          >
            <%= render_slot(menu) %>
          </a>
        </div>
        <div class="flex">
          <%= render_slot(@user_profile) %>
        </div>
      </div>
    </nav>
    <header
      id={@id}
      class={[
        "w-full min-h-fit",
        "flex flex-col",
        @class
      ]}
    >
      <nav class={["w-full h-12", "flex items-center flex-none"]}>
        <div class={["container mx-auto", "flex flex-row justify-between items-center"]}>
          <div class="flex flex-row gap-4">
            <a
              :for={menu <- @menu}
              class={[
                "py-2 px-6",
                "text-lg font-semibold leading-6 text-center",
                "hover:opacity-50",
                Map.get(menu, :class, "")
              ]}
              href={Map.get(menu, :to, false)}
            >
              <%= render_slot(menu) %>
            </a>
          </div>
          <div class="flex">
            <%= render_slot(@user_profile) %>
          </div>
        </div>
      </nav>
      <div class="flex-1 flex flex-col justify-center items-center">
        <%= render_slot(@inner_block) %>
      </div>
    </header>
    <script type="module">
    (function() {
      function respondToVisibility(element, callback) {
        var list = [];
        for(let i = 0; i <= 10; i++) {
          list.push(i / 10);
        }
        var options = {
          root: null,
          rootMargin: "0px",
          threshold: list,
        };

        var observer = new IntersectionObserver((entries) => {
          entries.forEach(entry => {
            callback(entry.intersectionRatio);
          });
        }, options);

        observer.observe(element);
      }
      var nid = '<%= @nav_id %>';
      var hid = '<%= @id %>';
      var nel = document.getElementById(nid);
      var hel = document.getElementById(hid);
      respondToVisibility(hel, function(intersectionRatio) {
        if (intersectionRatio <= 0.5) {
          nel.classList.remove('hidden');
          nel.style.opacity = 1 - intersectionRatio;
        } else {
          nel.classList.add('hidden');
        }
      });
    })();
    </script>
    """
  end
end
