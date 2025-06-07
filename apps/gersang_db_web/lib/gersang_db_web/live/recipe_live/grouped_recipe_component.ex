defmodule GersangDbWeb.RecipeLive.GroupedRecipeComponent do
  use GersangDbWeb, :live_component

  alias GersangDbWeb.Router.Helpers, as: Routes
  alias GersangDb.Recipes
  alias GersangDb.RecipeSpecs
  alias GersangDbWeb.Utils.ViewHelpers
  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-gradient-to-br from-white to-slate-50 shadow-lg border border-slate-200 rounded-xl p-8 transition-shadow hover:shadow-xl">
      <!-- Product Header -->
      <div class="mb-6">
        <h2 class="text-2xl font-bold text-slate-800 mb-3 flex items-center gap-3">
          <span class="inline-flex items-center bg-gradient-to-r from-indigo-500 to-purple-600 text-white px-4 py-2 rounded-full text-lg font-semibold shadow-md">
            🏭 <%= @grouped_recipe.product.name %>
          </span>
        </h2>
      </div>

      <!-- Total Cost Section -->
      <div class="bg-gradient-to-r from-amber-50 to-orange-50 border border-amber-200 rounded-lg p-4 mb-6 shadow-sm">
        <div class="flex flex-col md:flex-row md:items-center md:gap-6">
          <div class="flex items-center gap-2 font-semibold text-amber-800 w-36">
            💰 <span>Total Cost:</span>
          </div>
          <div class="text-amber-900 font-mono text-lg font-bold bg-white/70 px-3 py-1 rounded-md">
            <%= @grouped_recipe.cost_breakdown %>
          </div>
        </div>
      </div>      <!-- Recipe Media Sections -->
      <div class="space-y-6">
      <%= for %{media: media, materials: materials} <- @grouped_recipe.by_media do %>
        <% recipe_spec = RecipeSpecs.get_recipe_spec_by_product_and_media(@grouped_recipe.product.id, media) %>
          <div class="relative border border-slate-200 bg-gradient-to-r from-slate-50 to-slate-100 rounded-xl p-6 shadow-md hover:shadow-lg transition-shadow">
            <!-- Action Buttons -->
            <div class="absolute top-4 right-4 flex gap-3">              <.link :if={@source == :index && recipe_spec} navigate={~p"/gersang/recipes/#{@grouped_recipe.product.id}/#{recipe_spec.id}"} class="group inline-flex items-center justify-center w-10 h-10 bg-emerald-100 hover:bg-emerald-200 rounded-lg transition-all duration-200 shadow-sm hover:shadow-md" title="View Recipe">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5 text-emerald-700 group-hover:text-emerald-800">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M2.036 12.322a1.012 1.012 0 0 1 0-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178Z" />
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z" />
                </svg>
              </.link>
              <.link :if={recipe_spec} patch={~p"/gersang/recipes/#{@grouped_recipe.product.id}/#{recipe_spec.id}/edit"} class="group inline-flex items-center justify-center w-10 h-10 bg-blue-100 hover:bg-blue-200 rounded-lg transition-all duration-200 shadow-sm hover:shadow-md" title="Edit Recipe">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5 text-blue-700 group-hover:text-blue-800">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487a2.1 2.1 0 1 1 2.97 2.97L7.5 19.79l-4 1 1-4 14.362-14.303z" />
                </svg>
              </.link>              <.link :if={recipe_spec}
                phx-click={JS.push("delete", value: %{product_id: @grouped_recipe.product.id, recipe_spec_id: recipe_spec.id}, target: @myself)}
                data-confirm="Are you sure you want to delete this recipe?"
                class="group inline-flex items-center justify-center w-10 h-10 bg-red-100 hover:bg-red-200 rounded-lg transition-all duration-200 shadow-sm hover:shadow-md"
                title="Delete Recipe"
              >
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5 text-red-700 group-hover:text-red-800">
                  <path stroke-linecap="round" stroke-linejoin="round" d="m14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0" />
                </svg>
              </.link>
            </div>
            <!-- Media Information -->
            <div class="mb-5">
              <div class="flex flex-col md:flex-row md:items-center md:gap-6 mb-3">
                <div class="flex items-center gap-2 font-semibold text-slate-700 w-40">
                  🎯 <span>Media Type:</span>
                </div>
                <div class="bg-indigo-100 text-indigo-800 font-semibold px-3 py-1 rounded-full inline-block">
                  <%= media %>
                </div>
              </div>
            </div>

            <!-- Production Details Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
              <div class="bg-white/70 rounded-lg p-4 border border-slate-200">
                <div class="flex items-center gap-2 font-semibold text-slate-700 mb-2">
                  💼 <span>Production Fee:</span>
                </div>
                <div class="text-orange-600 font-mono text-lg font-bold">
                  <%= if recipe_spec && recipe_spec.production_fee do %>
                    <%= ViewHelpers.format_number_with_commas(recipe_spec.production_fee) %>
                  <% else %>
                    <span class="text-slate-400">N/A</span>
                  <% end %>
                </div>
              </div>

              <div class="bg-white/70 rounded-lg p-4 border border-slate-200">
                <div class="flex items-center gap-2 font-semibold text-slate-700 mb-2">
                  📦 <span>Production Amount:</span>
                </div>
                <div class="text-purple-600 font-mono text-lg font-bold">
                  <%= if recipe_spec && recipe_spec.production_amount do %>
                    <%= recipe_spec.production_amount %>
                  <% else %>
                    <span class="text-slate-400">N/A</span>
                  <% end %>
                </div>
              </div>
            </div>
            <!-- Materials Section -->
            <div class="bg-white/70 rounded-lg p-4 border border-slate-200">
              <div class="flex items-center gap-2 font-semibold text-slate-700 mb-4">
                🧱 <span>Required Materials:</span>
              </div>
              <div class="space-y-3">
              <%= for material_info <- materials do %>
                <% material = material_info.item %>
                <% amount = material_info.amount %>
                  <div class="flex justify-between items-center bg-gradient-to-r from-emerald-50 to-teal-50 border border-emerald-200 px-4 py-3 rounded-lg shadow-sm hover:shadow-md transition-shadow">
                    <div class="flex items-center gap-3 text-emerald-800 font-medium">
                      <span class="bg-emerald-200 text-emerald-900 px-2 py-1 rounded-md font-bold text-sm">
                        <%= amount || "?" %>x
                      </span>
                      <span class="font-semibold"><%= material.name %></span>
                      <span class="text-emerald-600 text-sm">
                        @ <%= if material.market_price, do: ViewHelpers.format_number_with_commas(material.market_price), else: "N/A" %>
                      </span>
                    </div>
                    <span class="bg-white/80 text-emerald-800 font-mono text-sm font-bold px-3 py-1 rounded-md border border-emerald-200">
                      <%= if material.market_price && amount do %>
                        <%= ViewHelpers.format_number_with_commas(amount * material.market_price) %>
                      <% else %>
                        <span class="text-slate-400">N/A</span>
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
