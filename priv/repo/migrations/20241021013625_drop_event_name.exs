defmodule Tally.Repo.Migrations.DropEventName do
  use Ecto.Migration

  def change do
    alter table(:events) do
      remove :name, :string
    end
  end
end
