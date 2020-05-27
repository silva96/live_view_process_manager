defmodule ProcessManager.Manager.Process do
  alias __MODULE__
  defstruct [:pid, :command, :owner, :port]

  def list_all(term) do
    call_ps
    |> parse_lines
    |> filter_header
    |> remove_empty_lines
    |> parse_each_line
    |> remove_duplicates
    |> filter(term)
  end

  def kill(pid) do
    System.cmd("kill", [pid])
  end

  def details(pid) do
    {result, _} = System.cmd("ps", [pid])
    %{pid: pid, info: String.replace(result, "\n", "<br>")}
  end

  defp call_ps do
    {result, _} = System.cmd("lsof", ["-P", "-iTCP", "-sTCP:LISTEN"])
    result
  end

  defp filter(process_list, term) do
    if term != nil && term != "" do
      process_list
      |> Enum.filter(fn process ->
        String.contains?(process.pid, term) ||
          String.contains?(process.command, term) ||
          String.contains?(process.owner, term) ||
          String.contains?(process.port, term)
      end)
    else
      process_list
    end
  end

  defp parse_lines(ps_result_string) do
    ps_result_string
    |> String.split("\n")
  end

  defp filter_header(list_of_lines) do
    if length(list_of_lines) > 0 do
      [_ | lines] = list_of_lines
      lines
    else
      list_of_lines
    end
  end

  defp remove_empty_lines(list_of_lines) do
    list_of_lines
    |> Enum.filter(fn line -> line != "" end)
  end

  defp parse_each_line(list_of_lines) do
    list_of_lines
    |> Enum.map(&line_to_struct/1)
  end

  def remove_duplicates(process_list) do
    process_list
    |> Enum.uniq_by(fn %Process{pid: pid} -> pid end)
  end

  # lines look like this
  # memcached 1033 benja 18u IPv6 0xd154af3251067817 0t0 TCP localhost:11211 (LISTEN)
  defp line_to_struct(line) do
    [command, pid, owner | extra] = String.split(line)
    port = extract_port(extra)

    %Process{pid: pid, command: command, owner: owner, port: port}
  end

  defp extract_port(extra) do
    extra
    |> Enum.at(-2)
    |> String.split(":")
    |> List.last()
  end
end
