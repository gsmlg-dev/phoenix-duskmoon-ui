defmodule PhoenixDuskmoon.Component.Pagination do
  @moduledoc """
  Render pagination.

  """
  use PhoenixDuskmoon.Component, :html

  @doc """
  Generates a pagination.

  ## Examples

      <.dm_pagination page_num={5} page_size={15} total={100} update_event="update-page"/>

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

  attr(:page_size, :integer,
    default: 10,
    doc: """
    items shows per page
    """
  )

  attr(:page_num, :integer,
    default: 1,
    doc: """
    page num
    """
  )

  attr(:total, :integer,
    default: 0,
    doc: """
    total items count
    """
  )

  attr(:update_event, :string,
    default: "update_current_page",
    doc: """
    Phoenix live event name for page status update.
    """
  )

  def dm_pagination(assigns) do
    max_page =
      if assigns.total > 0 do
        (assigns.total / assigns.page_size) |> ceil
      else
        1
      end

    page_num = assigns.page_num

    pages =
      cond do
        max_page == 1 ->
          [1]

        max_page < 7 ->
          1..max_page |> Enum.map(& &1)

        page_num < 3 ->
          [1, 2, 3] ++ ["..."] ++ [max_page - 2, max_page - 1, max_page]

        page_num == 3 ->
          [1, 2, 3, 4] ++ ["..."] ++ [max_page - 2, max_page - 1, max_page]

        page_num > 3 && page_num < max_page - 2 ->
          [1] ++ ["...", page_num - 1, page_num, page_num + 1, "..."] ++ [max_page]

        page_num == max_page - 2 ->
          [1, 2, 3] ++ ["...", max_page - 3, max_page - 2, max_page - 1, max_page]

        page_num > max_page - 2 ->
          [1, 2, 3] ++ ["...", max_page - 2, max_page - 1, max_page]
      end

    assigns =
      assigns
      |> assign(:max_page, max_page)
      |> assign(:pages, pages)

    ~H"""
    <div
      id={@id}
      class={[
        "flex items-center justify-end",
        "border-t border-gray-200",
        "bg-white px-4 py-3",
        @class
      ]}
    >
      <div class="flex flex-row items-center mx-8">
        <div class="inline-flex flex-row items-center mx-8">
          <p class="inline-flex flex-row items-center text-medium text-gray-700">
            <span class="mr-1 after:content-[':']">Total</span>
            <span class="font-medium"><%= @total %></span>
          </p>
        </div>
        <div>
          <nav class="isolate inline-flex -space-x-px rounded-md shadow-sm" aria-label="Pagination">
            <span
              phx-click={if @page_num == 1, do: false, else: @update_event}
              phx-value-current={if @page_num == 1, do: nil, else: @page_num - 1}
              disabled={if @page_num == 1, do: true, else: false}
              class={[
                "relative inline-flex items-center",
                "rounded-l-md border border-gray-300",
                "bg-white hover:bg-gray-50 px-2 py-2",
                "text-sm font-medium text-gray-500 focus:z-20",
                if(@page_num == 1, do: "", else: "cursor-pointer"),
              ]}>
              <span class="sr-only">Previous</span>
              <!-- Heroicon name: mini/chevron-left -->
              <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M12.79 5.23a.75.75 0 01-.02 1.06L8.832 10l3.938 3.71a.75.75 0 11-1.04 1.08l-4.5-4.25a.75.75 0 010-1.08l4.5-4.25a.75.75 0 011.06.02z" clip-rule="evenodd" />
              </svg>
            </span>
            <!-- Current: "z-10 bg-indigo-50 border-indigo-500 text-indigo-600", Default: "bg-white border-gray-300 text-gray-500 hover:bg-gray-50" -->

          <%= for p <- @pages do %>
            <%= if is_binary(p) do %>
              <span
                class={[
                  "relative inline-flex items-center",
                  "border border-gray-300",
                  "bg-white hover:bg-gray-50",
                  "px-4 py-2",
                  "text-sm font-medium text-gray-500 focus:z-20",
                ]}
              ><%= p %></span>
            <% else %>
              <span
                phx-click={@update_event} phx-value-current={p}
                aria-current={if p == @page_num, do: "page", else: false }
                class={[
                  "relative inline-flex items-center",
                  "border border-gray-300",
                  "bg-white hover:bg-gray-50 px-4 py-2",
                  "text-sm font-medium text-gray-500 focus:z-20",
                  if(p == @page_num, do: "z-10 bg-indigo-50 border-indigo-500 text-indigo-600", else: "cursor-pointer"),
                ]}
              ><%= p %></span>
            <% end %>
          <% end %>

            <span
              phx-click={if @page_num == @max_page, do: false, else: @update_event}
              phx-value-current={if @page_num == @max_page, do: nil, else: @page_num + 1}
              disabled={if @page_num == @max_page, do: true, else: false}
              class={[
                "inline-flex items-center",
                "relative px-2 py-2",
                "border border-gray-300 rounded-r-md",
                "bg-white hover:bg-gray-50",
                "text-sm font-medium text-gray-500 focus:z-20",
                if(@page_num == @max_page, do: "", else: "cursor-pointer"),
              ]}>
              <span class="sr-only">Next</span>
              <!-- Heroicon name: mini/chevron-right -->
              <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M7.21 14.77a.75.75 0 01.02-1.06L11.168 10 7.23 6.29a.75.75 0 111.04-1.08l4.5 4.25a.75.75 0 010 1.08l-4.5 4.25a.75.75 0 01-1.06-.02z" clip-rule="evenodd" />
              </svg>
            </span>
          </nav>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Generates a Pagination.
  Use daisyui style.

  ## Examples

      <.dm_pagination_thin page_num={5} page_size={15} total={100} update_event="update-page" loading={false} />

  """
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

  attr(
    :loading,
    :boolean,
    default: false,
    doc: """
    when loading, disable the pagination
    """
  )

  attr(
    :show_page_jumper,
    :boolean,
    default: false,
    doc: """
    show quick jumper
    """
  )

  attr(:page_size, :integer,
    default: 10,
    doc: """
    items shows per page
    """
  )

  attr(:page_num, :integer,
    default: 1,
    doc: """
    page num
    """
  )

  attr(:total, :integer,
    default: 0,
    doc: """
    total items count
    """
  )

  attr(:update_event, :string,
    default: "update_current_page",
    doc: """
    Phoenix live event name for page status update.
    """
  )

  def dm_pagination_thin(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> false end)

    max_page =
      if assigns.total > 0 do
        (assigns.total / assigns.page_size) |> ceil
      else
        1
      end

    page_num = assigns.page_num

    pages =
      cond do
        max_page == 1 ->
          [1]

        max_page < 7 ->
          1..max_page |> Enum.map(& &1)

        page_num < 3 ->
          [1, 2, 3] ++ ["..."] ++ [max_page - 2, max_page - 1, max_page]

        page_num == 3 ->
          [1, 2, 3, 4] ++ ["..."] ++ [max_page - 2, max_page - 1, max_page]

        page_num > 3 && page_num < max_page - 2 ->
          [1] ++ ["...", page_num - 1, page_num, page_num + 1, "..."] ++ [max_page]

        page_num == max_page - 2 ->
          [1, 2, 3] ++ ["...", max_page - 3, max_page - 2, max_page - 1, max_page]

        page_num > max_page - 2 ->
          [1, 2, 3] ++ ["...", max_page - 2, max_page - 1, max_page]
      end

    assigns =
      assigns
      |> assign(:max_page, max_page)
      |> assign(:pages, pages)

    ~H"""
    <div id={@id} class="flex items-center justify-end">
      <div class="flex flex-row items-center justify-end flex-wrap-reverse gap-6">
        <div class="flex flex-row items-center h-8">
          <p class="text-medium text-gray-700 whitespace-nowrap">
            <span class="mr-1 after:content-[':']">Total</span>
            <span class="font-medium"><%= @total %></span>
          </p>
        </div>
        <div>
          <nav class="join" aria-label="Pagination">
            <span
              phx-click={if(@page_num == 1 || @loading, do: false, else: @update_event)}
              phx-value-current={if @page_num == 1, do: nil, else: @page_num - 1}
              disabled={if @page_num == 1, do: true, else: false}
              class={[
                if(@page_num == 1, do: "", else: "cursor-pointer"),
                "join-item btn btn-sm",
                if(@loading, do: "cursor-wait")
              ]}
            >
              <span class="sr-only">Previous</span>
              <!-- Heroicon name: mini/chevron-left -->
              <svg
                class="h-5 w-5"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 20 20"
                fill="currentColor"
                aria-hidden="true"
              >
                <path
                  fill-rule="evenodd"
                  d="M12.79 5.23a.75.75 0 01-.02 1.06L8.832 10l3.938 3.71a.75.75 0 11-1.04 1.08l-4.5-4.25a.75.75 0 010-1.08l4.5-4.25a.75.75 0 011.06.02z"
                  clip-rule="evenodd"
                />
              </svg>
            </span>

            <%= for p <- @pages do %>
              <%= if is_binary(p) do %>
                <span class="join-item btn btn-sm"><%= p %></span>
              <% else %>
                <span
                  phx-click={if(@loading, do: false, else: @update_event)}
                  phx-value-current={p}
                  aria-current={if p == @page_num, do: "page", else: false}
                  class={[
                    "join-item btn btn-sm",
                    if(p == @page_num, do: " bg-primary text-primary-content", else: " cursor-pointer"),
                    if(@loading, do: "cursor-wait")
                  ]}
                >
                  <%= p %>
                </span>
              <% end %>
            <% end %>

            <span
              phx-click={if(@page_num == @max_page || @loading, do: false, else: @update_event)}
              phx-value-current={if @page_num == @max_page, do: nil, else: @page_num + 1}
              disabled={if @page_num == @max_page, do: true, else: false}
              class={[
                if(@page_num == @max_page, do: "", else: "cursor-pointer"),
                "join-item btn btn-sm",
                if(@loading, do: "cursor-wait")
              ]}
            >
              <span class="sr-only">Next</span>
              <!-- Heroicon name: mini/chevron-right -->
              <svg
                class="h-5 w-5"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 20 20"
                fill="currentColor"
                aria-hidden="true"
              >
                <path
                  fill-rule="evenodd"
                  d="M7.21 14.77a.75.75 0 01.02-1.06L11.168 10 7.23 6.29a.75.75 0 111.04-1.08l4.5 4.25a.75.75 0 010 1.08l-4.5 4.25a.75.75 0 01-1.06-.02z"
                  clip-rule="evenodd"
                />
              </svg>
            </span>
          </nav>
        </div>
        <div :if={@show_page_jumper}>
          <div class="text-medium flex-nowrap flex items-center gap-2">
            <span>Page</span>
            <form class="font-medium" phx-change={if(@loading, do: false, else: @update_event)}>
              <input
                type="number"
                name="current"
                class={["input input-sm w-auto text-right"]}
                min={1}
                max={@max_page}
                phx-debounce={300}
                oninput={"this.value = Math.round(this.value);if(this.value<1){this.value=1}if(this.value>#{@max_page}){this.value=#{max_page}}"}
                value={@page_num}
              />
            </form>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
