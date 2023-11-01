defmodule PortuPrep.Material do
  import Ecto.Query, warn: false
  alias PortuPrep.Repo

  alias PortuPrep.Material.Category
  alias PortuPrep.Material.Topic
  alias PortuPrep.Material.Question


  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Topic does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category!(%{field: value})
      %Category{}

      iex> create_category!(%{field: bad_value})
      Raises `Ecto.Changeset` error

  """
  def create_category!(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Returns the list of topics.

  ## Examples

      iex> list_topics_by_category()
      [%Topic{}, ...]

  """
  def list_topics_by_category(category) do
    category
    |> Ecto.assoc(:topics)
    |> Repo.all
  end

  # List topics ordered by name and returns a list of tuples
  # with the topic name and id
  def list_topics_by_name do
    Repo.all(from t in Topic, order_by: [asc: t.name], select: {t.name, t.id})
  end

  @doc """
  Returns the list of questions from a topic.

  ## Examples

      iex> list_questions_by_topic(topic)
      [%Question{}, ...]

  """
  def list_questions_by_topic(%Topic{} = topic) do
    topic
    |> Ecto.assoc(:questions)
    |> Repo.all
  end

  @doc """
  Gets a single topic.

  Raises `Ecto.NoResultsError` if the Topic does not exist.

  ## Examples

      iex> get_topic!(123)
      %Topic{}

      iex> get_topic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_topic!(id), do: Repo.get!(Topic, id)

  @doc """
  Creates a topic.

  ## Examples

      iex> create_topic!(%{field: value})
      %Topic{}

      iex> create_topic!(%{field: bad_value})
      Raises `Ecto.Changeset` error

  """
  def create_topic!(attrs \\ %{}) do
    %Topic{}
    |> Topic.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Creates a question.

  ## Examples

      iex> create_question(%{field: value})
      {:ok, %Question{}}

      iex> create_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question(attrs \\ %{}) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end
end
