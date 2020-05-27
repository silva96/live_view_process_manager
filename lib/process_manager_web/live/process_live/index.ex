defmodule ProcessManagerWeb.ProcessLive.Index do
  use ProcessManagerWeb, :live_view
  alias ProcessManager.Manager.Process, as: ManagedProcess

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :reload_processes, 1000)

    assigns =
      assign(socket, :processes, ManagedProcess.list_all(""))
      |> assign(:filter, "")

    {:ok, assigns}
  end

  @impl true
  def handle_event("kill", %{"id" => pid}, socket) do
    {_, 0} = ManagedProcess.kill(pid)
    IO.puts inspect(socket)
    {:noreply, assign(socket, :processes, ManagedProcess.list_all(""))}
  end

  @impl true
  def handle_event("filter", %{"term" => term}, socket) do
    assigns =
      assign(socket, :processes, ManagedProcess.list_all(term))
      |> assign(:filter, term)
    {:noreply, assigns}
  end

  @impl true
  def handle_event("details", %{"id" => pid}, socket) do
    details =
      if socket.assigns[:details] && socket.assigns[:details].pid == pid do
        nil
      else
        ManagedProcess.details(pid)
      end

    {:noreply, assign(socket, :details, details)}
  end

  @impl true
  def handle_info(:reload_processes, socket) do
    Process.send_after(self(), :reload_processes, 1000)
    filter = socket.assigns[:filter]
    assigns =
      if socket.assigns[:details] do
        details = ManagedProcess.details(socket.assigns.details.pid)

        assign(socket, :processes, ManagedProcess.list_all(filter))
        |> assign(:details, details)
      else
        assign(socket, :processes, ManagedProcess.list_all(filter))
      end

    {:noreply, assigns}
  end
end
