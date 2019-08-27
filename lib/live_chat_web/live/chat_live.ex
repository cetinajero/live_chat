defmodule LiveChatWeb.ChatLive do
  use Phoenix.LiveView

  def mount(%{user: user}, socket) do
    assigns = [
      user: user
    ]
    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    ~L"""
    <div class="fullscreen">Welcome to chat, <%= @user.name%>!</div>
    """
  end

  def handle_info(:count, socket) do
    Process.send_after(self(), :count, 1_000)
    count = socket.assigns.count + 1

    {:noreply, assign(socket, :count, count)}
  end
end
