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
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="text">)

    assert safe_to_string(
             wc_text_input(:search, :key, value: "foo", id: "key", name: "search[key][]")
           ) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="text" value="foo">)
  end

  test "wc_text_input/3 with form" do
    assert safe_form(&wc_text_input(&1, :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="text" value="value">)

    assert safe_form(&wc_text_input(&1, :key, value: "foo", id: "key", name: "search[key][]")) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="text" value="foo">)
  end

  test "wc_text_input/3 with form and data" do
    assert safe_form(&wc_text_input(put_in(&1.data[:key], "original"), :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="text" value="value">)

    assert safe_form(&wc_text_input(put_in(&1.data[:no_key], "original"), :no_key)) ==
             ~s(<mwc-textfield id="search_no_key" label="No key" name="search[no_key]" type="text" value="original">)
  end

  ## wc_textarea/3

  test "wc_textarea/3" do
    assert safe_to_string(wc_textarea(:search, :key)) ==
             ~s(<mwc-textarea id="search_key" label="Key" name="search[key]"></mwc-textarea>)

    assert safe_to_string(wc_textarea(:search, :key)) ==
             ~s(<mwc-textarea id="search_key" label="Key" name="search[key]"></mwc-textarea>)

    assert safe_to_string(wc_textarea(:search, :key, id: "key", name: "search[key][]")) ==
             ~s(<mwc-textarea id="key" label="Key" name="search[key][]"></mwc-textarea>)
  end

  test "wc_textarea/3 with form" do
    assert safe_form(&wc_textarea(&1, :key)) ==
             ~s(<mwc-textarea id="search_key" label="Key" name="search[key]" value="value"></mwc-textarea>)

    assert safe_form(&wc_textarea(&1, :key, value: "foo", id: "key", name: "search[key][]")) ==
             ~s(<mwc-textarea id="key" label="Key" name="search[key][]" value="foo"></mwc-textarea>)
  end

  test "cw_textarea/3 with non-binary type" do
    assert safe_form(&wc_textarea(&1, :key, value: :atom_value)) ==
             ~s(<mwc-textarea id="search_key" label="Key" name="search[key]" value="atom_value"></mwc-textarea>)
  end

  ## wc_number_input/3

  test "wc_number_input/3" do
    assert safe_to_string(wc_number_input(:search, :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="number">)

    assert safe_to_string(
             wc_number_input(:search, :key, value: "foo", id: "key", name: "search[key][]")
           ) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="number" value="foo">)
  end

  test "wc_number_input/3 with form" do
    assert safe_form(&wc_number_input(&1, :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="number" value="value">)

    assert safe_form(&wc_number_input(&1, :key, value: "foo", id: "key", name: "search[key][]")) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="number" value="foo">)
  end

  ## wc_email_input/3

  test "wc_email_input/3" do
    assert safe_to_string(wc_email_input(:search, :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="email">)

    assert safe_to_string(
             wc_email_input(:search, :key, value: "foo", id: "key", name: "search[key][]")
           ) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="email" value="foo">)
  end

  test "wc_email_input/3 with form" do
    assert safe_form(&wc_email_input(&1, :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="email" value="value">)

    assert safe_form(&wc_email_input(&1, :key, value: "foo", id: "key", name: "search[key][]")) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="email" value="foo">)
  end

  ## wc_password_input/3

  test "wc_password_input/3" do
    assert safe_to_string(wc_password_input(:search, :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="password">)

    assert safe_to_string(
             wc_password_input(:search, :key, value: "foo", id: "key", name: "search[key][]")
           ) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="password" value="foo">)
  end

  test "wc_password_input/3 with form" do
    assert safe_form(&wc_password_input(&1, :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="password">)

    assert safe_form(&wc_password_input(&1, :key, value: "foo", id: "key", name: "search[key][]")) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="password" value="foo">)
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
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="url">)

    assert safe_to_string(
             wc_url_input(:search, :key, value: "foo", id: "key", name: "search[key][]")
           ) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="url" value="foo">)
  end

  test "wc_url_input/3 with form" do
    assert safe_form(&wc_url_input(&1, :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="url" value="value">)

    assert safe_form(&wc_url_input(&1, :key, value: "foo", id: "key", name: "search[key][]")) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="url" value="foo">)
  end

  ## wc_search_input/3

  test "wc_search_input/3" do
    assert safe_to_string(wc_search_input(:search, :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="search">)

    assert safe_to_string(
             wc_search_input(:search, :key, value: "foo", id: "key", name: "search[key][]")
           ) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="search" value="foo">)
  end

  test "wc_search_input/3 with form" do
    assert safe_form(&wc_search_input(&1, :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="search" value="value">)

    assert safe_form(&wc_search_input(&1, :key, value: "foo", id: "key", name: "search[key][]")) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="search" value="foo">)
  end

  ## wc_color_input/3

  test "wc_color_input/3" do
    assert safe_to_string(wc_color_input(:search, :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="color">)

    assert safe_to_string(
             wc_color_input(:search, :key, value: "#123456", id: "key", name: "search[key][]")
           ) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="color" value="#123456">)
  end

  test "wc_color_input/3 with form" do
    assert safe_form(&wc_color_input(&1, :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="color" value="value">)

    assert safe_form(&wc_color_input(&1, :key, value: "foo", id: "key", name: "search[key][]")) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="color" value="foo">)
  end

  ## wc_telephone_input/3

  test "wc_telephone_input/3" do
    assert safe_to_string(wc_telephone_input(:search, :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="tel">)

    assert safe_to_string(
             wc_telephone_input(:search, :key, value: "foo", id: "key", name: "search[key][]")
           ) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="tel" value="foo">)
  end

  test "wc_telephone_input/3 with form" do
    assert safe_form(&wc_telephone_input(&1, :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="tel" value="value">)

    assert safe_form(
             &wc_telephone_input(&1, :key, value: "foo", id: "key", name: "search[key][]")
           ) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="tel" value="foo">)
  end

  ## wc_range_input/3

  test "wc_range_input/3" do
    assert safe_to_string(wc_range_input(:search, :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="range">)

    assert safe_to_string(
             wc_range_input(:search, :key, value: "foo", id: "key", name: "search[key][]")
           ) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="range" value="foo">)
  end

  test "wc_range_input/3 with form" do
    assert safe_form(&wc_range_input(&1, :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="range" value="value">)

    assert safe_form(&wc_range_input(&1, :key, value: "foo", id: "key", name: "search[key][]")) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="range" value="foo">)
  end

  ## wc_date_input/3

  test "wc_date_input/3" do
    assert safe_to_string(wc_date_input(:search, :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="date">)

    assert safe_to_string(
             wc_date_input(:search, :key, value: "foo", id: "key", name: "search[key][]")
           ) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="date" value="foo">)

    assert safe_to_string(
             wc_date_input(:search, :key, value: ~D[2017-09-21], id: "key", name: "search[key][]")
           ) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="date" value="2017-09-21">)
  end

  test "wc_date_input/3 with form" do
    assert safe_form(&wc_date_input(&1, :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="date" value="value">)

    assert safe_form(&wc_date_input(&1, :key, value: "foo", id: "key", name: "search[key][]")) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="date" value="foo">)

    assert safe_form(
             &wc_date_input(&1, :key, value: ~D[2017-09-21], id: "key", name: "search[key][]")
           ) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="date" value="2017-09-21">)
  end

  ## wc_datewc_time_input/3

  test "wc_datetime_local_input/3" do
    assert safe_to_string(wc_datetime_local_input(:search, :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="datetime-local">)

    assert safe_form(&wc_datetime_local_input(&1, :naive_datetime)) ==
             ~s(<mwc-textfield id="search_naive_datetime" label="Naive datetime" name="search[naive_datetime]" type="datetime-local" value="2000-01-01T10:00">)

    assert safe_to_string(
             wc_datetime_local_input(:search, :key, value: "foo", id: "key", name: "search[key][]")
           ) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="datetime-local" value="foo">)

    assert safe_to_string(
             wc_datetime_local_input(
               :search,
               :key,
               value: ~N[2017-09-21 20:21:53],
               id: "key",
               name: "search[key][]"
             )
           ) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="datetime-local" value="2017-09-21T20:21">)
  end

  test "wc_datetime_local_input/3 with %DateTime{}" do
    assert safe_to_string(
             wc_datetime_local_input(
               :search,
               :key,
               value: DateTime.from_naive!(~N[2021-05-13 04:20:20.836851], "Etc/UTC"),
               id: "key",
               name: "search[key][]"
             )
           ) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="datetime-local" value="2021-05-13T04:20">)
  end

  test "wc_datetime_local_input/3 with form" do
    assert safe_form(&wc_datetime_local_input(&1, :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="datetime-local" value="value">)

    assert safe_form(
             &wc_datetime_local_input(&1, :key, value: "foo", id: "key", name: "search[key][]")
           ) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="datetime-local" value="foo">)

    assert safe_form(
             &wc_datetime_local_input(
               &1,
               :key,
               value: ~N[2017-09-21 20:21:53],
               id: "key",
               name: "search[key][]"
             )
           ) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="datetime-local" value="2017-09-21T20:21">)
  end

  ## wc_time_input/3

  test "wc_time_input/3" do
    assert safe_to_string(wc_time_input(:search, :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="time">)

    assert safe_to_string(
             wc_time_input(:search, :key, value: "foo", id: "key", name: "search[key][]")
           ) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="time" value="foo">)

    assert safe_to_string(
             wc_time_input(:search, :key,
               value: ~T[23:00:07.001],
               id: "key",
               name: "search[key][]"
             )
           ) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="time" value="23:00">)
  end

  test "wc_time_input/3 with form" do
    assert safe_form(&wc_time_input(&1, :key)) ==
             ~s(<mwc-textfield id="search_key" label="Key" name="search[key]" type="time" value="value">)

    assert safe_form(&wc_time_input(&1, :time)) ==
             ~s(<mwc-textfield id="search_time" label="Time" name="search[time]" type="time" value="01:02">)

    assert safe_form(&wc_time_input(&1, :time, precision: :second)) ==
             ~s(<mwc-textfield id="search_time" label="Time" name="search[time]" type="time" value="01:02:03">)

    assert safe_form(&wc_time_input(&1, :time, precision: :millisecond)) ==
             ~s(<mwc-textfield id="search_time" label="Time" name="search[time]" type="time" value="01:02:03.004">)

    assert safe_form(&wc_time_input(&1, :key, value: "foo", id: "key", name: "search[key][]")) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="time" value="foo">)

    assert safe_form(
             &wc_time_input(&1, :key, value: ~T[23:00:07.001], id: "key", name: "search[key][]")
           ) ==
             ~s(<mwc-textfield id="key" label="Key" name="search[key][]" type="time" value="23:00">)
  end

  ## wc_submit/2

  test "wc_submit/2" do
    assert safe_to_string(wc_submit("Submit")) ==
             ~s(<mwc-button type="submit">Submit</mwc-button>)

    assert safe_to_string(wc_submit("Submit", class: "btn")) ==
             ~s(<mwc-button class="btn" type="submit">Submit</mwc-button>)

    assert safe_to_string(wc_submit([class: "btn"], do: "Submit")) ==
             ~s(<mwc-button class="btn" type="submit">Submit</mwc-button>)

    assert safe_to_string(wc_submit(do: "Submit")) ==
             ~s(<mwc-button type="submit">Submit</mwc-button>)

    assert safe_to_string(wc_submit("<Submit>")) ==
             ~s(<mwc-button type="submit">&lt;Submit&gt;</mwc-button>)

    assert safe_to_string(wc_submit("<Submit>", class: "btn")) ==
             ~s(<mwc-button class="btn" type="submit">&lt;Submit&gt;</mwc-button>)

    assert safe_to_string(wc_submit([class: "btn"], do: "<Submit>")) ==
             ~s(<mwc-button class="btn" type="submit">&lt;Submit&gt;</mwc-button>)

    assert safe_to_string(wc_submit(do: "<Submit>")) ==
             ~s(<mwc-button type="submit">&lt;Submit&gt;</mwc-button>)
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

  # wc_select/4

  test "wc_select/4" do
    assert safe_to_string(wc_select(:search, :key, ~w(foo bar))) ==
             ~s(<mwc-select id="search_key" name="search[key]">) <>
               ~s(<option value="foo">foo</option>) <>
               ~s(<option value="bar">bar</option>) <> ~s(</mwc-select>)

    assert safe_to_string(wc_select(:search, :key, Foo: "foo", Bar: "bar")) ==
             ~s(<mwc-select id="search_key" name="search[key]">) <>
               ~s(<option value="foo">Foo</option>) <>
               ~s(<option value="bar">Bar</option>) <> ~s(</mwc-select>)

    assert safe_to_string(
             wc_select(:search, :key, [
               [key: "Foo", value: "foo"],
               [key: "Bar", value: "bar", disabled: true]
             ])
           ) ==
             ~s(<mwc-select id="search_key" name="search[key]">) <>
               ~s(<option value="foo">Foo</option>) <>
               ~s(<option disabled value="bar">Bar</option>) <> ~s(</mwc-select>)

    assert safe_to_string(
             wc_select(:search, :key, [Foo: "foo", Bar: "bar"], prompt: "Choose your destiny")
           ) ==
             ~s(<mwc-select id="search_key" name="search[key]">) <>
               ~s(<option value="">Choose your destiny</option>) <>
               ~s(<option value="foo">Foo</option>) <>
               ~s(<option value="bar">Bar</option>) <> ~s(</mwc-select>)

    assert safe_to_string(
             wc_select(:search, :key, [Foo: "foo", Bar: "bar"],
               prompt: [key: "Choose your destiny", disabled: true]
             )
           ) ==
             ~s(<mwc-select id="search_key" name="search[key]">) <>
               ~s(<option disabled value="">Choose your destiny</option>) <>
               ~s(<option value="foo">Foo</option>) <>
               ~s(<option value="bar">Bar</option>) <> ~s(</mwc-select>)

    assert_raise ArgumentError, fn ->
      wc_select(:search, :key, [Foo: "foo", Bar: "bar"], prompt: [])
    end

    assert safe_to_string(wc_select(:search, :key, ~w(foo bar), value: "foo")) =~
             ~s(<option selected value="foo">foo</option>)

    assert safe_to_string(wc_select(:search, :key, ~w(foo bar), selected: "foo")) =~
             ~s(<option selected value="foo">foo</option>)
  end

  test "wc_select/4 with form" do
    assert safe_form(&wc_select(&1, :key, ~w(value novalue), selected: "novalue")) ==
             ~s(<mwc-select id="search_key" name="search[key]">) <>
               ~s(<option selected value="value">value</option>) <>
               ~s(<option value="novalue">novalue</option>) <> ~s(</mwc-select>)

    assert safe_form(&wc_select(&1, :other, ~w(value novalue), selected: "novalue")) ==
             ~s(<mwc-select id="search_other" name="search[other]">) <>
               ~s(<option value="value">value</option>) <>
               ~s(<option selected value="novalue">novalue</option>) <> ~s(</mwc-select>)

    assert safe_form(
             &wc_select(
               &1,
               :key,
               [
                 [value: "value", key: "Value", disabled: true],
                 [value: "novalue", key: "No Value"]
               ],
               selected: "novalue"
             )
           ) ==
             ~s(<mwc-select id="search_key" name="search[key]">) <>
               ~s(<option disabled selected value="value">Value</option>) <>
               ~s(<option value="novalue">No Value</option>) <> ~s(</mwc-select>)

    assert safe_form(
             &wc_select(
               put_in(&1.data[:other], "value"),
               :other,
               ~w(value novalue),
               selected: "novalue"
             )
           ) ==
             ~s(<mwc-select id="search_other" name="search[other]">) <>
               ~s(<option value="value">value</option>) <>
               ~s(<option selected value="novalue">novalue</option>) <> ~s(</mwc-select>)

    assert safe_form(&wc_select(&1, :key, ~w(value novalue), value: "novalue")) ==
             ~s(<mwc-select id="search_key" name="search[key]">) <>
               ~s(<option value="value">value</option>) <>
               ~s(<option selected value="novalue">novalue</option>) <> ~s(</mwc-select>)
  end

  test "select/4 with groups" do
    assert safe_form(
             &wc_select(&1, :key, [{"foo", ~w(bar baz)}, {"qux", ~w(qux quz)}], value: "qux")
           ) ==
             ~s(<mwc-select id="search_key" name="search[key]">) <>
               ~s(<optgroup label="foo">) <>
               ~s(<option value="bar">bar</option>) <>
               ~s(<option value="baz">baz</option>) <>
               ~s(</optgroup>) <>
               ~s(<optgroup label="qux">) <>
               ~s(<option selected value="qux">qux</option>) <>
               ~s(<option value="quz">quz</option>) <> ~s(</optgroup>) <> ~s(</mwc-select>)

    assert safe_form(
             &wc_select(
               &1,
               :key,
               [foo: [{"1", "One"}, {"2", "Two"}], qux: ~w(qux quz)],
               value: "qux"
             )
           ) ==
             ~s(<mwc-select id="search_key" name="search[key]">) <>
               ~s(<optgroup label="foo">) <>
               ~s(<option value="One">1</option>) <>
               ~s(<option value="Two">2</option>) <>
               ~s(</optgroup>) <>
               ~s(<optgroup label="qux">) <>
               ~s(<option selected value="qux">qux</option>) <>
               ~s(<option value="quz">quz</option>) <> ~s(</optgroup>) <> ~s(</mwc-select>)

    assert safe_form(
             &wc_select(
               &1,
               :key,
               %{"foo" => %{"1" => "One", "2" => "Two"}, "qux" => ~w(qux quz)},
               value: "qux"
             )
           ) ==
             ~s(<mwc-select id="search_key" name="search[key]">) <>
               ~s(<optgroup label="foo">) <>
               ~s(<option value="One">1</option>) <>
               ~s(<option value="Two">2</option>) <>
               ~s(</optgroup>) <>
               ~s(<optgroup label="qux">) <>
               ~s(<option selected value="qux">qux</option>) <>
               ~s(<option value="quz">quz</option>) <> ~s(</optgroup>) <> ~s(</mwc-select>)

    assert safe_form(
             &wc_select(
               &1,
               :key,
               %{"foo" => [{"1", "One"}, {"2", "Two"}], "qux" => ~w(qux quz)},
               value: "qux"
             )
           ) ==
             ~s(<mwc-select id="search_key" name="search[key]">) <>
               ~s(<optgroup label="foo">) <>
               ~s(<option value="One">1</option>) <>
               ~s(<option value="Two">2</option>) <>
               ~s(</optgroup>) <>
               ~s(<optgroup label="qux">) <>
               ~s(<option selected value="qux">qux</option>) <>
               ~s(<option value="quz">quz</option>) <> ~s(</optgroup>) <> ~s(</mwc-select>)
  end

  # wc_multiple_select/4

  test "wc_multiple_select/4" do
    assert safe_to_string(wc_multiple_select(:search, :key, ~w(foo bar))) ==
             ~s(<select id="search_key" multiple="" name="search[key][]">) <>
               ~s(<option value="foo">foo</option>) <>
               ~s(<option value="bar">bar</option>) <> ~s(</select>)

    assert safe_to_string(wc_multiple_select(:search, :key, [{"foo", 1}, {"bar", 2}])) ==
             ~s(<select id="search_key" multiple="" name="search[key][]">) <>
               ~s(<option value="1">foo</option>) <>
               ~s(<option value="2">bar</option>) <> ~s(</select>)

    assert safe_to_string(wc_multiple_select(:search, :key, ~w(foo bar), value: ["foo"])) =~
             ~s(<option selected value="foo">foo</option>)

    assert safe_to_string(
             wc_multiple_select(:search, :key, [{"foo", "1"}, {"bar", "2"}], value: [1])
           ) =~ ~s(<option selected value="1">foo</option>)

    assert safe_to_string(
             wc_multiple_select(:search, :key, [{"foo", 1}, {"bar", 2}], selected: [1])
           ) =~
             ~s(<option selected value="1">foo</option>)

    assert safe_to_string(
             wc_multiple_select(:search, :key, %{
               "foo" => [{"One", 1}, {"Two", 2}],
               "bar" => ~w(3 4)
             })
           ) ==
             ~s(<select id="search_key" multiple="" name="search[key][]">) <>
               ~s(<optgroup label="bar">) <>
               ~s(<option value="3">3</option>) <>
               ~s(<option value="4">4</option>) <>
               ~s(</optgroup>) <>
               ~s(<optgroup label="foo">) <>
               ~s(<option value="1">One</option>) <>
               ~s(<option value="2">Two</option>) <> ~s(</optgroup>) <> ~s(</select>)
  end

  test "wc_multiple_select/4 with form" do
    assert safe_form(
             &wc_multiple_select(&1, :key, [{"foo", 1}, {"bar", 2}], value: [1], selected: [2])
           ) ==
             ~s(<select id="search_key" multiple="" name="search[key][]">) <>
               ~s(<option selected value="1">foo</option>) <>
               ~s(<option value="2">bar</option>) <> ~s(</select>)

    assert safe_form(&wc_multiple_select(&1, :other, [{"foo", 1}, {"bar", 2}], selected: [2])) ==
             ~s(<select id="search_other" multiple="" name="search[other][]">) <>
               ~s(<option value="1">foo</option>) <>
               ~s(<option selected value="2">bar</option>) <> ~s(</select>)

    assert safe_form(&wc_multiple_select(&1, :key, [{"foo", 1}, {"bar", 2}], value: [2])) ==
             ~s(<select id="search_key" multiple="" name="search[key][]">) <>
               ~s(<option value="1">foo</option>) <>
               ~s(<option selected value="2">bar</option>) <> ~s(</select>)

    assert safe_form(&wc_multiple_select(&1, :key, ~w(value novalue), value: ["novalue"])) ==
             ~s(<select id="search_key" multiple="" name="search[key][]">) <>
               ~s(<option value="value">value</option>) <>
               ~s(<option selected value="novalue">novalue</option>) <> ~s(</select>)

    assert safe_form(
             &wc_multiple_select(
               put_in(&1.params["key"], ["3"]),
               :key,
               [{"foo", 1}, {"bar", 2}, {"goo", 3}],
               selected: [2]
             )
           ) ==
             ~s(<select id="search_key" multiple="" name="search[key][]">) <>
               ~s(<option value="1">foo</option>) <>
               ~s(<option value="2">bar</option>) <>
               ~s(<option selected value="3">goo</option>) <> ~s(</select>)
  end

  test "wc_multiple_select/4 with unnamed form" do
    assert safe_form(
             &wc_multiple_select(&1, :key, [{"foo", 1}, {"bar", 2}], value: [1], selected: [2]),
             []
           ) ==
             ~s(<select id="key" multiple="" name="key[]">) <>
               ~s(<option selected value="1">foo</option>) <>
               ~s(<option value="2">bar</option>) <> ~s(</select>)

    assert safe_form(&wc_multiple_select(&1, :other, [{"foo", 1}, {"bar", 2}], selected: [2]), []) ==
             ~s(<select id="other" multiple="" name="other[]">) <>
               ~s(<option value="1">foo</option>) <>
               ~s(<option selected value="2">bar</option>) <> ~s(</select>)

    assert safe_form(&wc_multiple_select(&1, :key, [{"foo", 1}, {"bar", 2}], value: [2]), []) ==
             ~s(<select id="key" multiple="" name="key[]">) <>
               ~s(<option value="1">foo</option>) <>
               ~s(<option selected value="2">bar</option>) <> ~s(</select>)

    assert safe_form(&wc_multiple_select(&1, :key, ~w(value novalue), value: ["novalue"]), []) ==
             ~s(<select id="key" multiple="" name="key[]">) <>
               ~s(<option value="value">value</option>) <>
               ~s(<option selected value="novalue">novalue</option>) <> ~s(</select>)

    assert safe_form(
             &wc_multiple_select(
               put_in(&1.params["key"], ["3"]),
               :key,
               [{"foo", 1}, {"bar", 2}, {"goo", 3}],
               selected: [2]
             ),
             []
           ) ==
             ~s(<select id="key" multiple="" name="key[]">) <>
               ~s(<option value="1">foo</option>) <>
               ~s(<option value="2">bar</option>) <>
               ~s(<option selected value="3">goo</option>) <> ~s(</select>)
  end

  # options_for_select/2

  test "options_for_select/2" do
    assert options_for_select(~w(value novalue), "novalue") |> safe_to_string() ==
             ~s(<option value="value">value</option>) <>
               ~s(<option selected value="novalue">novalue</option>)

    assert options_for_select(~w(value novalue), "novalue") |> safe_to_string() ==
             ~s(<option value="value">value</option>) <>
               ~s(<option selected value="novalue">novalue</option>)

    assert options_for_select(
             [
               [value: "value", key: "Value", disabled: true],
               [value: "novalue", key: "No Value"]
             ],
             "novalue"
           )
           |> safe_to_string() ==
             ~s(<option disabled value="value">Value</option>) <>
               ~s(<option selected value="novalue">No Value</option>)

    assert options_for_select(~w(value novalue), ["value", "novalue"]) |> safe_to_string() ==
             ~s(<option selected value="value">value</option>) <>
               ~s(<option selected value="novalue">novalue</option>)
  end

  test "options_for_select/2 with groups" do
    assert options_for_select([{"foo", ~w(bar baz)}, {"qux", ~w(qux quz)}], "qux")
           |> safe_to_string() ==
             ~s(<optgroup label="foo">) <>
               ~s(<option value="bar">bar</option>) <>
               ~s(<option value="baz">baz</option>) <>
               ~s(</optgroup>) <>
               ~s(<optgroup label="qux">) <>
               ~s(<option selected value="qux">qux</option>) <>
               ~s(<option value="quz">quz</option>) <> ~s(</optgroup>)

    assert options_for_select([{"foo", ~w(bar baz)}, {"qux", ~w(qux quz)}], ["baz", "qux"])
           |> safe_to_string() ==
             ~s(<optgroup label="foo">) <>
               ~s(<option value="bar">bar</option>) <>
               ~s(<option selected value="baz">baz</option>) <>
               ~s(</optgroup>) <>
               ~s(<optgroup label="qux">) <>
               ~s(<option selected value="qux">qux</option>) <>
               ~s(<option value="quz">quz</option>) <> ~s(</optgroup>)
  end

  # wc_date_select/4

  test "wc_date_select/4" do
    content = safe_to_string(wc_date_select(:search, :datetime))
    assert content =~ ~s(<select id="search_datetime_year" name="search[datetime][year]">)
    assert content =~ ~s(<select id="search_datetime_month" name="search[datetime][month]">)
    assert content =~ ~s(<select id="search_datetime_day" name="search[datetime][day]">)

    content = safe_to_string(wc_date_select(:search, :datetime, value: {2020, 04, 17}))
    assert content =~ ~s(<option selected value="2020">2020</option>)
    assert content =~ ~s(<option selected value="4">April</option>)
    assert content =~ ~s(<option selected value="17">17</option>)

    content = safe_to_string(wc_date_select(:search, :datetime, value: "2020-04-17"))
    assert content =~ ~s(<option selected value="2020">2020</option>)
    assert content =~ ~s(<option selected value="4">April</option>)
    assert content =~ ~s(<option selected value="17">17</option>)

    content =
      safe_to_string(wc_date_select(:search, :datetime, value: %{year: 2020, month: 04, day: 07}))

    assert content =~ ~s(<option selected value="2020">2020</option>)
    assert content =~ ~s(<option selected value="4">April</option>)
    assert content =~ ~s(<option selected value="7">07</option>)

    content =
      safe_to_string(wc_date_select(:search, :datetime, value: %{year: 2020, month: 04, day: 09}))

    assert content =~ ~s(<option selected value="2020">2020</option>)
    assert content =~ ~s(<option selected value="4">April</option>)
    assert content =~ ~s(<option selected value="9">09</option>)

    content =
      safe_to_string(
        wc_date_select(
          :search,
          :datetime,
          year: [prompt: "Year"],
          month: [prompt: "Month"],
          day: [prompt: "Day"]
        )
      )

    assert content =~
             ~s(<select id="search_datetime_year" name="search[datetime][year]">) <>
               ~s(<option value="">Year</option>)

    assert content =~
             ~s(<select id="search_datetime_month" name="search[datetime][month]">) <>
               ~s(<option value="">Month</option>)

    assert content =~
             ~s(<select id="search_datetime_day" name="search[datetime][day]">) <>
               ~s(<option value="">Day</option>)
  end

  test "wc_date_select/4 with form" do
    content = safe_form(&wc_date_select(&1, :datetime, default: {2020, 10, 13}))
    assert content =~ ~s(<select id="search_datetime_year" name="search[datetime][year]">)
    assert content =~ ~s(<select id="search_datetime_month" name="search[datetime][month]">)
    assert content =~ ~s(<select id="search_datetime_day" name="search[datetime][day]">)
    assert content =~ ~s(<option selected value="2020">2020</option>)
    assert content =~ ~s(<option selected value="4">April</option>)
    assert content =~ ~s(<option selected value="17">17</option>)
    assert content =~ ~s(<option value="1">January</option><option value="2">February</option>)

    content = safe_form(&wc_date_select(&1, :unknown, default: {2020, 9, 9}))
    assert content =~ ~s(<option selected value="2020">2020</option>)
    assert content =~ ~s(<option selected value="9">September</option>)
    assert content =~ ~s(<option selected value="9">09</option>)

    content = safe_form(&wc_date_select(&1, :unknown, default: {2020, 10, 13}))
    assert content =~ ~s(<option selected value="2020">2020</option>)
    assert content =~ ~s(<option selected value="10">October</option>)
    assert content =~ ~s(<option selected value="13">13</option>)

    content = safe_form(&wc_date_select(&1, :datetime, value: {2020, 10, 13}))
    assert content =~ ~s(<option selected value="2020">2020</option>)
    assert content =~ ~s(<option selected value="10">October</option>)
    assert content =~ ~s(<option selected value="13">13</option>)
  end

  # wc_time_select/4

  test "wc_time_select/4" do
    content = safe_to_string(wc_time_select(:search, :datetime))
    assert content =~ ~s(<select id="search_datetime_hour" name="search[datetime][hour]">)
    assert content =~ ~s(<select id="search_datetime_minute" name="search[datetime][minute]">)
    refute content =~ ~s(<select id="search_datetime_second" name="search[datetime][second]">)

    content = safe_to_string(wc_time_select(:search, :datetime, second: []))
    assert content =~ ~s(<select id="search_datetime_hour" name="search[datetime][hour]">)
    assert content =~ ~s(<select id="search_datetime_minute" name="search[datetime][minute]">)
    assert content =~ ~s(<select id="search_datetime_second" name="search[datetime][second]">)

    content = safe_to_string(wc_time_select(:search, :datetime, value: {2, 9, 9}, second: []))
    assert content =~ ~s(<option selected value="2">02</option>)
    assert content =~ ~s(<option selected value="9">09</option>)
    assert content =~ ~s(<option selected value="9">09</option>)

    content =
      safe_to_string(wc_time_select(:search, :datetime, value: "02:11:13.123Z", second: []))

    assert content =~ ~s(<option selected value="2">02</option>)
    assert content =~ ~s(<option selected value="11">11</option>)
    assert content =~ ~s(<option selected value="13">13</option>)

    content = safe_to_string(wc_time_select(:search, :datetime, value: {2, 11, 13}, second: []))
    assert content =~ ~s(<option selected value="2">02</option>)
    assert content =~ ~s(<option selected value="11">11</option>)
    assert content =~ ~s(<option selected value="13">13</option>)

    content =
      safe_to_string(
        wc_time_select(:search, :datetime, value: %{hour: 2, minute: 11, second: 13}, second: [])
      )

    assert content =~ ~s(<option selected value="2">02</option>)
    assert content =~ ~s(<option selected value="11">11</option>)
    assert content =~ ~s(<option selected value="13">13</option>)

    content =
      safe_to_string(
        wc_time_select(
          :search,
          :datetime,
          hour: [prompt: "Hour"],
          minute: [prompt: "Minute"],
          second: [prompt: "Second"]
        )
      )

    assert content =~
             ~s(<select id="search_datetime_hour" name="search[datetime][hour]">) <>
               ~s(<option value="">Hour</option>)

    assert content =~
             ~s(<select id="search_datetime_minute" name="search[datetime][minute]">) <>
               ~s(<option value="">Minute</option>)

    assert content =~
             ~s(<select id="search_datetime_second" name="search[datetime][second]">) <>
               ~s(<option value="">Second</option>)
  end

  test "wc_time_select/4 with form" do
    content = safe_form(&wc_time_select(&1, :datetime, default: {1, 2, 3}, second: []))
    assert content =~ ~s(<select id="search_datetime_hour" name="search[datetime][hour]">)
    assert content =~ ~s(<select id="search_datetime_minute" name="search[datetime][minute]">)
    assert content =~ ~s(<select id="search_datetime_second" name="search[datetime][second]">)
    assert content =~ ~s(<option selected value="2">02</option>)
    assert content =~ ~s(<option selected value="11">11</option>)
    assert content =~ ~s(<option selected value="13">13</option>)
    assert content =~ ~s(<option value="1">01</option><option value="2">02</option>)

    content = safe_form(&wc_time_select(&1, :unknown, default: {1, 2, 3}, second: []))
    assert content =~ ~s(<option selected value="1">01</option>)
    assert content =~ ~s(<option selected value="2">02</option>)
    assert content =~ ~s(<option selected value="3">03</option>)

    content = safe_form(&wc_time_select(&1, :datetime, value: {1, 2, 3}, second: []))
    assert content =~ ~s(<option selected value="1">01</option>)
    assert content =~ ~s(<option selected value="2">02</option>)
    assert content =~ ~s(<option selected value="3">03</option>)
  end

  # wc_datetime_select/4

  test "wc_datetime_select/4" do
    content = safe_to_string(wc_datetime_select(:search, :datetime))
    assert content =~ ~s(<select id="search_datetime_year" name="search[datetime][year]">)
    assert content =~ ~s(<select id="search_datetime_month" name="search[datetime][month]">)
    assert content =~ ~s(<select id="search_datetime_day" name="search[datetime][day]">)
    assert content =~ ~s(<select id="search_datetime_hour" name="search[datetime][hour]">)
    assert content =~ ~s(<select id="search_datetime_minute" name="search[datetime][minute]">)
    refute content =~ ~s(<select id="search_datetime_second" name="search[datetime][second]">)

    content = safe_to_string(wc_datetime_select(:search, :datetime, second: []))
    assert content =~ ~s(<select id="search_datetime_year" name="search[datetime][year]">)
    assert content =~ ~s(<select id="search_datetime_month" name="search[datetime][month]">)
    assert content =~ ~s(<select id="search_datetime_day" name="search[datetime][day]">)
    assert content =~ ~s(<select id="search_datetime_hour" name="search[datetime][hour]">)
    assert content =~ ~s(<select id="search_datetime_minute" name="search[datetime][minute]">)
    assert content =~ ~s(<select id="search_datetime_second" name="search[datetime][second]">)

    content =
      safe_to_string(
        wc_datetime_select(:search, :datetime, value: {{2020, 9, 9}, {2, 11, 13}}, second: [])
      )

    assert content =~ ~s(<option selected value="2020">2020</option>)
    assert content =~ ~s(<option selected value="9">September</option>)
    assert content =~ ~s(<option selected value="9">09</option>)
    assert content =~ ~s(<option selected value="2">02</option>)
    assert content =~ ~s(<option selected value="11">11</option>)
    assert content =~ ~s(<option selected value="13">13</option>)

    content =
      safe_to_string(
        wc_datetime_select(:search, :datetime, value: {{2020, 04, 17}, {2, 11, 13}}, second: [])
      )

    assert content =~ ~s(<option selected value="2020">2020</option>)
    assert content =~ ~s(<option selected value="4">April</option>)
    assert content =~ ~s(<option selected value="17">17</option>)
    assert content =~ ~s(<option selected value="2">02</option>)
    assert content =~ ~s(<option selected value="11">11</option>)
    assert content =~ ~s(<option selected value="13">13</option>)
  end

  test "wc_datetime_select/4 with form" do
    content =
      safe_form(
        &wc_datetime_select(&1, :datetime, default: {{2020, 10, 13}, {1, 2, 3}}, second: [])
      )

    assert content =~ ~s(<select id="search_datetime_year" name="search[datetime][year]">)
    assert content =~ ~s(<select id="search_datetime_month" name="search[datetime][month]">)
    assert content =~ ~s(<select id="search_datetime_day" name="search[datetime][day]">)
    assert content =~ ~s(<option selected value="2020">2020</option>)
    assert content =~ ~s(<option selected value="4">April</option>)
    assert content =~ ~s(<option selected value="17">17</option>)

    assert content =~ ~s(<select id="search_datetime_hour" name="search[datetime][hour]">)
    assert content =~ ~s(<select id="search_datetime_minute" name="search[datetime][minute]">)
    assert content =~ ~s(<select id="search_datetime_second" name="search[datetime][second]">)
    assert content =~ ~s(<option selected value="2">02</option>)
    assert content =~ ~s(<option selected value="11">11</option>)
    assert content =~ ~s(<option selected value="13">13</option>)

    content =
      safe_form(
        &wc_datetime_select(&1, :unknown, default: {{2020, 10, 9}, {1, 2, 3}}, second: [])
      )

    assert content =~ ~s(<option selected value="2020">2020</option>)
    assert content =~ ~s(<option selected value="10">October</option>)
    assert content =~ ~s(<option selected value="9">09</option>)
    assert content =~ ~s(<option selected value="1">01</option>)
    assert content =~ ~s(<option selected value="2">02</option>)
    assert content =~ ~s(<option selected value="3">03</option>)

    content =
      safe_form(
        &wc_datetime_select(&1, :unknown, default: {{2020, 10, 13}, {1, 2, 3}}, second: [])
      )

    assert content =~ ~s(<option selected value="2020">2020</option>)
    assert content =~ ~s(<option selected value="10">October</option>)
    assert content =~ ~s(<option selected value="13">13</option>)
    assert content =~ ~s(<option selected value="1">01</option>)
    assert content =~ ~s(<option selected value="2">02</option>)
    assert content =~ ~s(<option selected value="3">03</option>)

    content =
      safe_form(
        &wc_datetime_select(&1, :datetime, value: {{2020, 10, 13}, {1, 2, 3}}, second: [])
      )

    assert content =~ ~s(<option selected value="2020">2020</option>)
    assert content =~ ~s(<option selected value="10">October</option>)
    assert content =~ ~s(<option selected value="13">13</option>)
    assert content =~ ~s(<option selected value="1">01</option>)
    assert content =~ ~s(<option selected value="2">02</option>)
    assert content =~ ~s(<option selected value="3">03</option>)
  end

  test "wc_datetime_select/4 with builder" do
    builder = fn b ->
      html_escape([
        "Year: ",
        b.(:year, class: "year"),
        "Month: ",
        b.(:month, class: "month"),
        "Day: ",
        b.(:day, class: "day"),
        "Hour: ",
        b.(:hour, class: "hour"),
        "Min: ",
        b.(:minute, class: "min"),
        "Sec: ",
        b.(:second, class: "sec")
      ])
    end

    content =
      safe_to_string(
        wc_datetime_select(
          :search,
          :datetime,
          builder: builder,
          year: [id: "year"],
          month: [id: "month"],
          day: [id: "day"],
          hour: [id: "hour"],
          minute: [id: "min"],
          second: [id: "sec"]
        )
      )

    assert content =~ ~s(Year: <select class="year" id="year" name="search[datetime][year]">)
    assert content =~ ~s(Month: <select class="month" id="month" name="search[datetime][month]">)
    assert content =~ ~s(Day: <select class="day" id="day" name="search[datetime][day]">)
    assert content =~ ~s(Hour: <select class="hour" id="hour" name="search[datetime][hour]">)
    assert content =~ ~s(Min: <select class="min" id="min" name="search[datetime][minute]">)
    assert content =~ ~s(Sec: <select class="sec" id="sec" name="search[datetime][second]">)
  end
end
