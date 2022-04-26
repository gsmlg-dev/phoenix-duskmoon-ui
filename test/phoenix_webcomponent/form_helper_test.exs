defmodule Phoenix.WebComponent.FormHelperTest do
  use ExUnit.Case, async: true

  import Phoenix.HTML
  import Phoenix.HTML.Form, except: [options_for_select: 2]
  import Phoenix.WebComponent.FormHelper
  doctest Phoenix.WebComponent.FormHelper

  @doc """
  A function that executes `form_for/4` and
  extracts its inner contents for assertion.
  """
  def safe_form(fun, opts \\ [as: :search]) do
    mark = "--PLACEHOLDER--"

    contents =
      safe_to_string(
        form_for(conn(), "/", opts, fn f ->
          html_escape([mark, fun.(f), mark])
        end)
      )

    [_, inner, _] = String.split(contents, mark)
    inner
  end

  defp conn do
    Plug.Test.conn(:get, "/foo", %{"search" => search_params()})
  end

  defp search_params do
    %{
      "key" => "value",
      "time" => ~T[01:02:03.004005],
      "datetime" => %{
        "year" => "2020",
        "month" => "4",
        "day" => "17",
        "hour" => "2",
        "minute" => "11",
        "second" => "13"
      },
      "naive_datetime" => ~N[2000-01-01 10:00:42]
    }
  end

  ## wc_text_input/3

  test "wc_text_input/3" do
    assert safe_to_string(wc_text_input(:search, :key)) ==
             ~s(<bx-input id="search_key" label-text="Key" name="search[key]" type="text">)

    assert safe_to_string(
             wc_text_input(:search, :key, value: "foo", id: "key", name: "search[key][]")
           ) ==
             ~s(<bx-input id="key" label-text="Key" name="search[key][]" type="text" value="foo">)
  end

  test "wc_text_input/3 with form" do
    assert safe_form(&wc_text_input(&1, :key)) ==
             ~s(<bx-input id="search_key" label-text="Key" name="search[key]" type="text" value="value">)

    assert safe_form(&wc_text_input(&1, :key, value: "foo", id: "key", name: "search[key][]")) ==
             ~s(<bx-input id="key" label-text="Key" name="search[key][]" type="text" value="foo">)
  end

  test "wc_text_input/3 with form and data" do
    assert safe_form(&wc_text_input(put_in(&1.data[:key], "original"), :key)) ==
             ~s(<bx-input id="search_key" label-text="Key" name="search[key]" type="text" value="value">)

    assert safe_form(&wc_text_input(put_in(&1.data[:no_key], "original"), :no_key)) ==
             ~s(<bx-input id="search_no_key" label-text="No key" name="search[no_key]" type="text" value="original">)
  end

  ## wc_textarea/3

  test "wc_textarea/3" do
    assert safe_to_string(wc_textarea(:search, :key)) ==
             ~s(<bx-textarea id="search_key" label-text="Key" name="search[key]"></bx-textarea>)

    assert safe_to_string(wc_textarea(:search, :key)) ==
             ~s(<bx-textarea id="search_key" label-text="Key" name="search[key]"></bx-textarea>)

    assert safe_to_string(wc_textarea(:search, :key, id: "key", name: "search[key][]")) ==
             ~s(<bx-textarea id="key" label-text="Key" name="search[key][]"></bx-textarea>)
  end

  test "wc_textarea/3 with form" do
    assert safe_form(&wc_textarea(&1, :key)) ==
             ~s(<bx-textarea id="search_key" label-text="Key" name="search[key]" value="value"></bx-textarea>)

    assert safe_form(&wc_textarea(&1, :key, value: "foo", id: "key", name: "search[key][]")) ==
             ~s(<bx-textarea id="key" label-text="Key" name="search[key][]" value="foo"></bx-textarea>)
  end

  test "cw_textarea/3 with non-binary type" do
    assert safe_form(&wc_textarea(&1, :key, value: :atom_value)) ==
             ~s(<bx-textarea id="search_key" label-text="Key" name="search[key]" value="atom_value"></bx-textarea>)
  end

  ## wc_number_input/3

  test "wc_number_input/3" do
    assert safe_to_string(wc_number_input(:search, :key)) ==
             ~s(<bx-input id="search_key" label-text="Key" name="search[key]" type="number">)

    assert safe_to_string(
             wc_number_input(:search, :key, value: "foo", id: "key", name: "search[key][]")
           ) ==
             ~s(<bx-input id="key" label-text="Key" name="search[key][]" type="number" value="foo">)
  end

  test "wc_number_input/3 with form" do
    assert safe_form(&wc_number_input(&1, :key)) ==
             ~s(<bx-input id="search_key" label-text="Key" name="search[key]" type="number" value="value">)

    assert safe_form(&wc_number_input(&1, :key, value: "foo", id: "key", name: "search[key][]")) ==
             ~s(<bx-input id="key" label-text="Key" name="search[key][]" type="number" value="foo">)
  end

  ## wc_email_input/3

  test "wc_email_input/3" do
    assert safe_to_string(wc_email_input(:search, :key)) ==
             ~s(<bx-input id="search_key" label-text="Key" name="search[key]" pattern="[^@]+@[^@]+" type="email">)

    assert safe_to_string(
             wc_email_input(:search, :key, value: "foo", id: "key", name: "search[key][]")
           ) ==
             ~s(<bx-input id="key" label-text="Key" name="search[key][]" pattern="[^@]+@[^@]+" type="email" value="foo">)
  end

  test "wc_email_input/3 with form" do
    assert safe_form(&wc_email_input(&1, :key)) ==
             ~s(<bx-input id="search_key" label-text="Key" name="search[key]" pattern="[^@]+@[^@]+" type="email" value="value">)

    assert safe_form(&wc_email_input(&1, :key, value: "foo", id: "key", name: "search[key][]")) ==
             ~s(<bx-input id="key" label-text="Key" name="search[key][]" pattern="[^@]+@[^@]+" type="email" value="foo">)
  end

  ## wc_password_input/3

  test "wc_password_input/3" do
    assert safe_to_string(wc_password_input(:search, :key)) ==
             ~s(<bx-input id="search_key" label-text="Key" name="search[key]" type="password">)

    assert safe_to_string(
             wc_password_input(:search, :key, value: "foo", id: "key", name: "search[key][]")
           ) ==
             ~s(<bx-input id="key" label-text="Key" name="search[key][]" type="password" value="foo">)
  end

  test "wc_password_input/3 with form" do
    assert safe_form(&wc_password_input(&1, :key)) ==
             ~s(<bx-input id="search_key" label-text="Key" name="search[key]" type="password">)

    assert safe_form(&wc_password_input(&1, :key, value: "foo", id: "key", name: "search[key][]")) ==
             ~s(<bx-input id="key" label-text="Key" name="search[key][]" type="password" value="foo">)
  end

  ## wc_file_input/3

  test "wc_file_input/3" do
    assert safe_to_string(wc_file_input(:search, :key)) ==
             ~s(<input id="search_key" name="search[key]" type="file">)

    assert safe_to_string(wc_file_input(:search, :key, id: "key", name: "search[key][]")) ==
             ~s(<input id="key" name="search[key][]" type="file">)

    assert safe_to_string(wc_file_input(:search, :key, multiple: true)) ==
             ~s(<input id="search_key" multiple name="search[key][]" type="file">)
  end

  test "wc_file_input/3 with form" do
    assert_raise ArgumentError, fn ->
      safe_form(&wc_file_input(&1, :key))
    end

    assert safe_form(&wc_file_input(&1, :key), multipart: true, as: :search) ==
             ~s(<input id="search_key" name="search[key]" type="file">)
  end

  ## wc_url_input/3

  test "wc_url_input/3" do
    assert safe_to_string(wc_url_input(:search, :key)) ==
             ~s(<bx-input id="search_key" label-text="Key" name="search[key]" type="url">)

    assert safe_to_string(
             wc_url_input(:search, :key, value: "foo", id: "key", name: "search[key][]")
           ) ==
             ~s(<bx-input id="key" label-text="Key" name="search[key][]" type="url" value="foo">)
  end

  test "wc_url_input/3 with form" do
    assert safe_form(&wc_url_input(&1, :key)) ==
             ~s(<bx-input id="search_key" label-text="Key" name="search[key]" type="url" value="value">)

    assert safe_form(&wc_url_input(&1, :key, value: "foo", id: "key", name: "search[key][]")) ==
             ~s(<bx-input id="key" label-text="Key" name="search[key][]" type="url" value="foo">)
  end

  ## wc_search_input/3

  test "wc_search_input/3" do
    assert safe_to_string(wc_search_input(:search, :key)) ==
             ~s(<bx-input id="search_key" label-text="Key" name="search[key]" type="search">)

    assert safe_to_string(
             wc_search_input(:search, :key, value: "foo", id: "key", name: "search[key][]")
           ) ==
             ~s(<bx-input id="key" label-text="Key" name="search[key][]" type="search" value="foo">)
  end

  test "wc_search_input/3 with form" do
    assert safe_form(&wc_search_input(&1, :key)) ==
             ~s(<bx-input id="search_key" label-text="Key" name="search[key]" type="search" value="value">)

    assert safe_form(&wc_search_input(&1, :key, value: "foo", id: "key", name: "search[key][]")) ==
             ~s(<bx-input id="key" label-text="Key" name="search[key][]" type="search" value="foo">)
  end

  ## wc_color_input/3

  test "wc_color_input/3" do
    assert safe_to_string(wc_color_input(:search, :key)) ==
             ~s(<bx-input id="search_key" label-text="Key" name="search[key]" type="color">)

    assert safe_to_string(
             wc_color_input(:search, :key, value: "#123456", id: "key", name: "search[key][]")
           ) ==
             ~s(<bx-input id="key" label-text="Key" name="search[key][]" type="color" value="#123456">)
  end

  test "wc_color_input/3 with form" do
    assert safe_form(&wc_color_input(&1, :key)) ==
             ~s(<bx-input id="search_key" label-text="Key" name="search[key]" type="color" value="value">)

    assert safe_form(&wc_color_input(&1, :key, value: "foo", id: "key", name: "search[key][]")) ==
             ~s(<bx-input id="key" label-text="Key" name="search[key][]" type="color" value="foo">)
  end

  ## wc_telephone_input/3

  test "wc_telephone_input/3" do
    assert safe_to_string(wc_telephone_input(:search, :key)) ==
             ~s(<bx-input id="search_key" label-text="Key" name="search[key]" type="tel">)

    assert safe_to_string(
             wc_telephone_input(:search, :key, value: "foo", id: "key", name: "search[key][]")
           ) ==
             ~s(<bx-input id="key" label-text="Key" name="search[key][]" type="tel" value="foo">)
  end

  test "wc_telephone_input/3 with form" do
    assert safe_form(&wc_telephone_input(&1, :key)) ==
             ~s(<bx-input id="search_key" label-text="Key" name="search[key]" type="tel" value="value">)

    assert safe_form(
             &wc_telephone_input(&1, :key, value: "foo", id: "key", name: "search[key][]")
           ) ==
             ~s(<bx-input id="key" label-text="Key" name="search[key][]" type="tel" value="foo">)
  end

  ## wc_range_input/3

  test "wc_range_input/3" do
    assert safe_to_string(wc_range_input(:search, :key)) ==
             ~s(<bx-input id="search_key" label-text="Key" name="search[key]" type="range">)

    assert safe_to_string(
             wc_range_input(:search, :key, value: "foo", id: "key", name: "search[key][]")
           ) ==
             ~s(<bx-input id="key" label-text="Key" name="search[key][]" type="range" value="foo">)
  end

  test "wc_range_input/3 with form" do
    assert safe_form(&wc_range_input(&1, :key)) ==
             ~s(<bx-input id="search_key" label-text="Key" name="search[key]" type="range" value="value">)

    assert safe_form(&wc_range_input(&1, :key, value: "foo", id: "key", name: "search[key][]")) ==
             ~s(<bx-input id="key" label-text="Key" name="search[key][]" type="range" value="foo">)
  end

  ## wc_date_input/3

  test "wc_date_input/3" do
    assert safe_to_string(wc_date_input(:search, :key)) ==
             ~s(<bx-date-picker date-format="Y-m-d" name="search[key]"><bx-date-picker-input id="search_key" kind="single" label-text="Key"></bx-date-picker-input></bx-date-picker>)

    assert safe_to_string(
             wc_date_input(:search, :key, value: "foo", id: "key", name: "search[key]")
           ) ==
             ~s(<bx-date-picker date-format="Y-m-d" name="search[key]" value="foo"><bx-date-picker-input id="key" kind="single" label-text="Key" value="foo"></bx-date-picker-input></bx-date-picker>)

    assert safe_to_string(
             wc_date_input(:search, :key, value: ~D[2017-09-21], id: "key", name: "search[key]")
           ) ==
             ~s(<bx-date-picker date-format="Y-m-d" name="search[key]" value="2017-09-21"><bx-date-picker-input id="key" kind="single" label-text="Key" value="2017-09-21"></bx-date-picker-input></bx-date-picker>)
  end

  test "wc_date_input/3 with form" do
    assert safe_form(&wc_date_input(&1, :key)) ==
             ~s(<bx-date-picker date-format="Y-m-d" name="search[key]" value="value"><bx-date-picker-input id="search_key" kind="single" label-text="Key" value="value"></bx-date-picker-input></bx-date-picker>)

    assert safe_form(&wc_date_input(&1, :key, value: "foo", id: "key", name: "search[key]")) ==
             ~s(<bx-date-picker date-format="Y-m-d" name="search[key]" value="foo"><bx-date-picker-input id="key" kind="single" label-text="Key" value="foo"></bx-date-picker-input></bx-date-picker>)

    assert safe_form(
             &wc_date_input(&1, :key, value: ~D[2017-09-21], id: "key", name: "search[key]")
           ) ==
             ~s(<bx-date-picker date-format="Y-m-d" name="search[key]" value="2017-09-21"><bx-date-picker-input id="key" kind="single" label-text="Key" value="2017-09-21"></bx-date-picker-input></bx-date-picker>)
  end

  ## wc_submit/2

  test "wc_submit/2" do
    assert safe_to_string(wc_submit("Submit")) ==
             ~s(<mwc-button type="submit" unelevated>Submit</mwc-button>)

    assert safe_to_string(wc_submit("Submit", class: "btn")) ==
             ~s(<mwc-button class="btn" type="submit" unelevated>Submit</mwc-button>)

    assert safe_to_string(wc_submit([class: "btn"], do: "Submit")) ==
             ~s(<mwc-button class="btn" type="submit" unelevated>Submit</mwc-button>)

    assert safe_to_string(wc_submit(do: "Submit")) ==
             ~s(<mwc-button type="submit" unelevated>Submit</mwc-button>)

    assert safe_to_string(wc_submit("<Submit>")) ==
             ~s(<mwc-button type="submit" unelevated>&lt;Submit&gt;</mwc-button>)

    assert safe_to_string(wc_submit("<Submit>", class: "btn")) ==
             ~s(<mwc-button class="btn" type="submit" unelevated>&lt;Submit&gt;</mwc-button>)

    assert safe_to_string(wc_submit([class: "btn"], do: "<Submit>")) ==
             ~s(<mwc-button class="btn" type="submit" unelevated>&lt;Submit&gt;</mwc-button>)

    assert safe_to_string(wc_submit(do: "<Submit>")) ==
             ~s(<mwc-button type="submit" unelevated>&lt;Submit&gt;</mwc-button>)
  end

  ## wc_reset/2

  test "wc_reset/2" do
    assert safe_to_string(wc_reset("Reset")) == ~s(<mwc-button type="reset" value="Reset">)

    assert safe_to_string(wc_reset("Reset", class: "btn")) ==
             ~s(<mwc-button class="btn" type="reset" value="Reset">)
  end

  ## wc_radio_button/4

  test "wc_radio_button/4" do
    assert safe_to_string(wc_radio_button(:search, :key, "admin")) ==
             ~s(<input id="search_key_admin" name="search[key]" type="radio" value="admin">)

    assert safe_to_string(wc_radio_button(:search, :key, "admin", checked: true)) ==
             ~s(<input checked id="search_key_admin" name="search[key]" type="radio" value="admin">)

    assert safe_to_string(wc_radio_button(:search, :key, "value with spaces")) ==
             ~s(<input id="search_key_value_with_spaces" name="search[key]" type="radio" value="value with spaces">)

    assert safe_to_string(wc_radio_button(:search, :key, "F✓o]o%b+a'R")) ==
             ~s(<input id="search_key_F_o_o_b_a__39_R" name="search[key]" type="radio" value="F✓o]o%b+a&#39;R">)
  end

  test "wc_radio_button/4 with form" do
    assert safe_form(&wc_radio_button(&1, :key, :admin)) ==
             ~s(<input id="search_key_admin" name="search[key]" type="radio" value="admin">)

    assert safe_form(&wc_radio_button(&1, :key, :value)) ==
             ~s(<input checked id="search_key_value" name="search[key]" type="radio" value="value">)

    assert safe_form(&wc_radio_button(&1, :key, :value, checked: false)) ==
             ~s(<input id="search_key_value" name="search[key]" type="radio" value="value">)
  end

  ## wc_checkbox/3

  test "wc_checkbox/3" do
    assert safe_to_string(wc_checkbox(:search, :key)) ==
             ~s(<input name="search[key]" type="hidden" value="false">) <>
               ~s(<input id="search_key" name="search[key]" type="checkbox" value="true">)

    assert safe_to_string(wc_checkbox(:search, :key, value: "true")) ==
             ~s(<input name="search[key]" type="hidden" value="false">) <>
               ~s(<input checked id="search_key" name="search[key]" type="checkbox" value="true">)

    assert safe_to_string(wc_checkbox(:search, :key, checked: true)) ==
             ~s(<input name="search[key]" type="hidden" value="false">) <>
               ~s(<input checked id="search_key" name="search[key]" type="checkbox" value="true">)

    assert safe_to_string(wc_checkbox(:search, :key, checked: true, disabled: true)) ==
             ~s(<input disabled name="search[key]" type="hidden" value="false">) <>
               ~s(<input checked disabled id="search_key" name="search[key]" type="checkbox" value="true">)

    assert safe_to_string(wc_checkbox(:search, :key, value: "true", checked: false)) ==
             ~s(<input name="search[key]" type="hidden" value="false">) <>
               ~s(<input id="search_key" name="search[key]" type="checkbox" value="true">)

    assert safe_to_string(
             wc_checkbox(:search, :key, value: 0, checked_value: 1, unchecked_value: 0)
           ) ==
             ~s(<input name="search[key]" type="hidden" value="0">) <>
               ~s(<input id="search_key" name="search[key]" type="checkbox" value="1">)

    assert safe_to_string(
             wc_checkbox(:search, :key, value: 1, checked_value: 1, unchecked_value: 0)
           ) ==
             ~s(<input name="search[key]" type="hidden" value="0">) <>
               ~s(<input checked id="search_key" name="search[key]" type="checkbox" value="1">)

    assert safe_to_string(wc_checkbox(:search, :key, value: 1, hidden_input: false)) ==
             ~s(<input id="search_key" name="search[key]" type="checkbox" value="true">)

    # Mimick a field of type {:array, Ecto.Enum}, for which `field_value` returns an array of atoms:
    assert safe_to_string(
             wc_checkbox(:search, :key,
               name: "search[key][]",
               value: [:a, :b],
               checked_value: "c",
               checked: false,
               hidden_input: false
             )
           ) ==
             ~s(<input id="search_key" name="search[key][]" type="checkbox" value="c">)
  end

  test "wc_checkbox/3 with form" do
    assert safe_form(&wc_checkbox(&1, :key)) ==
             ~s(<input name="search[key]" type="hidden" value="false">) <>
               ~s(<input id="search_key" name="search[key]" type="checkbox" value="true">)

    assert safe_form(&wc_checkbox(&1, :key, value: true)) ==
             ~s(<input name="search[key]" type="hidden" value="false">) <>
               ~s(<input checked id="search_key" name="search[key]" type="checkbox" value="true">)

    assert safe_form(&wc_checkbox(&1, :key, checked_value: :value, unchecked_value: :novalue)) ==
             ~s(<input name="search[key]" type="hidden" value="novalue">) <>
               ~s(<input checked id="search_key" name="search[key]" type="checkbox" value="value">)
  end

  # wc_switch/3

  test "wc_switch/3" do
    assert safe_to_string(wc_switch(:form, :enable)) ==
             ~s(<mwc-formfield label="Enable"><mwc-switch id="form_enable" name="form[enable]" value="on">enable</mwc-switch></mwc-formfield>)

    assert safe_to_string(wc_switch(:form, :enable, true_value: "yes")) ==
             ~s(<mwc-formfield label="Enable"><mwc-switch id="form_enable" name="form[enable]" value="yes">enable</mwc-switch></mwc-formfield>)

    assert safe_to_string(wc_switch(:form, :enable, selected: true, true_value: "true")) ==
             ~s(<mwc-formfield label="Enable"><mwc-switch id="form_enable" name="form[enable]" selected value="true">enable</mwc-switch></mwc-formfield>)
  end
end
