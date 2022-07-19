defmodule Patreon.Impl.Wrapper do

  @scopes MapSet.new([
    "campaigns",
    "campaigns.members",
    "campaigns.members[email]",
    "campaigns.members.address",
    "identity",
    "identity.memberships",
    "identity[email]"
  ])



  defp base_url(),     do: "www.patreon.com"
  defp redirect_uri(), do: Patreon.Config.redirect_uri()
  defp client_id,      do: Patreon.Config.client_id()
  defp secret,         do: Patreon.Config.secret()

  defp http(host, method, path, query, headers, body \\ "") do
    {:ok, conn} = Mint.HTTP.connect(:https, host, 443)

    query_string =
      cond do
        query == %{} -> ""
        TRUE -> "?" <> URI.encode_query(query)
      end

    path = path <> query_string

    {:ok, conn, ref} =
      Mint.HTTP.request(
        conn,
        method,
        path,
        headers,
        body
      )

    receive_resp(conn, ref, nil, nil, false)
  end

  defp receive_resp(conn, ref, status, data, done?) do
    receive do
      message ->
        {:ok, conn, responses} = Mint.HTTP.stream(conn, message)

        {new_status, new_data, done?} =
          Enum.reduce(responses, {status, data, done?}, fn
            {:status, ^ref, new_status}, {_old_status, data, done?} -> {new_status, data, done?}
            {:headers, ^ref, _headers}, acc -> acc
            {:data, ^ref, binary}, {status, nil, done?} -> {status, binary, done?}
            {:data, ^ref, binary}, {status, data, done?} -> {status, data <> binary, done?}
            {:done, ^ref}, {status, data, _done?} -> {status, data, true}
          end)

        cond do
          done? and new_status == 200 -> {:ok, new_data}
          done? -> {:error, {new_status, new_data}}
          !done? -> receive_resp(conn, ref, new_status, new_data, done?)
        end
    end
  end


  defp authorize_query(scope, true) do
    state = random_string()

    %{
      response_type: "code",
      redirect_uri: redirect_uri(),
      scope: Enum.join(scope, " "),
      state: state,
      client_id: client_id()
    }
  end

  defp authorize_query(_scope, false) do
    state = random_string()

    %{
      response_type: "code",
      redirect_uri: redirect_uri(),
      state: state,
      client_id: client_id()
    }
  end

  def authorize_url() do
    base_url()
    <> "/oauth2/authorize?"
    <> URI.encode_query(authorize_query(@scopes, true))
  end

  def authorize_url(scope) when is_list(scope) do
    scope = MapSet.new(scope)

    cond do
      MapSet.subset?(scope, @scopes) ->
        {:ok, base_url() <> "/oauth2/authorize?" <> URI.encode_query(authorize_query(scope, scope !== MapSet.new()))}
      true ->
        {:error, "Invalid scope. Valid scopes are: #{Enum.join(@scopes, ", ")}"}
    end
  end

  defp random_string() do
    binary = <<
      System.system_time(:nanosecond)::64,
      :erlang.phash2({node(), self()})::16,
      :erlang.unique_integer()::16
    >>

    binary
    |> Base.url_encode64()
    |> String.replace(["/", "+"], "-")
  end

  defp validate_query(validation_code) do
    %{
      code: validation_code,
      grant_type: "authorization_code",
      client_id: client_id(),
      client_secret: secret(),
      redirect_uri:  redirect_uri(),
    }
  end

  def validate_token(validation_code) do
    resp = http(
      base_url(),
      "POST",
      "/api/oauth2/token",
      validate_query(validation_code),
      ["Content-Type: application/x-www-form-urlencoded"]
    )

    case resp do
      {:ok, info} -> {:ok, Jason.decode!(info)}
      {:error, _reason} = err -> err
    end
  end

  def get_user(token, params) do
    resp = http(
      base_url(),
      "GET",
      "/api/oauth2/v2/identity",
      params, # %{"fields[user]" => Enum.join(fields, ",")},
      [{"Authorization", "Bearer #{token}"}]
    )

    case resp do
      {:ok, info} -> {:ok, Jason.decode!(info)}
      {:error, _reason} = err -> err
    end
  end

  def get_campaigns(token, params) do
    resp = http(
      base_url(),
      "GET",
      "/api/oauth2/v2/campaigns",
      params, # %{"fields[campaign]" => Enum.join(fields, ",")},#
      [{"Authorization", "Bearer #{token}"}]
    )

    case resp do
      {:ok, info} -> {:ok, Jason.decode!(info)}
      {:error, _reason} = err -> err
    end
  end
end
