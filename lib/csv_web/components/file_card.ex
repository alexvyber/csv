defmodule CsvWeb.Components.Files do
  use Phoenix.Component
  alias CsvWeb.Router.Helpers, as: Routes

  def file_card(assigns) do
    ~H"""
    <div class="p-3 bg-white rounded-md border border-slate-200 flex flex-col">
    <p> <%= @file.file_name %></p>

    <div>
    <%= Phoenix.HTML.Link.link "Open File", to: Routes.file_upload_path(@conn, :show, @file.file_path), class: "block mt-2 bg-green-50 border hover:bg-green-100 py-2 px-4 rounded-sm" %>
    </div>
    </div>
    """
  end
end
