defmodule Patreon do
  alias Patreon.Impl.Wrapper

  def get_user(token) do
    Wrapper.get_user(
      token,
      %{
        "include" => "memberships.currently_entitled_tiers",
        "fields[user]" => Enum.join(["about", "hide_pledges", "full_name", "image_url", "thumb_url", "url"], ","),
        "fields[tier]" => Enum.join(["title", "description"], ",")
      }
      )
  end

  def get_campaigns(token) do
    Wrapper.get_campaigns(
      token,
      %{
        "include" => "tiers",
        "fields[campaign]" => Enum.join(["vanity", "creation_name", "discord_server_id", "image_url", "is_nsfw", "url"], ","),
        "fields[tier]" => Enum.join(["title", "description"], ",")
      }
      )
  end

  def authorize_url() do
    Wrapper.authorize_url(["identity", "identity.memberships", "campaigns"])
  end

  defdelegate validate_token(validation_code), to: Wrapper
end
