defmodule PhoenixDuskmoon.Component.Form do
  @moduledoc """
  render appbar

  """
  use PhoenixDuskmoon.Component, :html

  import PhoenixDuskmoon.Component.Icons

  @doc """
  Renders a simple form.

  ## Examples

      <.dm_form for={@form} phx-change="validate" phx-submit="save">
        <.dm_input field={@form[:email]} label="Email"/>
        <.dm_input field={@form[:username]} label="Username" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.dm_form>
  """
  attr(:for, :any, required: true, doc: "the datastructure for the form")
  attr(:as, :any, default: nil, doc: "the server side parameter to collect all input under")

  attr(:rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart),
    doc: "the arbitrary HTML attributes to apply to the form tag"
  )

  slot(:inner_block, required: true)
  slot(:actions, doc: "the slot for form actions, such as a submit button")

  def dm_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <%= render_slot(@inner_block, f) %>
      <div :for={action <- @actions} class="mt-2 flex items-center justify-between gap-6">
        <%= render_slot(action, f) %>
      </div>
    </.form>
    """
  end

  @doc """
  Renders an input with label and error messages.

  A `Phoenix.HTML.FormField` may be passed as argument,
  which is used to retrieve the input name, id, and values.
  Otherwise all attributes may be passed explicitly.

  ## Types

  This function accepts all HTML input types, considering that:

    * You may also set `type="select"` to render a `<select>` tag

    * `type="checkbox"` is used exclusively to render boolean values

    * For live file uploads, see `Phoenix.Component.live_file_input/1`

  See https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input
  for more information.

  ## Examples

      <.dm_input field={@form[:email]} type="email" />
      <.dm_input name="my-input" errors={["oh no!"]} />
  """
  attr(:id, :any, default: nil)
  attr(:class, :any, default: nil)
  attr(:name, :any)
  attr(:label, :string, default: nil)
  attr(:value, :any)

  attr(:type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file hidden month number password
               range radio search select tel text textarea time url week checkbox_group
               radio_group)
  )

  attr(:field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"
  )

  attr(:errors, :list, default: [])
  attr(:checked, :boolean, doc: "the checked flag for checkbox inputs")
  attr(:prompt, :string, default: nil, doc: "the prompt for select inputs")
  attr(:options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2")
  attr(:multiple, :boolean, default: false, doc: "the multiple flag for select inputs")

  attr(:rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)
  )

  slot(:inner_block)

  def dm_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    # |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> dm_input()
  end

  def dm_input(%{type: "checkbox"} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn ->
        Phoenix.HTML.Form.normalize_value("checkbox", assigns[:value])
      end)

    ~H"""
    <div phx-feedback-for={@name}>
      <label class="flex items-center gap-4 text-sm leading-6 text-zinc-600">
        <input type="hidden" name={@name} value="false" />
        <input
          type="checkbox"
          id={@id}
          name={@name}
          value="true"
          checked={@checked}
          class="rounded border-zinc-300 text-zinc-900 focus:ring-0"
          {@rest}
        />
        <%= @label %>
      </label>
      <.dm_error :for={msg <- @errors}><%= msg %></.dm_error>
    </div>
    """
  end

  def dm_input(%{type: "select"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.dm_label for={@id}><%= @label %></.dm_label>
      <select
        id={@id}
        name={@name}
        class="select select-bordered w-full"
        multiple={@multiple}
        {@rest}
      >
        <option :if={@prompt} value=""><%= @prompt %></option>
        <%= Phoenix.HTML.Form.options_for_select(@options, @value) %>
      </select>
      <.dm_error :for={msg <- @errors}><%= msg %></.dm_error>
    </div>
    """
  end

  def dm_input(%{type: "checkbox_group"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.dm_label for={@id}><%= @label %></.dm_label>
      <div class="flex gap-6">
        <label class="inline-flex items-center gap-2" :for={{opt_label, opt_value} <- @options}>
          <input
            type="checkbox"
            class="checkbox"
            name={"#{@name}[]"}
            checked={Enum.member?(if(is_list(@value), do: @value, else: []), opt_value)}
            value={opt_value}
          />
          <%= opt_label %>
        </label>
      </div>
      <.dm_error :for={msg <- @errors}><%= msg %></.dm_error>
    </div>
    """
  end

  def dm_input(%{type: "radio_group"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.dm_label for={@id}><%= @label %></.dm_label>
      <div class="flex gap-6">
        <label class="inline-flex items-center gap-2" :for={{opt_label, opt_value} <- @options}>
          <input
            type="radio"
            class="radio"
            name={@name}
            checked={to_string(@value) == to_string(opt_value)}
            value={opt_value}
          />
          <%= opt_label %>
        </label>
      </div>
      <.dm_error :for={msg <- @errors}><%= msg %></.dm_error>
    </div>
    """
  end

  def dm_input(%{type: "textarea"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name} class="form-control w-full">
      <.dm_label for={@id}><%= @label %></.dm_label>
      <textarea
        id={@id}
        name={@name}
        class={[
          @class,
          "textarea textarea-bordered w-full",
          @errors != [] && "border-error focus:border-error"
        ]}
        {@rest}
      ><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
      <.dm_error :for={msg <- @errors}><%= msg %></.dm_error>
    </div>
    """
  end

  def dm_input(%{type: "file"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name} class="form-control w-full">
      <.dm_label for={@id}><%= @label %></.dm_label>
      <input
        id={@id}
        type="file"
        name={@name}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[
          @class,
          "file-input file-input-bordered w-full max-w-xs",
          @errors != [] && "border-error focus:border-error"
        ]}
        {@rest}
      />
      <.dm_error :for={msg <- @errors}><%= msg %></.dm_error>
    </div>
    """
  end

  # All other inputs text, datetime-local, url, password, etc. are handled here...
  def dm_input(assigns) do
    ~H"""
    <div phx-feedback-for={@name} class="form-control w-full">
      <.dm_label for={@id}><%= @label %></.dm_label>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[
          @class,
          "input input-bordered w-full",
          @errors != [] && "border-error focus:border-error"
        ]}
        {@rest}
      />
      <.dm_error :for={msg <- @errors}><%= msg %></.dm_error>
    </div>
    """
  end

  @doc """
  Renders a label.
  """
  attr(:for, :string, default: nil)
  slot(:inner_block, required: true)

  def dm_label(assigns) do
    ~H"""
    <label for={@for} class="label">
      <span class="label-text"><%= render_slot(@inner_block) %></span>
    </label>
    """
  end

  @doc """
  Generates a generic error message.
  """
  slot(:inner_block, required: true)

  def dm_error(assigns) do
    ~H"""
    <p class="mt-3 flex gap-3 text-sm leading-6 text-error phx-no-feedback:hidden">
      <.dm_bsi name="exclamation-circle" class="mt-0.5 h-5 w-5 flex-none" />
      <%= render_slot(@inner_block) %>
    </p>
    """
  end
end
