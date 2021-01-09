defmodule MorseDecoder.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Cluster.Supervisor,
       [Application.get_env(:libcluster, :topologies), [name: MorseDecoder.ClusterSupervisor]]},
      MorseDecoder.DynamicSupervisor,
      MorseDecoder.ProcessGroup,
      MorseDecoderWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: MorseDecoder.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MorseDecoderWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
