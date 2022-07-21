defmodule PatreonEx do
  alias PatreonEx.Impl.Wrapper

  defdelegate authorize_url(scope, redirect_uri, client_id), to: Wrapper
  defdelegate authorize_url(redirect_uri, client_id), to: Wrapper
  defdelegate validate_token(validation_code, redirect_uri, client_id, client_secret), to: Wrapper
  defdelegate get_user(token, params), to: Wrapper
  defdelegate get_campaigns(token, params), to: Wrapper
  
  # def get_user(token) do
  #   Wrapper.get_user(
  #     token,
  #     %{
  #       "include" => "memberships.currently_entitled_tiers",
  #       "fields[user]" => Enum.join(["about", "hide_pledges", "full_name", "image_url", "thumb_url", "url"], ","),
  #       "fields[tier]" => Enum.join(["title", "description"], ",")
  #     }
  #     )
  # end

  # def get_campaigns(token) do
  #   Wrapper.get_campaigns(
  #     token,
  #     %{
  #       "include" => "tiers",
  #       "fields[campaign]" => Enum.join(["vanity", "creation_name", "discord_server_id", "image_url", "is_nsfw", "url"], ","),
  #       "fields[tier]" => Enum.join(["title", "description"], ",")
  #     }
  #     )
  # end

  # def authorize_url() do
  #   Wrapper.authorize_url(["identity", "identity.memberships", "campaigns"], redirect_uri, client_id)
  # end

  # def authorize_url(scope, redirect_uri, client_id) when is_list(scope) do
  #   Wrapper.authorize_url(
  #     scope,
  #     redirect_uri,
  #     client_id
  #   )
  # end

  # def authorize_url(redirect_uri, client_id) do
  #   Wrapper.authorize_url(
  #     redirect_uri,
  #     client_id
  #   )
  # end

end
