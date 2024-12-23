defmodule HelloWeb.UserLive do
  use HelloWeb, :live_view

  alias Hello.Users

  def mount(_param, _session, socket) do
    users = Users.list_users()

    socket = assign(socket, :users, users)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div :for={user <- @users}>
      {user.name}
    </div>
    """
  end
end
