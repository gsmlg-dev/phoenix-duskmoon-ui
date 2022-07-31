defmodule Phoenix.WebComponent.FormHelper do
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
          <%= wc_text_input f, :name %>
        </label>

        <label>
          <%= wc_select f, :age, 18..100 %>
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
        <%= wc_text_input f, :for %>
        <%= wc_submit "Search" %>
      <% end %>

  `form_for/4` uses the `Plug.Conn` to set input values from the
  request parameters.

  Alternatively, if you don't have a connection, you can pass `:foo`
  as the form data source and explicitly pass the value for every input:

      <%= form_for :foo, Routes.foo_path(MyApp.Endpoint, :new), fn f -> %>
        <%= wc_text_input f, :for, value: "current value" %>
        <%= wc_submit "Search" %>
      <% end %>

  ## Without form data

  Sometimes we may want to generate a `text_input/3` or any other
  tag outside of a form. The functions in this module also support
  such usage by simply passing an atom as first argument instead
  of the form.

      <%= wc_text_input :user, :name, value: "This is a prepopulated value" %>


  """

  import Phoenix.HTML
  import Phoenix.HTML.Tag
  import Phoenix.HTML.Form, except: [options_for_select: 2]

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
      #=> <bx-input id="user_name" name="user[name]" type="text" value="" />

      wc_text_input(:user, :name)
      #=> <bx-input id="user_name" name="user[name]" type="text" value="" />

  """
  def wc_text_input(form, field, opts \\ []) do
    generic_input(:text, form, field, opts)
  end

  @doc """
  Generates an email input.

  Auto add pattern="[^@]+@[^@]+" to check format

  See `text_input/3` for example and docs.
  """
  def wc_email_input(form, field, opts \\ []) do
    opts = opts |> Keyword.put_new(:pattern, "[^@]+@[^@]+")
    generic_input(:email, form, field, opts)
  end

  @spec wc_number_input(atom | Phoenix.HTML.Form.t(), atom | binary, keyword) ::
          {:safe, [binary | list | 60 | 62, ...]}
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
      |> Keyword.put_new(:"label-text", humanize(field))
      |> Keyword.put_new(:type, "password")
      |> Keyword.put_new(:id, input_id(form, field))
      |> Keyword.put_new(:name, input_name(form, field))

    errors =
      case form do
        %{errors: errors} -> errors |> Keyword.get_values(field)
        _ -> []
      end

    {translate_error, opts} = opts |> Keyword.pop(:translate_error)

    opts =
      unless Enum.empty?(errors) do
        opts = opts |> Keyword.put_new(:invalid, true)

        errorString =
          Enum.map(errors, fn {msg, opts} ->
            if is_function(translate_error) do
              translate_error.({msg, opts})
            else
              msg
            end
          end)
          |> Enum.join(" ")

        opts |> Keyword.put(:"validity-message", errorString)
      else
        opts
      end

    tag(:"bx-input", opts)
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
    opts =
      opts
      |> Keyword.put_new(:"label-text", humanize(field))
      |> Keyword.put_new(:id, input_id(form, field))
      |> Keyword.put_new(:name, input_name(form, field))
      |> Keyword.put_new(:value, input_value(form, field))
      |> Keyword.update!(:value, &maybe_html_escape/1)
      |> Keyword.put_new(:"date-format", "Y-m-d")

    errors =
      case form do
        %{errors: errors} -> errors |> Keyword.get_values(field)
        _ -> []
      end

    {translate_error, opts} = opts |> Keyword.pop(:translate_error)

    opts =
      unless Enum.empty?(errors) do
        opts = opts |> Keyword.put_new(:invalid, true)

        errorString =
          Enum.map(errors, fn {msg, opts} ->
            if is_function(translate_error) do
              translate_error.({msg, opts})
            else
              msg
            end
          end)
          |> Enum.join(" ")

        opts |> Keyword.put(:"validity-message", errorString)
      else
        opts
      end

    {format, opts} = Keyword.pop(opts, :"date-format")
    {name, opts} = Keyword.pop(opts, :name)
    {value, opts} = Keyword.pop(opts, :value)

    content_tag(:"bx-date-picker", "date-format": format, name: name, value: value) do
      content_tag(:"bx-date-picker-input", "", opts ++ [kind: "single", value: value])
    end
  end

  defp generic_input(type, form, field, opts)
       when is_list(opts) and (is_atom(field) or is_binary(field)) do
    opts =
      opts
      |> Keyword.put_new(:"label-text", humanize(field))
      |> Keyword.put_new(:type, type)
      |> Keyword.put_new(:id, input_id(form, field))
      |> Keyword.put_new(:name, input_name(form, field))
      |> Keyword.put_new(:value, input_value(form, field))
      |> Keyword.update!(:value, &maybe_html_escape/1)

    errors =
      case form do
        %{errors: errors} -> errors |> Keyword.get_values(field)
        _ -> []
      end

    {translate_error, opts} = opts |> Keyword.pop(:translate_error)

    opts =
      unless Enum.empty?(errors) do
        opts = opts |> Keyword.put_new(:invalid, true)

        errorString =
          Enum.map(errors, fn {msg, opts} ->
            if is_function(translate_error) do
              translate_error.({msg, opts})
            else
              msg
            end
          end)
          |> Enum.join(" ")

        opts |> Keyword.put(:"validity-message", errorString)
      else
        opts
      end

    tag(:"bx-input", opts)
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
      |> Keyword.put_new(:"label-text", humanize(field))
      |> Keyword.put_new(:id, input_id(form, field))
      |> Keyword.put_new(:name, input_name(form, field))
      |> Keyword.put_new(:value, value)

    errors =
      case form do
        %{errors: errors} -> errors |> Keyword.get_values(field)
        _ -> []
      end

    {translate_error, opts} = opts |> Keyword.pop(:translate_error)

    opts =
      unless Enum.empty?(errors) do
        opts = opts |> Keyword.put_new(:invalid, true)

        errorString =
          Enum.map(errors, fn {msg, opts} ->
            if is_function(translate_error) do
              translate_error.({msg, opts})
            else
              msg
            end
          end)
          |> Enum.join(" ")

        opts |> Keyword.put(:"validity-message", errorString)
      else
        opts
      end

    content_tag(:"bx-textarea", "", opts)
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
    opts = Keyword.put_new(opts, :unelevated, true)

    content_tag(:"bx-btn", opts, block_option)
  end

  def wc_submit(value, opts) do
    opts = Keyword.put_new(opts, :type, "submit")
    opts = Keyword.put_new(opts, :unelevated, true)

    content_tag(:"bx-btn", value, opts)
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

    tag(:"bx-btn", opts)
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
      #=> <bx-select id="user_age" name="user[age]">
      #=>   <option value="0">0</option>
      #=>   ...
      #=>   <option value="120">120</option>
      #=> </bx-select>

      select(form, :role, ["Admin": "admin", "User": "user"])
      #=> <bx-select id="user_role" name="user[role]">
      #=>   <option value="admin">Admin</option>
      #=>   <option value="user">User</option>
      #=> </bx-select>

      select(form, :role, [[key: "Admin", value: "admin", disabled: true],
                           [key: "User", value: "user"]])
      #=> <bx-select id="user_role" name="user[role]">
      #=>   <option value="admin" disabled="disabled">Admin</option>
      #=>   <option value="user">User</option>
      #=> </bx-select>

  You can also pass a prompt:

      select(form, :role, ["Admin": "admin", "User": "user"], prompt: "Choose your role")
      #=> <bx-select id="user_role" name="user[role]">
      #=>   <option value="">Choose your role</option>
      #=>   <option value="admin">Admin</option>
      #=>   <option value="user">User</option>
      #=> </bx-select>

  And customize the prompt as any other entry:

      select(form, :role, ["Admin": "admin", "User": "user"], prompt: [key: "Choose your role", disabled: true])
      #=> <bx-select id="user_role" name="user[role]">
      #=>   <option value="" disabled="">Choose your role</option>
      #=>   <option value="admin">Admin</option>
      #=>   <option value="user">User</option>
      #=> </bx-select>

  If you want to select an option that comes from the database,
  such as a manager for a given project, you may write:

      select(form, :manager_id, Enum.map(@managers, &{&1.name, &1.id}))
      #=> <bx-select id="manager_id" name="project[manager_id]">
      #=>   <option value="1">Mary Jane</option>
      #=>   <option value="2">John Doe</option>
      #=> </bx-select>

  Finally, if the values are a list or a map, we use the keys for
  grouping:

      select(form, :country, ["Europe": ["UK", "Sweden", "France"]], ...)
      #=> <bx-select id="user_country" name="user[country]">
      #=>   <optgroup label="Europe">
      #=>     <option>UK</option>
      #=>     <option>Sweden</option>
      #=>     <option>France</option>
      #=>   </optgroup>
      #=>   ...
      #=> </bx-select>

  ## Options

    * `:prompt` - an option to include at the top of the options. It may be
      a string or a keyword list of attributes and the `:key`

    * `:selected` - the default value to use when none was sent as parameter

  Be aware that a `:multiple` option will not generate a correctly
  functioning multiple select element. Use `wc_multiple_select/4` instead.

  All other options are forwarded to the underlying HTML tag.
  """
  def wc_select(form, field, options, opts \\ []) when is_atom(field) or is_binary(field) do
    options_html = options_for_select(options)

    opts =
      opts
      |> Keyword.put_new(:"label-text", humanize(field))
      |> Keyword.put_new(:id, input_id(form, field))
      |> Keyword.put_new(:name, input_name(form, field))
      |> Keyword.put_new(:value, input_value(form, field))
      |> Keyword.update!(:value, &maybe_html_escape/1)

    content_tag(:"bx-select", options_html, opts)
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
  def options_for_select(options) do
    {:safe, escaped_options_for_select(options)}
  end

  defp escaped_options_for_select(options) do
    Enum.reduce(options, [], fn
      {option_key, option_value}, acc ->
        [acc | option(option_key, option_value, [])]

      options, acc when is_list(options) ->
        {option_key, options} = Keyword.pop(options, :key)

        option_key ||
          raise ArgumentError,
                "expected :key key when building <option> from keyword list: #{inspect(options)}"

        {option_value, options} = Keyword.pop(options, :value)

        option_value ||
          raise ArgumentError,
                "expected :value key when building <option> from keyword list: #{inspect(options)}"

        [acc | option(option_key, option_value, options)]

      option, acc ->
        [acc | option(option, option, [])]
    end)
  end

  defp option(group_label, group_values, [])
       when is_list(group_values) or is_map(group_values) do
    section_options = escaped_options_for_select(group_values)

    {:safe, contents} =
      content_tag(:"bx-select-item-group", {:safe, section_options}, label: group_label)

    contents
  end

  defp option(option_key, option_value, extra) do
    option_key = html_escape(option_key)
    option_value = html_escape(option_value)
    opts = [value: option_value] ++ extra
    {:safe, contents} = content_tag(:"bx-select-item", option_key, opts)
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
    opts =
      opts
      |> Keyword.put_new(:"label-text", humanize(field))
      |> Keyword.put_new(:id, input_id(form, field))
      |> Keyword.put_new(:name, input_name(form, field) <> "[]")
      |> Keyword.put_new(:value, input_value(form, field))
      |> Keyword.update!(:value, &maybe_html_escape/1)

    content_tag(:"bx-multi-select", options_for_select(options), opts)
  end

  ## Switch
  @doc ~S'''

   ## Examples

      # Assuming form contains a User schema
      wc_switch(form, :enable, [checked_value: "yes", unchecked_value: "no"])
      #=> <bx-toggle id="user_enable" name="user[enable]" value="yes" />

  ## Options

    * `:checked_value` - the value if the switch is on, Defaults to "true".
    * `:unchecked_value` - the value if the switch is off, Defaults to "false"
    * `:value` - the value of `checked_value` or `unchecked_value`.

  '''
  def wc_switch(form, field, opts \\ []) do
    opts =
      opts
      |> Keyword.put_new(:"label-text", humanize(field))
      |> Keyword.put_new(:id, input_id(form, field))
      |> Keyword.put_new(:name, input_name(form, field))
      |> Keyword.put_new(:value, input_value(form, field))
      |> Keyword.update!(:value, &maybe_html_escape/1)

    content_tag(:"gsmlg-switch", field, opts)
  end
end
