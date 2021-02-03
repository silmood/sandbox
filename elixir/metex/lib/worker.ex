defmodule Metex.Worker do

  @api_key "api_key"

  def loop do
    receive do
      {sender_pid, location} ->
        send(sender_pid, {:ok, temperature_of(location)})
      _ ->
        IO.puts "don't know how to process this message"
    end
    loop()
  end

  def temperature_of(location) do
    result = url_of(location)
      |> HTTPoison.get
      |> parse_response
    
    case result do
      {:ok, temp} ->
        "#{location}: #{temp}°C"
      :error ->
        "#{location} not found"
    end
  end

  defp url_of(location) do
    location = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{@api_key}"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body
    |> Jason.decode!
    |> compute_temperature
  end

  defp parse_response(_) do
    :error
  end

  defp compute_temperature(json) do
    try do
      (json["main"]["temp"] - 273.15)
      |> Float.round(1)
      |> (&({:ok, &1})).()
    rescue
      _ -> :error
    end
  end

end