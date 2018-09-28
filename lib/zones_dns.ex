defmodule Flare.Zones.DNS do
    def records(zone, params \\ []), do: Flare.get("zones/#{zone}/dns_records")
    def details(zone, id, params \\ []), do: Flare.get("zones/#{zone}/dns_records/#{id}")
    def create(zone, type, name, content, ttl \\ 120, proxied \\ false), do: Flare.post("zones/#{zone}/dns_records", %{
        type: type,
        name: name,
        content: content,
        ttl: ttl,
        proxied: proxied,
    })
  def delete(zone, id), do: Flare.delete("zones/#{zone}/dns_records/#{id}")
end

