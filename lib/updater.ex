defmodule Updater do
  @ip "172.21.254.22"
  def pull_update do
    res = HTTPoison.get!("http://" <> @ip <> "/fwuppoc.fw")
    File.write!("/tmp/firmware", res.body, [:binary, :write])
    Nerves.Firmware.apply("/tmp/firmware", "upgrade")
  end

  def report_status do
    nerves_fw_active = Nerves.Runtime.KV.get("nerves_fw_active")
    slot_a_firmware = Nerves.Runtime.KV.get("a.nerves_fw_version")
    slot_b_firmware = Nerves.Runtime.KV.get("b.nerves_fw_version")

    status = Nerves.Firmware.state().status

    data = %{
      active_partition: nerves_fw_active,
      slot_a_firmware: slot_a_firmware,
      slot_b_firmware: slot_b_firmware,
      status: status
    }

    HTTPoison.post("http://" <> @ip <> "/report", Jason.encode(data), [
      {"Content-Type", "application/json"}
    ])
  end
end
