defmodule Flare.Zones do
    def list(params \\ []), do: Flare.get("zones", params)

    def details(zone, params \\ []), do: Flare.get("zones/#{zone}", params)

end