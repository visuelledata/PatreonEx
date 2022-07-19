# patreon-ex

This is an incomplete for the Patreon V2 API. Not all endpoints have wrapper functions yet.

For setup: 
* You must first [register a client](https://docs.patreon.com/#clients-and-api-keys) on Patreon, when doing this select Client API V2

The  workflow is:
1. Fill out the config/config.txt file and change it to an .exs filetype  
2. Run Patreon.Impl.authothorize_url/1 with the desired scopes
3. Go to the generated link and login or click "Allow"
4. Pass the "code" parameter from the redirected URL into Patreon.validate_token/1 and copy the access_token from the response
5. Pass the access_token into Patreon.get_user/1 or Patreon.get_campaigns/1

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `patreon` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:patreon, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/patreon>.

