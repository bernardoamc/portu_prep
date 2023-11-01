defmodule GlobalSetup do
  alias PortuPrep.Repo
  alias PortuPrep.Material
  alias PortuPrep.Material.Category
  alias PortuPrep.Material.Topic

  require Logger
  require CSV

  def run(fixtures_path \\ "../priv/repo/datasets") do
    categories = [
      %{
        name: "Verbs - Present Tense",
        description: "Questions related to the present tense conjugation of common verbs.",
        topics: %{
          "present/verb_estar.csv" => %{
            name: "Estar - Present",
            description: "Questions related to the verb \"estar\", which is the verb \"to be\" for temporary situations."
          },
          "present/verb_ser.csv" => %{
            name: "Ser - Present",
            description: "Questions related to the verb \"ser\", which is the verb \"to be\" for permanent situations."
          },
          "present/verb_fazer.csv" => %{
            name: "Fazer - Present",
            description: "Questions related to the verb \"fazer\", which is the verb \"to do\"."
          },
          "present/verb_saber.csv" => %{
            name: "Saber - Present",
            description: "Questions related to the verb \"saber\", which is the verb \"to know\"."
          },
          "present/verb_ir.csv" => %{
            name: "Ir - Present",
            description: "Questions related to the verb \"ir\", which is the verb \"to go\"."
          },
          "present/verb_vir.csv" => %{
            name: "Vir - Present",
            description: "Questions related to the verb \"vir\", which is the verb \"to come\"."
          },
          "present/verb_ver.csv" => %{
            name: "Ver - Present",
            description: "Questions related to the verb \"ver\", which is the verb \"to see\"."
          },
          "present/verb_ter.csv" => %{
            name: "Ter - Present",
            description: "Questions related to the verb \"ter\", which is the verb \"to have\"."
          },
          "present/verb_querer.csv" => %{
            name: "Querer - Present",
            description: "Questions related to the verb \"querer\", which is the verb \"to want\"."
          },
          "present/verb_por.csv" => %{
            name: "Por - Present",
            description: "Questions related to the verb \"por\", which is the verb \"to put\"."
          },
          "present/verb_trazer.csv" => %{
            name: "Trazer - Present",
            description: "Questions related to the verb \"trazer\", which is the verb \"to bring\"."
          },
          "present/verb_poder.csv" => %{
            name: "Poder - Present",
            description: "Questions related to the verb \"poder\", which is \"to be able to\"."
          },
        }
      },
      %{
        name: "Verbs - Past Tense",
        description: "Questions related to the past tense conjugation of common verbs.",
        topics: %{
          "past/verb_fazer.csv" => %{
            name: "Fazer - Past",
            description: "Questions related to the verb \"fazer\", which is the verb \"to do\"."
          },
          "past/verb_saber.csv" => %{
            name: "Saber - Past",
            description: "Questions related to the verb \"saber\", which is the verb \"to know\"."
          },
          "past/verb_ir.csv" => %{
            name: "Ir - Past",
            description: "Questions related to the verb \"ir\", which is the verb \"to go\"."
          },
          "past/verb_vir.csv" => %{
            name: "Vir - Past",
            description: "Questions related to the verb \"vir\", which is the verb \"to come\"."
          },
          "past/verb_ver.csv" => %{
            name: "Ver - Past",
            description: "Questions related to the verb \"ver\", which is the verb \"to see\"."
          },
          "past/verb_ter.csv" => %{
            name: "Ter - Past",
            description: "Questions related to the verb \"ter\", which is the verb \"to have\"."
          },
          "past/verb_querer.csv" => %{
            name: "Querer - Past",
            description: "Questions related to the verb \"querer\", which is the verb \"to want\"."
          },
          "past/verb_por.csv" => %{
            name: "Por - Past",
            description: "Questions related to the verb \"por\", which is the verb \"to put\"."
          },
          "past/verb_trazer.csv" => %{
            name: "Trazer - Past",
            description: "Questions related to the verb \"trazer\", which is the verb \"to bring\"."
          },
          "past/verb_poder.csv" => %{
            name: "Poder - Past",
            description: "Questions related to the verb \"poder\", which is \"to be able to\"."
          },
          "past/verb_ficar.csv" => %{
            name: "Ficar - Past",
            description: "Questions related to the verb \"ficar\", which is \"to stay\"."
          },
          "past/verb_dar.csv" => %{
            name: "Dar - Past",
            description: "Questions related to the verb \"dar\", which is \"to give\"."
          },
          "past/verb_ser.csv" => %{
            name: "Ser - Past",
            description: "Questions related to the verb \"ser\", which is the verb \"to be\" for permanent situations."
          },
          "past/verb_estar.csv" => %{
            name: "Estar - Past",
            description: "Questions related to the verb \"estar\", which is the verb \"to be\" for temporary situations."
          },
          "past/verb_dizer.csv" => %{
            name: "Dizer - Past",
            description: "Questions related to the verb \"dizer\", which is the verb \"to say\"."
          },
        }
      },
    ]


    Enum.each(categories, fn category_attrs ->
      create_category(category_attrs)
        |> create_topics_for_category(fixtures_path, category_attrs.topics)
    end)
  end

  def create_category(%{name: name, description: description}) do
    slug = Slugy.slugify(name)

    case Repo.get_by(Category, slug: slug) do
      nil ->
        Logger.info("Creating category: #{name}")

        %{name: name, description: description, slug: slug}
          |> Material.create_category!()

      category ->
        Logger.info("Category already exists: #{name}")
        category
    end
  end

  def create_topics_for_category(category, fixtures_path, topics_attrs) do
    Enum.each(topics_attrs, fn {filename, %{name: name} = topic_attrs} ->
      slug = Slugy.slugify(name)

      case Repo.get_by(Topic, slug: slug) do
        nil ->
          Logger.info("Creating topic: #{name}")

          %{category_id: category.id, name: topic_attrs.name, description: topic_attrs.description, slug: slug}
            |> Material.create_topic!()
            |> populate_questions_for_topic("#{fixtures_path}/#{filename}")

        topic ->
          Logger.info("Topic already exists: #{topic.name}")
      end
    end)
  end


  defp populate_questions_for_topic(topic, filename) do
    filename
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> CSV.decode(separator: ?|, headers: false)
    |> Enum.each(fn {:ok, [problem, answer]} ->
      attrs = %{topic_id: topic.id, problem: problem, answer: answer}
      case Material.create_question(attrs) do
        {:ok, _record} ->
          Logger.info("Entry inserted: #{problem} | #{answer}")
        {:error, changeset} ->
          Logger.error("Failed to insert entry: #{problem} | #{answer}. Errors: #{inspect(changeset.errors)}")
      end
    end)
  end
end
