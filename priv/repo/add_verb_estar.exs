alias PortuPrep.Repo
alias PortuPrep.Questions.Question
alias PortuPrep.Topics.Topic

require Logger
require CSV

name = "Estar - Presente"
description = "Questions related to the verb \"estar\", which is the verb \"to be\" for temporary situations."

topic = case Repo.get_by(Topic, name: name) do
  nil ->
    Logger.info("Creating topic: #{name}")

    %Topic{}
    |> Ecto.Changeset.change(name: name, description: description)
    |> Repo.insert!()

  topic ->
    topic
end

"./datasets/verb_estar.csv"
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
