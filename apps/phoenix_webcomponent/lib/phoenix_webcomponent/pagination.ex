defmodule Phoenix.WebComponent.Pagination do
  @moduledoc """
  Render table.

  """
  use Phoenix.WebComponent, :component

  @doc """
  Generates a table.

  ## Examples

  ## Options

  """
  def wc_pagination(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> false end)
      |> assign_new(:page_size, fn -> 30 end)
      |> assign_new(:page_num, fn -> 1 end)
      |> assign_new(:total, fn -> 0 end)
      |> assign_new(:url_base, fn -> "\#{p}" end)

    IO.inspect(assigns)
    max_page = if assigns.total > 0 do
      assigns.total / assigns.page_size |> ceil
    else
      1
    end

    assigns = assigns |> Map.put(:max_page, max_page)
    page_num = assigns.page_num

    pages = cond do
      max_page == 1 -> [1]
      max_page < 7 -> 1..max_page |> Enum.map(&(&1))
      page_num < 3 -> [1,2,3] ++ ['...'] ++ [max_page - 2, max_page - 1, max_page]
      page_num == 3 -> [1,2,3,4] ++ ['...'] ++ [max_page - 2, max_page - 1, max_page]
      page_num > 3 && page_num < max_page - 2 -> [1] ++ ['...', page_num - 1, page_num, page_num + 1, '...'] ++ [max_page]
      page_num == max_page - 2 -> [1,2,3] ++ ['...', max_page - 3, max_page - 2, max_page - 1, max_page]
      page_num > max_page - 2 -> [1,2,3] ++ ['...', max_page - 2, max_page - 1, max_page]
    end

    assigns = assigns |> Map.put(:pages, pages)

    ~H"""
    <div id={@id} class="flex items-center justify-between border-t border-gray-200 bg-white px-4 py-3 sm:px-6">
      <div class="flex flex-1 justify-between sm:hidden">
        <a href="#" class="relative inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">Previous</a>
        <a href="#" class="relative ml-3 inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">Next</a>
      </div>
      <div class="hidden sm:flex sm:flex-1 sm:items-center sm:justify-between">
        <div>
          <p class="text-sm text-gray-700">
            Showing
            <span class="font-medium"><%= (@page_num - 1) * @page_size %></span>
            to
            <span class="font-medium"><%= @page_num * @page_size %></span>
            of
            <span class="font-medium"><%= @total %></span>
            results
          </p>
        </div>
        <div>
          <nav class="isolate inline-flex -space-x-px rounded-md shadow-sm" aria-label="Pagination">
            <a href="#" class="relative inline-flex items-center rounded-l-md border border-gray-300 bg-white px-2 py-2 text-sm font-medium text-gray-500 hover:bg-gray-50 focus:z-20">
              <span class="sr-only">Previous</span>
              <!-- Heroicon name: mini/chevron-left -->
              <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M12.79 5.23a.75.75 0 01-.02 1.06L8.832 10l3.938 3.71a.75.75 0 11-1.04 1.08l-4.5-4.25a.75.75 0 010-1.08l4.5-4.25a.75.75 0 011.06.02z" clip-rule="evenodd" />
              </svg>
            </a>
            <!-- Current: "z-10 bg-indigo-50 border-indigo-500 text-indigo-600", Default: "bg-white border-gray-300 text-gray-500 hover:bg-gray-50" -->

          <%= for p <- @pages do %>
            <a href={@url_func.(p)} aria-current={if p == @page_num, do: "page", else: false } class={"relative inline-flex items-center border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-500 hover:bg-gray-50 focus:z-20" <> if p == @page_num, do: " z-10 bg-indigo-50 border-indigo-500 text-indigo-600", else: "" }><%= p %></a>
          <% end %>

            <a href="#" class="relative inline-flex items-center rounded-r-md border border-gray-300 bg-white px-2 py-2 text-sm font-medium text-gray-500 hover:bg-gray-50 focus:z-20">
              <span class="sr-only">Next</span>
              <!-- Heroicon name: mini/chevron-right -->
              <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M7.21 14.77a.75.75 0 01.02-1.06L11.168 10 7.23 6.29a.75.75 0 111.04-1.08l4.5 4.25a.75.75 0 010 1.08l-4.5 4.25a.75.75 0 01-1.06-.02z" clip-rule="evenodd" />
              </svg>
            </a>
          </nav>
        </div>
      </div>
    </div>
    """
  end
end
