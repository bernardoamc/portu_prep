# PortuPrep

PortuPrep is a web application that helps you learn the basics of the Portuguese language. It is built with Elixir and Phoenix.

The entire application is built around two main concepts: **topics** and **questions**. A topic has many questions and a question belongs to a topic. A topic can be anything from a verb tense to a specific grammar rule. A question is a single question that the user must answer.

**topics**

- id
- name
- description

**questions**

- id
- topic_id
- problem
- answer

We also have the concept of a **submission**. A submission is a user's attempt at answering a question. A submission belongs to a question and is
only used to keep track of the user's answer in memory. A submission is not persisted to the database.

### Development

1. Make sure you have Elixir and Phoenix installed.
2. Clone the repo
3. Run `mix deps.get` to install dependencies
4. Run `mix ecto.setup` to create the database and run migrations
5. Start your Phoenix server:

  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Deploy Resources

- [Fly.io](https://fly.io)
   - [Configure sqlite3](https://fly.io/docs/elixir/advanced-guides/sqlite3/)
   - [Deploy with fly.io](https://hexdocs.pm/phoenix/fly.html)
   - [Set custom domain](https://fly.io/docs/apps/custom-domain/)

**Setting the canonical host**

- `flyctl secrets set CANONICAL_HOST=portuprep.com`

**Troubleshooting**

- `flyctl logs --app portuprep`
- `flyctl ssh console`
    - `bin/portuprep remote`

**Seeding**

- `GlobalSetup.run("../datasets")`
