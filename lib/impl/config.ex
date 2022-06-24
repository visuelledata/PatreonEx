defmodule Patreon.Config do
  def client_id() do
    Application.get_env(:patreon, :client_id)
  end

  def secret() do
    Application.get_env(:patreon, :client_secret)
  end

  def creator_access_token() do
    Application.get_env(:patreon, :creator_access_token)
  end

  def creator_refresh_token() do
    Application.get_env(:patreon, :creator_refresh_token)
  end

  def redirect_uri() do
    Application.get_env(:patreon, :redirect_uri)
  end
end
