defmodule PortuPrep.MaterialFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PortuPrep.Material` context.
  """

  @doc """
  Generate a topic.
  """
  def topic_fixture(attrs \\ %{}) do
    {:ok, topic} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> PortuPrep.Material.create_topic()

    topic
  end
end
