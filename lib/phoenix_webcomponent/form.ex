defmodule Phoenix.WebComponent.Form do
  @moduledoc ~S"""
  Helpers related to producing HTML forms.

  The functions in this module can be used in three
  distinct scenarios:

    * with changeset data - when information to populate
      the form comes from a changeset

    * with limited data - when a form is created without
      an underlying data layer. In this scenario, you can
      use the connection information (aka Plug.Conn.params)
      or pass the form values by hand

    * outside of a form  - when the functions are used directly,
      outside of `form_for`

  We will explore all three scenarios below.

  ## With changeset data

  The entry point for defining forms in Phoenix is with
  the `form_for/4` function. For this example, we will
  use `Ecto.Changeset`, which integrates nicely with Phoenix
  forms via the `phoenix_ecto` package.

  Imagine you have the following action in your controller:

      def new(conn, _params) do
        changeset = User.changeset(%User{})
        render conn, "new.html", changeset: changeset
      end

  where `User.changeset/2` is defined as follows:

      def changeset(user, params \\ %{}) do
        Ecto.Changeset.cast(user, params, [:name, :age])
      end

  Now a `@changeset` assign is available in views which we
  can pass to the form:

      <%= form_for @changeset, Routes.user_path(@conn, :create), fn f -> %>
        <label>
          Name: <%= text_input f, :name %>
        </label>

        <label>
          Age: <%= select f, :age, 18..100 %>
        </label>

        <%= wc_submit "Submit" %>
      <% end %>

  `form_for/4` receives the `Ecto.Changeset` and converts it
  to a form, which is passed to the function as the argument
  `f`. All the remaining functions in this module receive
  the form and automatically generate the input fields, often
  by extracting information from the given changeset. For example,
  if the user had a default value for age set, it will
  automatically show up as selected in the form.

  ### A note on `:errors`

  If no action has been applied to the changeset or action was set to `:ignore`,
  no errors are shown on the form object even if the changeset has a non-empty
  `:errors` value.

  This is useful for things like validation hints on form fields, e.g. an empty
  changeset for a new form. That changeset isn't valid, but we don't want to
  show errors until an actual user action has been performed.

  Ecto automatically applies the action for you when you call
  Repo.insert/update/delete, but if you want to show errors manually you can
  also set the action yourself, either directly on the `Ecto.Changeset` struct
  field or by using `Ecto.Changeset.apply_action/2`.

  ## With limited data

  `form_for/4` expects as first argument any data structure that
  implements the `Phoenix.WebComponent.FormData` protocol. By default,
  Phoenix implements this protocol for `Plug.Conn` and `Atom`.

  This is useful when you are creating forms that are not backed
  by any kind of data layer. Let's assume that we're submitting a
  form to the `:new` action in the `FooController`:

      <%= form_for @conn, Routes.foo_path(@conn, :new), [as: :foo], fn f -> %>
        <%= text_input f, :for %>
        <%= wc_submit "Search" %>
      <% end %>

  `form_for/4` uses the `Plug.Conn` to set input values from the
  request parameters.

  Alternatively, if you don't have a connection, you can pass `:foo`
  as the form data source and explicitly pass the value for every input:

      <%= form_for :foo, Routes.foo_path(MyApp.Endpoint, :new), fn f -> %>
        <%= text_input f, :for, value: "current value" %>
        <%= wc_submit "Search" %>
      <% end %>

  ## Without form data

  Sometimes we may want to generate a `text_input/3` or any other
  tag outside of a form. The functions in this module also support
  such usage by simply passing an atom as first argument instead
  of the form.

      <%= text_input :user, :name, value: "This is a prepopulated value" %>


  """

  alias Phoenix.WebComponent.Form
  import Phoenix.HTML
  import Phoenix.HTML.Tag
  import Phoenix.HTML.Form, except: [options_for_select: 2]

  @doc """
  Defines the Phoenix.WebComponent.Form struct.

  Its fields are:

    * `:source` - the data structure given to `form_for/4` that
      implements the form data protocol

    * `:impl` - the module with the form data protocol implementation.
      This is used to avoid multiple protocol dispatches.

    * `:id` - the id to be used when generating input fields

    * `:index` - the index of the struct in the form

    * `:name` - the name to be used when generating input fields

    * `:data` - the field used to store lookup data

    * `:params` - the parameters associated to this form in case
      they were sent as part of a previous request

    * `:hidden` - a keyword list of fields that are required for
      submitting the form behind the scenes as hidden inputs

    * `:options` - a copy of the options given when creating the
      form via `form_for/4` without any form data specific key

    * `:action` - the action the form is meant to wc_submit to

    * `:errors` - a keyword list of errors that associated with
      the form
  """
  defstruct source: nil,
            impl: nil,
            id: nil,
            name: nil,
            data: nil,
            hidden: [],
            params: %{},
            errors: [],
            options: [],
            index: nil,
            action: nil

  @type t :: %Form{
          source: Phoenix.HTML.FormData.t(),
          name: String.t(),
          data: %{field => term},
          params: %{binary => term},
          hidden: Keyword.t(),
          options: Keyword.t(),
          errors: Keyword.t(),
          impl: module,
          id: String.t(),
          index: nil | non_neg_integer,
          action: nil | String.t()
        }

  @type field :: atom | String.t()

  ## Form helpers

  @doc """
  Generates a text input.

  The form should either be a `Phoenix.WebComponent.Form` emitted
  by `form_for` or an atom.

  All given options are forwarded to the underlying input,
  default values are provided for id, name and value if
  possible.

  ## Examples

      # Assuming form contains a User schema
      wc_text_input(form, :name)
      #=> <mwc-textfield id="user_name" name="user[name]" type="text" value="" />

      wc_text_input(:user, :name)
      #=> <mwc-textfield id="user_name" name="user[name]" type="text" value="" />

  """
  def wc_text_input(form, field, opts \\ []) do
    generic_input(:text, form, field, opts)
  end

  @doc """
  Generates an email input.

  See `text_input/3` for example and docs.
  """
  def wc_email_input(form, field, opts \\ []) do
    generic_input(:email, form, field, opts)
  end

  @doc """
  Generates a number input.

  See `text_input/3` for example and docs.
  """
  def wc_number_input(form, field, opts \\ []) do
    generic_input(:number, form, field, opts)
  end

  @doc """
  Generates a password input.

  For security reasons, the form data and parameter values
  are never re-used in `password_input/3`. Pass the value
  explicitly if you would like to set one.

  See `text_input/3` for example and docs.
  """
  def wc_password_input(form, field, opts \\ []) do
    opts =
      opts
      |> Keyword.put_new(:label, humanize(field))
      |> Keyword.put_new(:type, "password")
      |> Keyword.put_new(:id, input_id(form, field))
      |> Keyword.put_new(:name, input_name(form, field))

    tag(:"mwc-textfield", opts)
  end

  @doc """
  Generates an url input.

  See `text_input/3` for example and docs.
  """
  def wc_url_input(form, field, opts \\ []) do
    generic_input(:url, form, field, opts)
  end

  @doc """
  Generates a search input.

  See `text_input/3` for example and docs.
  """
  def wc_search_input(form, field, opts \\ []) do
    generic_input(:search, form, field, opts)
  end

  @doc """
  Generates a telephone input.

  See `text_input/3` for example and docs.
  """
  def wc_telephone_input(form, field, opts \\ []) do
    generic_input(:tel, form, field, opts)
  end

  @doc """
  Generates a color input.

  Warning: this feature isn't available in all browsers.
  Check `http://caniuse.com/#feat=input-color` for further information.

  See `text_input/3` for example and docs.
  """
  def wc_color_input(form, field, opts \\ []) do
    generic_input(:color, form, field, opts)
  end

  @doc """
  Generates a range input.

  See `text_input/3` for example and docs.
  """
  def wc_range_input(form, field, opts \\ []) do
    generic_input(:range, form, field, opts)
  end

  @doc """
  Generates a date input.

  Warning: this feature isn't available in all browsers.
  Check `http://caniuse.com/#feat=input-datetime` for further information.

  See `text_input/3` for example and docs.
  """
  def wc_date_input(form, field, opts \\ []) do
    generic_input(:date, form, field, opts)
  end

  @doc """
  Generates a datetime-local input.

  Warning: this feature isn't available in all browsers.
  Check `http://caniuse.com/#feat=input-datetime` for further information.

  See `text_input/3` for example and docs.
  """
  def wc_datetime_local_input(form, field, opts \\ []) do
    value = Keyword.get(opts, :value, input_value(form, field))
    opts = Keyword.put(opts, :value, datetime_local_input_value(value))

    generic_input(:"datetime-local", form, field, opts)
  end

  defp datetime_local_input_value(%struct{} = value) when struct in [NaiveDateTime, DateTime] do
    <<date::10-binary, ?\s, hour_minute::5-binary, _rest::binary>> = struct.to_string(value)

    [date, ?T, hour_minute]
  end

  defp datetime_local_input_value(other), do: other

  @doc """
  Generates a time input.

  Warning: this feature isn't available in all browsers.
  Check `http://caniuse.com/#feat=input-datetime` for further information.

  ## Options

    * `:precision` - Allowed values: `:minute`, `:second`, `:millisecond`.
      Defaults to `:minute`.

  All other options are forwarded. See `text_input/3` for example and docs.

  ## Examples

      wc_time_input form, :time
      #=> <input id="form_time" name="form[time]" type="time" value="23:00">

      wc_time_input form, :time, precision: :second
      #=> <input id="form_time" name="form[time]" type="time" value="23:00:00">

      wc_time_input form, :time, precision: :millisecond
      #=> <input id="form_time" name="form[time]" type="time" value="23:00:00.000">
  """
  def wc_time_input(form, field, opts \\ []) do
    {precision, opts} = Keyword.pop(opts, :precision, :minute)
    value = opts[:value] || input_value(form, field)
    opts = Keyword.put(opts, :value, truncate_time(value, precision))

    generic_input(:time, form, field, opts)
  end

  defp truncate_time(%Time{} = time, :minute) do
    time
    |> Time.to_string()
    |> String.slice(0, 5)
  end

  defp truncate_time(%Time{} = time, precision) do
    time
    |> Time.truncate(precision)
    |> Time.to_string()
  end

  defp truncate_time(value, _), do: value

  defp generic_input(type, form, field, opts)
       when is_list(opts) and (is_atom(field) or is_binary(field)) do
    opts =
      opts
      |> Keyword.put_new(:label, humanize(field))
      |> Keyword.put_new(:type, type)
      |> Keyword.put_new(:id, input_id(form, field))
      |> Keyword.put_new(:name, input_name(form, field))
      |> Keyword.put_new(:value, input_value(form, field))
      |> Keyword.update!(:value, &maybe_html_escape/1)

    tag(:"mwc-textfield", opts)
  end

  defp maybe_html_escape(nil), do: nil
  defp maybe_html_escape(value), do: html_escape(value)

  @doc """
  Generates a textarea input.

  All given options are forwarded to the underlying input,
  default values are provided for id, name and textarea
  content if possible.

  ## Examples

      # Assuming form contains a User schema
      textarea(form, :description)
      #=> <textarea id="user_description" name="user[description]"></textarea>

  ## New lines

  Notice the generated textarea includes a new line after
  the opening tag. This is because the HTML spec says new
  lines after tags must be ignored and all major browser
  implementations do that.

  So in order to avoid new lines provided by the user
  from being ignored when the form is resubmitted, we
  automatically add a new line before the text area
  value.
  """
  def wc_textarea(form, field, opts \\ []) do
    {value, opts} = Keyword.pop(opts, :value, input_value(form, field))

    opts =
      opts
      |> Keyword.put_new(:id, input_id(form, field))
      |> Keyword.put_new(:name, input_name(form, field))
      |> Keyword.put_new(:value, value)

    content_tag(:"mwc-textarea", "", opts)
  end

  @doc """
  Generates a file input.

  It requires the given form to be configured with `multipart: true`
  when invoking `form_for/4`, otherwise it fails with `ArgumentError`.

  See `wc_text_input/3` for example and docs.
  """
  def wc_file_input(form, field, opts \\ []) do
    if match?(%Phoenix.HTML.Form{}, form) and !form.options[:multipart] do
      raise ArgumentError,
            "file_input/3 requires the enclosing form_for/4 " <>
              "to be configured with multipart: true"
    end

    opts =
      opts
      |> Keyword.put_new(:type, :file)
      |> Keyword.put_new(:id, input_id(form, field))
      |> Keyword.put_new(:name, input_name(form, field))

    opts =
      if opts[:multiple] do
        Keyword.update!(opts, :name, &"#{&1}[]")
      else
        opts
      end

    tag(:input, opts)
  end

  @doc """
  Generates a wc_submit button to send the form.

  ## Examples

      wc_submit do: "Submit"
      #=> <button type="wc_submit">Submit</button>

  """
  def wc_submit([do: _] = block_option), do: wc_submit([], block_option)

  @doc """
  Generates a wc_submit button to send the form.

  All options are forwarded to the underlying button tag.
  When called with a `do:` block, the button tag options
  come first.

  ## Examples

      wc_submit "Submit"
      #=> <button type="wc_submit">Submit</button>

      wc_submit "Submit", class: "btn"
      #=> <button class="btn" type="wc_submit">Submit</button>

      wc_submit [class: "btn"], do: "Submit"
      #=> <button class="btn" type="wc_submit">Submit</button>

  """
  def wc_submit(value, opts \\ [])

  def wc_submit(opts, [do: _] = block_option) do
    opts = Keyword.put_new(opts, :type, "submit")

    content_tag(:"mwc-button", opts, block_option)
  end

  def wc_submit(value, opts) do
    opts = Keyword.put_new(opts, :type, "submit")

    content_tag(:"mwc-button", value, opts)
  end

  @doc """
  Generates a reset input to reset all the form fields to
  their original state.

  All options are forwarded to the underlying input tag.

  ## Examples

      wc_reset "Reset"
      #=> <input type="reset" value="Reset">

      wc_reset "Reset", class: "btn"
      #=> <input type="reset" value="Reset" class="btn">

  """
  def wc_reset(value, opts \\ []) do
    opts =
      opts
      |> Keyword.put_new(:type, "reset")
      |> Keyword.put_new(:value, value)

    tag(:"mwc-button", opts)
  end

  @doc """
  Generates a radio button.

  Invoke this function for each possible value you want
  to be sent to the server.

  ## Examples

      # Assuming form contains a User schema
      wc_radio_button(form, :role, "admin")
      #=> <input id="user_role_admin" name="user[role]" type="radio" value="admin">

  ## Options

  All options are simply forwarded to the underlying HTML tag.
  """
  def wc_radio_button(form, field, value, opts \\ []) do
    escaped_value = html_escape(value)

    opts =
      opts
      |> Keyword.put_new(:type, "radio")
      |> Keyword.put_new(:id, input_id(form, field, escaped_value))
      |> Keyword.put_new(:name, input_name(form, field))

    opts =
      if escaped_value == html_escape(input_value(form, field)) do
        Keyword.put_new(opts, :checked, true)
      else
        opts
      end

    tag(:input, [value: escaped_value] ++ opts)
  end

  @doc """
  Generates a wc_checkbox.

  This function is useful for sending boolean values to the server.

  ## Examples

      # Assuming form contains a User schema
      wc_checkbox(form, :famous)
      #=> <input name="user[famous]" type="hidden" value="false">
      #=> <input checked="checked" id="user_famous" name="user[famous]" type="wc_checkbox" value="true">

  ## Options

    * `:checked_value` - the value to be sent when the wc_checkbox is checked.
      Defaults to "true"

    * `:hidden_input` - controls if this function will generate a hidden input
      to wc_submit the unchecked value or not. Defaults to "true"

    * `:unchecked_value` - the value to be sent when the wc_checkbox is unchecked,
      Defaults to "false"

    * `:value` - the value used to check if a wc_checkbox is checked or unchecked.
      The default value is extracted from the form data if available

  All other options are forwarded to the underlying HTML tag.

  ## Hidden fields

  Because an unchecked wc_checkbox is not sent to the server, Phoenix
  automatically generates a hidden field with the unchecked_value
  *before* the wc_checkbox field to ensure the `unchecked_value` is sent
  when the wc_checkbox is not marked. Set `hidden_input` to false If you
  don't want to send values from unchecked wc_checkbox to the server.
  """
  def wc_checkbox(form, field, opts \\ []) do
    opts =
      opts
      |> Keyword.put_new(:type, "checkbox")
      |> Keyword.put_new(:id, input_id(form, field))
      |> Keyword.put_new(:name, input_name(form, field))

    {value, opts} = Keyword.pop(opts, :value, input_value(form, field))
    {checked_value, opts} = Keyword.pop(opts, :checked_value, true)
    {unchecked_value, opts} = Keyword.pop(opts, :unchecked_value, false)
    {hidden_input, opts} = Keyword.pop(opts, :hidden_input, true)

    # We html escape all values to be sure we are comparing
    # apples to apples. After all we may have true in the data
    # but "true" in the params and both need to match.
    checked_value = html_escape(checked_value)
    unchecked_value = html_escape(unchecked_value)

    opts =
      Keyword.put_new_lazy(opts, :checked, fn ->
        value = html_escape(value)
        value == checked_value
      end)

    if hidden_input do
      hidden_opts = [type: "hidden", value: unchecked_value]

      html_escape([
        tag(:input, hidden_opts ++ Keyword.take(opts, [:name, :disabled, :form])),
        tag(:input, [value: checked_value] ++ opts)
      ])
    else
      html_escape([
        tag(:input, [value: checked_value] ++ opts)
      ])
    end
  end

  @doc """
  Generates a select tag with the given `options`.

  `options` are expected to be an enumerable which will be used to
  generate each respective `option`. The enumerable may have:

    * keyword lists - each keyword list is expected to have the keys
      `:key` and `:value`. Additional keys such as `:disabled` may
      be given to customize the option

    * two-item tuples - where the first element is an atom, string or
      integer to be used as the option label and the second element is
      an atom, string or integer to be used as the option value

    * atom, string or integer - which will be used as both label and value
      for the generated select

  ## Optgroups

  If `options` is map or keyword list where the first element is a string,
  atom or integer and the second element is a list or a map, it is assumed
  the key will be wrapped in an `<optgroup>` and the value will be used to
  generate `<options>` nested under the group.

  ## Examples

      # Assuming form contains a User schema
      select(form, :age, 0..120)
      #=> <mwc-select id="user_age" name="user[age]">
      #=>   <option value="0">0</option>
      #=>   ...
      #=>   <option value="120">120</option>
      #=> </mwc-select>

      select(form, :role, ["Admin": "admin", "User": "user"])
      #=> <mwc-select id="user_role" name="user[role]">
      #=>   <option value="admin">Admin</option>
      #=>   <option value="user">User</option>
      #=> </mwc-select>

      select(form, :role, [[key: "Admin", value: "admin", disabled: true],
                           [key: "User", value: "user"]])
      #=> <mwc-select id="user_role" name="user[role]">
      #=>   <option value="admin" disabled="disabled">Admin</option>
      #=>   <option value="user">User</option>
      #=> </mwc-select>

  You can also pass a prompt:

      select(form, :role, ["Admin": "admin", "User": "user"], prompt: "Choose your role")
      #=> <mwc-select id="user_role" name="user[role]">
      #=>   <option value="">Choose your role</option>
      #=>   <option value="admin">Admin</option>
      #=>   <option value="user">User</option>
      #=> </mwc-select>

  And customize the prompt as any other entry:

      select(form, :role, ["Admin": "admin", "User": "user"], prompt: [key: "Choose your role", disabled: true])
      #=> <mwc-select id="user_role" name="user[role]">
      #=>   <option value="" disabled="">Choose your role</option>
      #=>   <option value="admin">Admin</option>
      #=>   <option value="user">User</option>
      #=> </mwc-select>

  If you want to select an option that comes from the database,
  such as a manager for a given project, you may write:

      select(form, :manager_id, Enum.map(@managers, &{&1.name, &1.id}))
      #=> <mwc-select id="manager_id" name="project[manager_id]">
      #=>   <option value="1">Mary Jane</option>
      #=>   <option value="2">John Doe</option>
      #=> </mwc-select>

  Finally, if the values are a list or a map, we use the keys for
  grouping:

      select(form, :country, ["Europe": ["UK", "Sweden", "France"]], ...)
      #=> <mwc-select id="user_country" name="user[country]">
      #=>   <optgroup label="Europe">
      #=>     <option>UK</option>
      #=>     <option>Sweden</option>
      #=>     <option>France</option>
      #=>   </optgroup>
      #=>   ...
      #=> </mwc-select>

  ## Options

    * `:prompt` - an option to include at the top of the options. It may be
      a string or a keyword list of attributes and the `:key`

    * `:selected` - the default value to use when none was sent as parameter

  Be aware that a `:multiple` option will not generate a correctly
  functioning multiple select element. Use `wc_multiple_select/4` instead.

  All other options are forwarded to the underlying HTML tag.
  """
  def wc_select(form, field, options, opts \\ []) when is_atom(field) or is_binary(field) do
    {selected, opts} = selected(form, field, opts)
    options_html = options_for_select(options, selected)

    {options_html, opts} =
      case Keyword.pop(opts, :prompt) do
        {nil, opts} -> {options_html, opts}
        {prompt, opts} -> {[prompt_option(prompt) | options_html], opts}
      end

    opts =
      opts
      |> Keyword.put_new(:id, input_id(form, field))
      |> Keyword.put_new(:name, input_name(form, field))

    content_tag(:"mwc-select", options_html, opts)
  end

  defp prompt_option(prompt) when is_list(prompt) do
    {prompt_key, prompt_opts} = Keyword.pop(prompt, :key)

    prompt_key ||
      raise ArgumentError,
            "expected :key key when building a prompt select option with a keyword list: " <>
              inspect(prompt)

    prompt_option(prompt_key, prompt_opts)
  end

  defp prompt_option(key) when is_binary(key), do: prompt_option(key, [])

  defp prompt_option(key, opts) when is_list(opts) do
    content_tag(:option, key, Keyword.put_new(opts, :value, ""))
  end

  @doc """
  Returns options to be used inside a select.

  This is useful when building the select by hand.
  It expects all options and one or more select values.

  ## Examples

      options_for_select(["Admin": "admin", "User": "user"], "admin")
      #=> <option value="admin" selected="selected">Admin</option>
      #=> <option value="user">User</option>

  Groups are also supported:

      options_for_select(["Europe": ["UK", "Sweden", "France"], ...], nil)
      #=> <optgroup label="Europe">
      #=>   <option>UK</option>
      #=>   <option>Sweden</option>
      #=>   <option>France</option>
      #=> </optgroup>

  """
  def options_for_select(options, selected_values) do
    {:safe,
     escaped_options_for_select(
       options,
       selected_values |> List.wrap() |> Enum.map(&html_escape/1)
     )}
  end

  defp escaped_options_for_select(options, selected_values) do
    Enum.reduce(options, [], fn
      {option_key, option_value}, acc ->
        [acc | option(option_key, option_value, [], selected_values)]

      options, acc when is_list(options) ->
        {option_key, options} = Keyword.pop(options, :key)

        option_key ||
          raise ArgumentError,
                "expected :key key when building <option> from keyword list: #{inspect(options)}"

        {option_value, options} = Keyword.pop(options, :value)

        option_value ||
          raise ArgumentError,
                "expected :value key when building <option> from keyword list: #{inspect(options)}"

        [acc | option(option_key, option_value, options, selected_values)]

      option, acc ->
        [acc | option(option, option, [], selected_values)]
    end)
  end

  defp selected(form, field, opts) do
    {value, opts} = Keyword.pop(opts, :value)
    {selected, opts} = Keyword.pop(opts, :selected)

    if value != nil do
      {value, opts}
    else
      param = field_to_string(field)

      case form do
        %{params: %{^param => sent}} ->
          {sent, opts}

        _ ->
          {selected || input_value(form, field), opts}
      end
    end
  end

  defp option(group_label, group_values, [], value)
       when is_list(group_values) or is_map(group_values) do
    section_options = escaped_options_for_select(group_values, value)
    {:safe, contents} = content_tag(:optgroup, {:safe, section_options}, label: group_label)
    contents
  end

  defp option(option_key, option_value, extra, value) do
    option_key = html_escape(option_key)
    option_value = html_escape(option_value)
    opts = [value: option_value, selected: option_value in value] ++ extra
    {:safe, contents} = content_tag(:option, option_key, opts)
    contents
  end

  @doc """
  Generates a select tag with the given `options`.

  Values are expected to be an Enumerable containing two-item tuples
  (like maps and keyword lists) or any Enumerable where the element
  will be used both as key and value for the generated select.

  ## Examples

      # Assuming form contains a User schema
      wc_multiple_select(form, :roles, ["Admin": 1, "Power User": 2])
      #=> <select id="user_roles" name="user[roles][]">
      #=>   <option value="1">Admin</option>
      #=>   <option value="2">Power User</option>
      #=> </select>

      wc_multiple_select(form, :roles, ["Admin": 1, "Power User": 2], selected: [1])
      #=> <select id="user_roles" name="user[roles][]">
      #=>   <option value="1" selected="selected">Admin</option>
      #=>   <option value="2">Power User</option>
      #=> </select>

  When working with structs, associations and embeds, you will need to tell
  Phoenix how to extract the value out of the collection. For example,
  imagine `user.roles` is a list of `%Role{}` structs. You must call it as:

      wc_multiple_select(form, :roles, ["Admin": 1, "Power User": 2],
                      selected: Enum.map(@user.roles, &(&1.id))

  The `:selected` option will mark the given IDs as selected unless the form
  is being resubmitted. When resubmitted, it uses the form params as values.

  ## Options

    * `:selected` - the default options to be marked as selected. The values
       on this list are ignored in case ids have been set as parameters.

  All other options are forwarded to the underlying HTML tag.
  """
  def wc_multiple_select(form, field, options, opts \\ []) do
    {selected, opts} = selected(form, field, opts)

    opts =
      opts
      |> Keyword.put_new(:id, input_id(form, field))
      |> Keyword.put_new(:name, input_name(form, field) <> "[]")
      |> Keyword.put_new(:multiple, "")

    content_tag(:select, options_for_select(options, selected), opts)
  end

  ## Datetime

  @doc ~S'''
  Generates select tags for datetime.

  ## Examples

      # Assuming form contains a User schema
      wc_datetime_select form, :born_at
      #=> <select id="user_born_at_year" name="user[born_at][year]">...</select> /
      #=> <select id="user_born_at_month" name="user[born_at][month]">...</select> /
      #=> <select id="user_born_at_day" name="user[born_at][day]">...</select> —
      #=> <select id="user_born_at_hour" name="user[born_at][hour]">...</select> :
      #=> <select id="user_born_at_min" name="user[born_at][minute]">...</select>

  If you want to include the seconds field (hidden by default), pass `second: []`:

      # Assuming form contains a User schema
      wc_datetime_select form, :born_at, second: []

  If you want to configure the years range:

      # Assuming form contains a User schema
      wc_datetime_select form, :born_at, year: [options: 1900..2100]

  You are also able to configure `:month`, `:day`, `:hour`, `:minute` and
  `:second`. All options given to those keys will be forwarded to the
  underlying select. See `select/4` for more information.

  For example, if you are using Phoenix with Gettext and you want to localize
  the list of months, you can pass `:options` to the `:month` key:

      # Assuming form contains a User schema
      wc_datetime_select form, :born_at, month: [
        options: [
          {gettext("January"), "1"},
          {gettext("February"), "2"},
          {gettext("March"), "3"},
          {gettext("April"), "4"},
          {gettext("May"), "5"},
          {gettext("June"), "6"},
          {gettext("July"), "7"},
          {gettext("August"), "8"},
          {gettext("September"), "9"},
          {gettext("October"), "10"},
          {gettext("November"), "11"},
          {gettext("December"), "12"},
        ]
      ]

  You may even provide your own `localized_wc_datetime_select/3` built on top of
  `wc_datetime_select/3`:

      defp localized_wc_datetime_select(form, field, opts \\ []) do
        opts =
          Keyword.put(opts, :month, options: [
            {gettext("January"), "1"},
            {gettext("February"), "2"},
            {gettext("March"), "3"},
            {gettext("April"), "4"},
            {gettext("May"), "5"},
            {gettext("June"), "6"},
            {gettext("July"), "7"},
            {gettext("August"), "8"},
            {gettext("September"), "9"},
            {gettext("October"), "10"},
            {gettext("November"), "11"},
            {gettext("December"), "12"},
          ])

        wc_datetime_select(form, field, opts)
      end

  ## Options

    * `:value` - the value used to select a given option.
      The default value is extracted from the form data if available

    * `:default` - the default value to use when none was given in
      `:value` and none is available in the form data

    * `:year`, `:month`, `:day`, `:hour`, `:minute`, `:second` - options passed
      to the underlying select. See `select/4` for more information.
      The available values can be given in `:options`.

    * `:builder` - specify how the select can be build. It must be a function
      that receives a builder that should be invoked with the select name
      and a set of options. See builder below for more information.

  ## Builder

  The generated wc_datetime_select can be customized at will by providing a
  builder option. Here is an example from EEx:

      <%= wc_datetime_select form, :born_at, builder: fn b -> %>
        Date: <%= b.(:day, []) %> / <%= b.(:month, []) %> / <%= b.(:year, []) %>
        Time: <%= b.(:hour, []) %> : <%= b.(:minute, []) %>
      <% end %>

  Although we have passed empty lists as options (they are required), you
  could pass any option there and it would be given to the underlying select
  input.

  In practice, we recommend you to create your own helper with your default
  builder:

      def my_wc_datetime_select(form, field, opts \\ []) do
        builder = fn b ->
          assigns = %{b: b}

          ~H"""
          Date: <%= @b.(:day, []) %> / <%= @b.(:month, []) %> / <%= @b.(:year, []) %>
          Time: <%= @b.(:hour, []) %> : <%= @b.(:minute, []) %>
          """
        end

        wc_datetime_select(form, field, [builder: builder] ++ opts)
      end

  Then you are able to use your own wc_datetime_select throughout your whole
  application.

  ## Supported date values

  The following values are supported as date:

    * a map containing the `year`, `month` and `day` keys (either as strings or atoms)
    * a tuple with three elements: `{year, month, day}`
    * a string in ISO 8601 format
    * `nil`

  ## Supported time values

  The following values are supported as time:

    * a map containing the `hour` and `minute` keys and an optional `second` key (either as strings or atoms)
    * a tuple with three elements: `{hour, min, sec}`
    * a tuple with four elements: `{hour, min, sec, usec}`
    * `nil`

  '''
  def wc_datetime_select(form, field, opts \\ []) do
    value = Keyword.get(opts, :value, input_value(form, field) || Keyword.get(opts, :default))

    builder =
      Keyword.get(opts, :builder) ||
        fn b ->
          date = date_builder(b, opts)
          time = time_builder(b, opts)
          html_escape([date, raw(" &mdash; "), time])
        end

    builder.(datetime_builder(form, field, date_value(value), time_value(value), opts))
  end

  @doc """
  Generates select tags for date.

  Check `wc_datetime_select/3` for more information on options and supported values.
  """
  def wc_date_select(form, field, opts \\ []) do
    value = Keyword.get(opts, :value, input_value(form, field) || Keyword.get(opts, :default))
    builder = Keyword.get(opts, :builder) || (&date_builder(&1, opts))
    builder.(datetime_builder(form, field, date_value(value), nil, opts))
  end

  defp date_builder(b, _opts) do
    html_escape([b.(:year, []), raw(" / "), b.(:month, []), raw(" / "), b.(:day, [])])
  end

  defp date_value(%{"year" => year, "month" => month, "day" => day}),
    do: %{year: year, month: month, day: day}

  defp date_value(%{year: year, month: month, day: day}),
    do: %{year: year, month: month, day: day}

  defp date_value({{year, month, day}, _}), do: %{year: year, month: month, day: day}
  defp date_value({year, month, day}), do: %{year: year, month: month, day: day}

  defp date_value(nil), do: %{year: nil, month: nil, day: nil}

  defp date_value(string) when is_binary(string) do
    string
    |> Date.from_iso8601!()
    |> date_value
  end

  defp date_value(other), do: raise(ArgumentError, "unrecognized date #{inspect(other)}")

  @doc """
  Generates select tags for time.

  Check `wc_datetime_select/3` for more information on options and supported values.
  """
  def wc_time_select(form, field, opts \\ []) do
    value = Keyword.get(opts, :value, input_value(form, field) || Keyword.get(opts, :default))
    builder = Keyword.get(opts, :builder) || (&time_builder(&1, opts))
    builder.(datetime_builder(form, field, nil, time_value(value), opts))
  end

  defp time_builder(b, opts) do
    time = html_escape([b.(:hour, []), raw(" : "), b.(:minute, [])])

    if Keyword.get(opts, :second) do
      html_escape([time, raw(" : "), b.(:second, [])])
    else
      time
    end
  end

  defp time_value(%{"hour" => hour, "minute" => min} = map),
    do: %{hour: hour, minute: min, second: Map.get(map, "second", 0)}

  defp time_value(%{hour: hour, minute: min} = map),
    do: %{hour: hour, minute: min, second: Map.get(map, :second, 0)}

  defp time_value({_, {hour, min, sec}}),
    do: %{hour: hour, minute: min, second: sec}

  defp time_value({hour, min, sec}),
    do: %{hour: hour, minute: min, second: sec}

  defp time_value(nil), do: %{hour: nil, minute: nil, second: nil}

  defp time_value(string) when is_binary(string) do
    string
    |> Time.from_iso8601!()
    |> time_value
  end

  defp time_value(other), do: raise(ArgumentError, "unrecognized time #{inspect(other)}")

  @months [
    {"January", "1"},
    {"February", "2"},
    {"March", "3"},
    {"April", "4"},
    {"May", "5"},
    {"June", "6"},
    {"July", "7"},
    {"August", "8"},
    {"September", "9"},
    {"October", "10"},
    {"November", "11"},
    {"December", "12"}
  ]

  map =
    &Enum.map(&1, fn i ->
      pre = if i < 10, do: "0"
      {"#{pre}#{i}", i}
    end)

  @days map.(1..31)
  @hours map.(0..23)
  @minsec map.(0..59)

  defp datetime_builder(form, field, date, time, parent) do
    id = Keyword.get(parent, :id, input_id(form, field))
    name = Keyword.get(parent, :name, input_name(form, field))

    fn
      :year, opts when date != nil ->
        {year, _, _} = :erlang.date()

        {value, opts} =
          datetime_options(:year, (year - 5)..(year + 5), id, name, parent, date, opts)

        select(:datetime, :year, value, opts)

      :month, opts when date != nil ->
        {value, opts} = datetime_options(:month, @months, id, name, parent, date, opts)
        select(:datetime, :month, value, opts)

      :day, opts when date != nil ->
        {value, opts} = datetime_options(:day, @days, id, name, parent, date, opts)
        select(:datetime, :day, value, opts)

      :hour, opts when time != nil ->
        {value, opts} = datetime_options(:hour, @hours, id, name, parent, time, opts)
        select(:datetime, :hour, value, opts)

      :minute, opts when time != nil ->
        {value, opts} = datetime_options(:minute, @minsec, id, name, parent, time, opts)
        select(:datetime, :minute, value, opts)

      :second, opts when time != nil ->
        {value, opts} = datetime_options(:second, @minsec, id, name, parent, time, opts)
        select(:datetime, :second, value, opts)
    end
  end

  defp datetime_options(type, values, id, name, parent, datetime, opts) do
    opts = Keyword.merge(Keyword.get(parent, type, []), opts)
    suff = Atom.to_string(type)

    {value, opts} = Keyword.pop(opts, :options, values)

    {value,
     opts
     |> Keyword.put_new(:id, id <> "_" <> suff)
     |> Keyword.put_new(:name, name <> "[" <> suff <> "]")
     |> Keyword.put_new(:value, Map.get(datetime, type))}
  end

  # Normalize field name to string version
  defp field_to_string(field) when is_atom(field), do: Atom.to_string(field)
  defp field_to_string(field) when is_binary(field), do: field
end
