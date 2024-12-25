defmodule HelloWeb.UserLive do
  use HelloWeb, :live_view

  alias Hello.Users
  alias Hello.User

  def mount(_param, _session, socket) do
    users = Users.list_users()
    user = %User{}
    changeset = User.changeset(user)
    form = to_form(changeset)

    socket =
      socket
      |> assign(:users, users)
      |> assign(:form, form)

    {:ok, socket}
  end

  def handle_params(params, url, socket) do
    case socket.assigns.live_action do
      :index -> do_index(socket)
      :new -> do_new(socket)
    end
  end

  def handle_event("validate", %{"user" => params}, socket) do
    changeset = User.changeset(%User{}, params)
    form = to_form(changeset, action: :validate)
    socket = assign(socket, :form, form)

    {:noreply, socket}
  end

  def handle_event("save", %{"user" => params}, socket) do
    case Users.create_user(params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Lo creaste a #{user.name}")
         |> push_navigate(to: ~p"/users")}

      {:error, changeset} ->
        form = to_form(changeset)
        socket = assign(socket, :form, form)

        {:noreply, socket}
    end
  end

  defp do_index(socket) do
    {:noreply, socket}
  end

  defp do_new(socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <.modal id="users-modal" show={@live_action == :new}>
      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} label="Name" />
        <.input field={@form[:email]} label="Email" />

        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
    </.modal>

    <.link navigate={~p"/users/new"}>
      New User
    </.link>

    <div :for={user <- @users}>
      {user.name}
    </div>
    """
  end
end
