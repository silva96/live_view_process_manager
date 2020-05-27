defmodule ProcessManager.ManagerTest do
  use ProcessManager.DataCase

  alias ProcessManager.Manager

  describe "processes" do
    alias ProcessManager.Manager.Process

    @valid_attrs %{name: "some name", pid: 42}
    @update_attrs %{name: "some updated name", pid: 43}
    @invalid_attrs %{name: nil, pid: nil}

    def process_fixture(attrs \\ %{}) do
      {:ok, process} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Manager.create_process()

      process
    end

    test "list_processes/0 returns all processes" do
      process = process_fixture()
      assert Manager.list_processes() == [process]
    end

    test "get_process!/1 returns the process with given id" do
      process = process_fixture()
      assert Manager.get_process!(process.id) == process
    end

    test "create_process/1 with valid data creates a process" do
      assert {:ok, %Process{} = process} = Manager.create_process(@valid_attrs)
      assert process.name == "some name"
      assert process.pid == 42
    end

    test "create_process/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Manager.create_process(@invalid_attrs)
    end

    test "update_process/2 with valid data updates the process" do
      process = process_fixture()
      assert {:ok, %Process{} = process} = Manager.update_process(process, @update_attrs)
      assert process.name == "some updated name"
      assert process.pid == 43
    end

    test "update_process/2 with invalid data returns error changeset" do
      process = process_fixture()
      assert {:error, %Ecto.Changeset{}} = Manager.update_process(process, @invalid_attrs)
      assert process == Manager.get_process!(process.id)
    end

    test "delete_process/1 deletes the process" do
      process = process_fixture()
      assert {:ok, %Process{}} = Manager.delete_process(process)
      assert_raise Ecto.NoResultsError, fn -> Manager.get_process!(process.id) end
    end

    test "change_process/1 returns a process changeset" do
      process = process_fixture()
      assert %Ecto.Changeset{} = Manager.change_process(process)
    end
  end
end
