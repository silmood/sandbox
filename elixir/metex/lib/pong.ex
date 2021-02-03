defmodule Pong do

  def ping do
    receive do
      {:ping, sender_pid} ->
        IO.puts("ping")
        Process.sleep(1000)
        send(sender_pid, {:pong, self()})
    end
    ping()
  end

  def pong do
    receive do
      {:pong, sender_pid} ->
        IO.puts("pong")
        Process.sleep(1000)
        send(sender_pid, {:ping, self()})
    end
    pong()
  end
end