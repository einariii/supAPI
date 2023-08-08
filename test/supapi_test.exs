defmodule SupapiTest do
  use ExUnit.Case
  doctest Supapi

  test "says hi and thanks" do
    assert Supapi.hello() == "Let's gen-serve some API calls!"
  end
end
