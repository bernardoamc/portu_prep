defmodule GlobalSetup do
  alias PortuPrep.Repo
  alias PortuPrep.Material.Question
  alias PortuPrep.Material.Topic

  require Logger
  require CSV

  def run(csv_folder_path \\ "../priv/repo/datasets") do
    topics = %{
      "verb_estar.csv" => %{
        name: "Estar - Presente",
        description: "Questions related to the verb \"estar\", which is the verb \"to be\" for temporary situations."
      },
      "verb_ser.csv" => %{
        name: "Ser - Presente",
        description: "Questions related to the verb \"ser\", which is the verb \"to be\" for permanent situations."
      },
      "verb_fazer.csv" => %{
        name: "Fazer - Presente",
        description: "Questions related to the verb \"fazer\", which is the verb \"to do\"."
      },
      "verb_saber.csv" => %{
        name: "Saber - Presente",
        description: "Questions related to the verb \"saber\", which is the verb \"to know\"."
      },
      "verb_ir.csv" => %{
        name: "Ir - Presente",
        description: "Questions related to the verb \"ir\", which is the verb \"to go\"."
      },
      "verb_vir.csv" => %{
        name: "Vir - Presente",
        description: "Questions related to the verb \"vir\", which is the verb \"to come\"."
      },
      "verb_ver.csv" => %{
        name: "Ver - Presente",
        description: "Questions related to the verb \"ver\", which is the verb \"to see\"."
      },
      "verb_ter.csv" => %{
        name: "Ter - Presente",
        description: "Questions related to the verb \"ter\", which is the verb \"to have\"."
      },
      "verb_querer.csv" => %{
        name: "Querer - Presente",
        description: "Questions related to the verb \"querer\", which is the verb \"to want\"."
      },
      "verb_por.csv" => %{
        name: "Por - Presente",
        description: "Questions related to the verb \"por\", which is the verb \"to put\"."
      },
      "verb_trazer.csv" => %{
        name: "Trazer - Presente",
        description: "Questions related to the verb \"trazer\", which is the verb \"to bring\"."
      },
      "verb_poder.csv" => %{
        name: "Poder - Presente",
        description: "Questions related to the verb \"poder\", which is \"to be able to\"."
      },
    }

    Enum.each(topics, fn {filename, %{name: name} = topic_attrs} ->
      slug = Slugy.slugify(name)

      case Repo.get_by(Topic, slug: slug) do
        nil ->
          Logger.info("Creating topic: #{name}")
          topic = %Topic{} |> Ecto.Changeset.change(Map.put_new(topic_attrs, :slug, slug)) |> Repo.insert!()
          populate_questions_for_topic(topic, "#{csv_folder_path}/#{filename}")

        topic ->
          Logger.info("Topics already exists: #{topic.name}")
      end
    end)
  end

  defp populate_questions_for_topic(topic, filename) do
    filename
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> CSV.decode(separator: ?|, headers: false)
    |> Enum.each(fn {:ok, [problem, answer]} ->
      changeset = Question.changeset(%Question{}, %{topic_id: topic.id, problem: problem, answer: answer})
      case Repo.insert(changeset) do
        {:ok, _record} ->
          Logger.info("Entry inserted: #{problem} | #{answer}")
        {:error, changeset} ->
          Logger.error("Failed to insert entry: #{problem} | #{answer}. Errors: #{inspect(changeset.errors)}")
      end
    end)
  end
end
