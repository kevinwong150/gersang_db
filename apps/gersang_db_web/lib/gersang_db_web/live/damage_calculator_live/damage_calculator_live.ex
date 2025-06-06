defmodule GersangDbWeb.DamageCalculatorLive do
  use GersangDbWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "ELA Calculator")
      |> assign(:my_current_ela, 0)
      |> assign(:my_new_ela_buff, 0)
      |> assign(:opponent_ela, 0)
      |> assign(:current_damage_value, 0)
      |> assign(:damage_buff, 0)
      |> assign(:results, %{
        original_damage: 100.0,
        damage_reduction_rate: 0.0,
        effective_damage: 100.0,
        effective_damage_ratio: 100.0,
        new_effective_damage_ratio: 0.0,
        damage_amplification: 0.0,
        original_damage_value: 0.0,
        new_damage_value_with_new_ela: 0.0,
        new_damage_value_with_buff: 0.0
      })

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("calculate", params, socket) do
    my_current_ela = parse_number(params["my_current_ela"] || 0)
    opponent_ela = parse_number(params["opponent_ela"] || 0)
    my_new_ela_buff = parse_number(params["my_new_ela_buff"] || my_current_ela)
    current_damage_value = parse_number(params["current_damage_value"] || 0)
    damage_buff = parse_number(params["damage_buff"] || 0)

    results =
      calculate_damage(
        my_current_ela,
        opponent_ela,
        my_new_ela_buff,
        current_damage_value,
        damage_buff
      )

    socket =
      socket
      |> assign(:my_current_ela, my_current_ela)
      |> assign(:my_new_ela_buff, my_new_ela_buff)
      |> assign(:opponent_ela, opponent_ela)
      |> assign(:current_damage_value, current_damage_value)
      |> assign(:damage_buff, damage_buff)
      |> assign(:results, results)

    {:noreply, socket}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "ELA Calculator")
  end

  # Helper function to parse string numbers, defaulting to 0 if invalid
  defp parse_number(str) when is_binary(str) do
    case Float.parse(str) do
      {num, _} ->
        num

      :error ->
        case Integer.parse(str) do
          {num, _} -> num
          :error -> 0
        end
    end
  end

  defp parse_number(num) when is_number(num), do: num
  defp parse_number(_), do: 0
  # Calculate damage based on ELAs
  defp calculate_damage(
         my_current_ela,
         opponent_ela,
         my_new_ela_buff,
         current_damage_value,
         damage_buff
       ) do
    # 原始傷害
    original_damage = 100.0 + my_current_ela

    # 傷害減少率
    damage_reduction_rate = min(90.0, abs(opponent_ela - my_current_ela) / 2.0)

    # 有效傷害
    effective_damage = original_damage - damage_reduction_rate

    # 有效傷害比率
    effective_damage_ratio = effective_damage_ratio(my_current_ela, opponent_ela)

    my_new_ela = my_new_ela_buff + my_current_ela

    # 新的有效傷害比率: This seems to be a comparison calculation
    # For now, calculate the difference from base 100%
    new_effective_damage_ratio = effective_damage_ratio(my_new_ela, opponent_ela)

    damage_amplification = ((new_effective_damage_ratio - effective_damage_ratio) / effective_damage_ratio)  * 100.0

    # Avoid division by zero or very small numbers
    original_damage_value =
      if effective_damage_ratio != 0 and current_damage_value != 0 do
        current_damage_value / (effective_damage_ratio / 100.0)
      else
        0.0
      end

    new_damage_value_with_new_ela =
      if new_effective_damage_ratio != 0 and original_damage_value != 0 do
        original_damage_value * (new_effective_damage_ratio / 100.0)
      else
        0.0
      end

    new_damage_value_with_buff =
      current_damage_value * ((100.0 + damage_buff) / 100.0)

    %{
      original_damage: format_number(original_damage),
      damage_reduction_rate: format_number(damage_reduction_rate),
      effective_damage: format_number(effective_damage),
      effective_damage_ratio: format_number(effective_damage_ratio),
      new_effective_damage_ratio: format_number(new_effective_damage_ratio),
      damage_amplification: format_number(damage_amplification),
      original_damage_value: format_number(original_damage_value),
      new_damage_value_with_new_ela: format_number(new_damage_value_with_new_ela),
      new_damage_value_with_buff: format_number(new_damage_value_with_buff)
    }
  end

  # Format numbers to avoid scientific notation
  defp format_number(num) when is_float(num) do
    cond do
      abs(num) >= 1_000_000 ->
        # For very large numbers, round to whole numbers
        :erlang.float_to_binary(num, decimals: 0)

      abs(num) >= 100 ->
        # For numbers >= 100, show 1 decimal place
        :erlang.float_to_binary(num, decimals: 1)

      true ->
        # For smaller numbers, show 2 decimal places
        :erlang.float_to_binary(num, decimals: 2)
    end
  end

  defp format_number(num), do: format_number(num * 1.0)

  def effective_damage_ratio(my_current_ela, opponent_ela) when my_current_ela >= opponent_ela do
    effective_damage_ratio = 100 + my_current_ela
    effective_damage_ratio
  end

  def effective_damage_ratio(my_current_ela, opponent_ela) do
    original_damage = 100.0 + my_current_ela
    damage_reduction_rate = max(0.0, abs(opponent_ela - my_current_ela) / 2.0)
    effective_damage = original_damage - damage_reduction_rate

    # 有效傷害比率
    effective_damage_ratio = 100 + (effective_damage - original_damage) / original_damage * 100.0
    effective_damage_ratio
  end
end
