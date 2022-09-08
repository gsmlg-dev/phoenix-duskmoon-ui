defmodule Phoenix.WebComponent.Appbar do
  @moduledoc """
  render appbar

  """
  use Phoenix.WebComponent, :component

  @doc """
  Generates a html customElement appbar.

  """
  def appbar(assigns) do
    assigns =
      assigns
      |> assign_new(:logo, fn -> [] end)
      |> assign_new(:title, fn -> "GSMLG Title" end)
      |> assign_new(:menus, fn -> [] end)
      |> assign_new(:user_profile, fn -> [] end)

    ~H"""
    <nav role="navigation" class="bg-white shadow xl:block hidden">
        <div class="mx-auto container px-6 py-2 xl:py-0">
            <div class="flex items-center justify-between">
                <div class="inset-y-0 left-0 flex items-center xl:hidden">
                    <div class="inline-flex items-center justify-center p-2 rounded-md text-gray-700 hover:text-gray-100 focus:outline-none transition duration-150 ease-in-out">
                        <div class="visible xl:hidden">
                            <ul class="p-2 border-r bg-white absolute rounded left-0 right-0 shadow mt-8 md:mt-8 hidden">
                              <%= for menu <- @menus do %>
                                <li class="flex xl:hidden flex-col cursor-pointer text-gray-600 text-sm leading-3 tracking-normal py-2 hover:text-indigo-700 focus:text-indigo-700 focus:outline-none flex justify-center">
                                    <div class="flex items-center">
                                        <span class="ml-2 font-bold"><%= menu.label %></span>
                                    </div>
                                </li>
                              <% end %>
                            </ul>
                        </div>
                    </div>
                </div>
                <button class="focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-700 rounded-md flex w-full sm:w-auto items-center sm:items-stretch justify-end sm:justify-start">
                    <div  class="flex items-center">
                        <%= render_slot(@logo) %>
                        <h2 class="hidden sm:block text-base text-gray-700 font-bold leading-normal px-3"><%= @title %></h2>
                    </div>
                </button>
                <div class="flex">
                    <div class="hidden xl:flex md:mr-6 xl:mr-16">
                      <%= for menu <- @menus do %>
                        <a href={Map.get(menu, :to, false)} class="focus:text-indigo-700 border-b-2 border-transparent focus:border-indigo-700 flex px-5 items-center py-6 text-sm leading-5 text-gray-700 hover:bg-gray-100 focus:bg-gray-100 focus:outline-none transition duration-150 ease-in-out">
                            <%= Map.get(menu, :label, "") %>
                        </a>
                      <% end %>
                    </div>
                    <div class="hidden xl:flex items-center">
                      <%= render_slot(@user_profile) %>
                    </div>
                </div>
            </div>
        </div>
    </nav>
    <!-- split -->
    <nav>
        <div class="py-4 px-6 w-full flex xl:hidden justify-between items-center bg-white fixed top-0 z-40">
            <div aria-label="logo" role="img" tabindex="0" class="focus:outline-none w-24">
              <%= render_slot(@logo) %>
            </div>
            <div class="flex items-center">
              <%= render_slot(@user_profile) %>
            </div>
        </div>
        <!--Mobile responsive sidebar-->
        <div class="absolute w-full h-full transform -translate-x-full z-40 xl:hidden" id="mobile-nav">
            <div class="bg-gray-800 opacity-50 w-full h-full" onclick="sidebarHandler(false)"></div>
            <div class="w-64 z-40 fixed overflow-y-auto z-40 top-0 bg-white shadow h-full flex-col justify-between xl:hidden pb-4 transition duration-150 ease-in-out">
                <div class="px-6 h-full">
                    <div class="flex flex-col justify-between h-full w-full">
                        <div>
                            <div class="mt-6 flex w-full items-center justify-between">
                                <div class="flex items-center justify-between w-full">
                                    <div class="flex items-center">
                                        <%= render_slot(@logo) %>
                                        <p tabindex="0" class="focus:outline-none text-base md:text-2xl text-gray-800 ml-3"><%= @title %></p>
                                    </div>
                                </div>
                            </div>
                            <ul class="f-m-m">
                              <%= for menu <- @menus do %>
                                <li>
                                    <a class="cursor-pointer" href={Map.get(menu, :to, "")}>
                                        <div class="text-gray-800 pt-10">
                                            <div class="flex items-center">
                                                <p tabindex="0" class="focus:outline-none focus:text-indigo-600 text-indigo-700 xl:text-base text-base ml-3"><%= Map.get(menu, :label, "") %></p>
                                            </div>
                                        </div>
                                    </a>
                                </li>
                              <% end %>
                            </ul>
                        </div>
                        <div class="w-full pt-4">
                            <div class="border-t border-gray-300">
                                <div class="w-full flex items-center justify-between pt-1">
                                  <%= render_slot(@user_profile) %>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </nav>
    """
  end
end
