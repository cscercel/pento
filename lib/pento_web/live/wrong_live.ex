defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {
      :ok,
      assign(
        socket,
        score: 0,
        message: "make a guess:",
        won: false,
        time: time(),
        answer: Enum.random(1..10)
      )
    }
  end

  def render(assigns) do
    ~H"""
    <main class="px-4 py20 sm:px-6 lg:px-8">
      <h1 class="mb-4 text-4xl font-extrabold">Your Score: {@score}</h1>
      <h2>
        {@message}
      </h2>
      <br />

      <%= if @won do %>
        <.link phx-click="restart" class="btn btn-primary inline-block font-bold">
          Play Again
        </.link>
      <% else %>
        <h2>
          <%= for n <- 1..10 do %>
            <.link
              class="btn btn-secondary"
              phx-click="guess"
              phx-value-number={n}
            >
              {n}
            </.link>
          <% end %>
        </h2>
      <% end %>
      <h2>
        It's {@time}
      </h2>
    </main>
    """
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    is_correct = String.to_integer(guess) == socket.assigns.answer

    {message, score, won} =
      if is_correct do
        {"Congratulations! You guessed right. ", socket.assigns.score + 1, true}
      else
        {"Your guess: #{guess}. Wrong, Guess again. ", socket.assigns.score - 1, false}
      end

    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        won: won,
        time: time()
      )
    }
  end

  def handle_event("restart", _params, socket) do
    {
      :noreply,
      assign(
        socket,
        score: 0,
        message: "make a guess:",
        won: false,
        time: time(),
        answer: Enum.random(1..10)
      )
    }
  end

  def time do
    DateTime.utc_now() |> to_string()
  end
end
