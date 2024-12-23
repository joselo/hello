defmodule Hello.Users do
  import Ecto.Query

  alias Hello.Repo
  alias Hello.User

  def list_users do
    query = from(users in User)

    Repo.all(query)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(user, attrs \\ %{}) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def delete_user(user) do
    Repo.delete(user)
  end
end
