defmodule PhxWCStoryBook.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: PhxWCStoryBook.PubSub}
      # Start a worker by calling: PhxWCStoryBook.Worker.start_link(arg)
      # {PhxWCStoryBook.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: PhxWCStoryBook.Supervisor)
  end
end
