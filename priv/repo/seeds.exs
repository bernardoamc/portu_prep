# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

alias PortuPrep.Repo
alias PortuPrep.Questions.Question
alias PortuPrep.Topics.Topic

require Logger
require CSV

topics = %{
  "verb_estar.csv" => %{
    name: "Estar - Presente",
    description: "Questions related to the verb \"estar\", which is the verb \"to be\" for temporary situations."
  },
  "verb_ser.csv" => %{
    name: "Ser - Presente",
    description: "Questions related to the verb \"ser\", which is the verb \"to be\" for permanent situations."
  }
}

Enum.each(topics, fn {filename, %{name: name} = topic_attrs} ->
  slug = Slugy.slugify(name)

  case Repo.get_by(Topic, slug: slug) do
    nil ->
      Logger.info("Creating topic: #{name}")
      topic = %Topic{} |> Ecto.Changeset.change(Map.put_new(topic_attrs, :slug, slug)) |> Repo.insert!()

      "./datasets/#{filename}"
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

    topic ->
      Logger.info("Topics already exists: #{topic.name}")
  end
end)
