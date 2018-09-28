defmodule Flare do
	alias HTTPipe.Conn
	@base "https://api.cloudflare.com/client/v4/"

	def base, do: @base
	def key, do: Application.get_env(:flare, :key)
	def email, do: Application.get_env(:flare, :email)

	def get(path, query \\ []), do: request(path, "GET", nil, query)
	def post(path, body \\ nil, query \\ []), do: request(path, "POST", body, query)
	def put(path, body \\ nil, query \\ []), do: request(path, "PUT", body, query)
	def patch(path, body \\ nil, query \\ []), do: request(path, "PATCH", body, query)
	def delete(path, body \\ nil, query \\ []), do: request(path, "DELETE", body, query)

	def request(path, method, body \\ nil, query \\ []) do
		url =
			base()
			|> URI.merge(path)
			|> URI.to_string
			|> attach_query(query)

		conn = Conn.new
		|> Conn.put_req_url(url)
		|> Conn.put_req_method(method)
		|> Conn.put_req_header("Content-Type", "application/json")
		|> Conn.put_req_header("X-Auth-Key", key())
		|> Conn.put_req_header("X-Auth-Email", email())

    conn = if body do
      Conn.put_req_body(conn, Poison.encode!(body))
    else
      conn
    end

    conn
		|> Conn.execute
		|> case do
			{:ok, result} -> process(result)
			failed -> failed
		end
	end

	defp process(result) do
		result
		|> Map.get(:response)
		|> Map.get(:body)
		|> Poison.decode(keys: :atoms)
		|> case do
			{:ok, result} -> extract(result)
			failed -> failed
		end
	end

	def extract(result) do
		case result do
			%{success: true, result: result} -> result
			%{success: false, errors: [%{
				code: code,
				message: message,
			}]} -> {:error, {code, message}}
		end
	end

	defp attach_query(url, []), do: url
	defp attach_query(url, query) do
		url <> URI.encode_query(query)
	end

end
