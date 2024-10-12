defmodule SimpleWS.RateLimiter do
  def allow(id) do
    case Hammer.check_rate(id, 60_000, 60) do
      {:allow, _count} ->
        :ok

      {:deny, _limit} ->
        :limit
    end
  end
end
