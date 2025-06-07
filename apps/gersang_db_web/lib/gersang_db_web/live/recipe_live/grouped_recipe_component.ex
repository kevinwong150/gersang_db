defmodule GersangDbWeb.RecipeLive.GroupedRecipeComponent do
  use GersangDbWeb, :live_component

  alias GersangDbWeb.Router.Helpers, as: Routes
  alias GersangDb.Recipes
  alias GersangDb.RecipeSpecs
  alias GersangDbWeb.Utils.ViewHelpers

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white shadow rounded-lg p-6">
      <h2 class="text-xl font-bold text-blue-700 mb-2 flex items-center gap-2">
        <span class="inline-block bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-base font-semibold">
          <%= @grouped_recipe.product.name %>
        </span>
      </h2>

      <!-- Total Cost Row -->
      <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-3 mb-4">
        <div class="flex flex-col md:flex-row md:items-center md:gap-6">
          <div class="font-semibold text-gray-700 w-32">Total Cost:</div>
          <div class="text-yellow-800 font-mono text-sm">
            <%= @grouped_recipe.cost_breakdown %>
          </div>
        </div>
      </div>      <div class="space-y-4">
      <%= for %{media: media, materials: materials} <- @grouped_recipe.by_media do %>
        <% recipe_spec = RecipeSpecs.get_recipe_spec_by_product_and_media(@grouped_recipe.product.id, media) %>
          <div class="relative border-l-4 border-blue-400 pl-4 py-6 bg-blue-50 rounded mb-2">
            <div class="absolute top-2 right-2 flex gap-2">              <.link :if={@source == :index && recipe_spec} navigate={~p"/gersang/recipes/#{@grouped_recipe.product.id}/#{recipe_spec.id}"} class="rounded-full bg-green-200 hover:bg-green-400 p-2 transition-colors" title="Show">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5 text-green-700">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M2.036 12.322a1.012 1.012 0 0 1 0-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178Z" />
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z" />
                </svg>
              </.link>
              <.link :if={recipe_spec} patch={~p"/gersang/recipes/#{@grouped_recipe.product.id}/#{recipe_spec.id}/edit"} class="rounded-full bg-blue-200 hover:bg-blue-400 p-2 transition-colors" title="Edit">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5 text-blue-700">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487a2.1 2.1 0 1 1 2.97 2.97L7.5 19.79l-4 1 1-4 14.362-14.303z" />
                </svg>
              </.link>              <.link :if={recipe_spec}
                phx-click={JS.push("delete", value: %{product_id: @grouped_recipe.product.id, recipe_spec_id: recipe_spec.id}, target: @myself)}
                data-confirm="Are you sure?"
                class="rounded-full bg-red-200 hover:bg-red-400 p-2 transition-colors"
                title="Delete"
              >
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5 text-red-700">
                  <path stroke-linecap="round" stroke-linejoin="round" d="m14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0" />
                </svg>
              </.link>
            </div>
            <div class="flex flex-col md:flex-row md:items-center md:gap-6">
              <div class="font-semibold text-gray-700 w-32">Media:</div>
              <div class="text-blue-700 font-mono"><%= media %></div>
            </div>
            <div class="flex flex-col md:flex-row md:items-center md:gap-6 mt-1">
              <div class="font-semibold text-gray-700 w-32">Materials:</div>
              <div class="flex flex-col gap-1 w-full">
              <%= for material_info <- materials do %>
                <% material = material_info.item %>
                <% amount = material_info.amount %>
                  <div class="flex justify-between items-center bg-green-50 border border-green-200 px-3 py-2 rounded">
                    <div class="flex items-center gap-2 text-green-800 font-medium">
                      <span><%= amount || "N/A" %></span>
                      <span>*</span>
                      <span><%= material.name %></span>
                      <span>@<%= if material.market_price, do: ViewHelpers.format_number_with_commas(material.market_price), else: "N/A" %></span>
                    </div>
                    <span class="text-green-700 font-mono text-sm ml-auto">
                      <%= if material.market_price && amount do %>
                        <%= ViewHelpers.format_number_with_commas(amount * material.market_price) %>
                      <% else %>
                        N/A
                      <% end %>
                    </span>
                  </div>
                <% end %>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
  @impl true
  def handle_event("delete", %{"product_id" => product_id, "recipe_spec_id" => recipe_spec_id}, socket) do
    product_id_int = if is_binary(product_id), do: String.to_integer(product_id), else: product_id
    recipe_spec_id_int = if is_binary(recipe_spec_id), do: String.to_integer(recipe_spec_id), else: recipe_spec_id

    import Ecto.Query
    alias GersangDb.Domain.Recipe
    alias GersangDb.Repo

    # Construct the query to delete recipes matching product_id and recipe_spec_id
    query = from(r in Recipe, where: r.product_item_id == ^product_id_int and r.recipe_spec_id == ^recipe_spec_id_int)

    case Repo.delete_all(query) do
      {_count, _nil} -> # Successful deletion, delete_all returns {count, nil}
        {:noreply,
          socket
          |> put_flash(:info, "Recipe deleted successfully.")
          |> push_patch(to: Routes.live_path(socket, GersangDbWeb.RecipeLive.Index))}
      {:error, reason} -> # Handle potential errors during deletion
        IO.inspect(reason, label: "DELETE ERROR")
        {:noreply, put_flash(socket, :error, "Failed to delete recipe.")}
    end
  end
end
