#
#  Created by Boyd Multerer on 3/27/18.
#  Copyright © 2018 Kry10 Industries. All rights reserved.
#

# Supervisor for non-dynamic scenes

defmodule Scenic.Scene.Supervisor do
  use Supervisor


  def child_spec({ref, scene_module}), do:
    child_spec({ref, scene_module, nil})

  def child_spec({ref, scene_module, args}) do
    %{
      id: ref,
      start: {__MODULE__, :start_link, [{ref, scene_module, args}]},
      type: :supervisor,
      restart: :permanent,
      shutdown: 500
    }
  end


  def start_link( {ref, module, args} ) do
    Supervisor.start_link(__MODULE__, {ref, module, args})
  end

  def init( args ) do
    [
      {DynamicSupervisor, strategy: :one_for_one},
      {Scenic.Scene, args},
    ]
    |> Supervisor.init( strategy: :one_for_all )
  end

end
