CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" INTEGER PRIMARY KEY, "inserted_at" TEXT);
CREATE TABLE IF NOT EXISTS "topics" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "name" TEXT NOT NULL, "description" TEXT NOT NULL, "inserted_at" TEXT NOT NULL, "updated_at" TEXT NOT NULL);
CREATE TABLE sqlite_sequence(name,seq);
CREATE UNIQUE INDEX "topics_name_index" ON "topics" ("name");
CREATE TABLE IF NOT EXISTS "questions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "topic_id" INTEGER NOT NULL CONSTRAINT "questions_topic_id_fkey" REFERENCES "topics"("id") ON DELETE CASCADE, "problem" TEXT NOT NULL, "answer" TEXT NOT NULL, "inserted_at" TEXT NOT NULL, "updated_at" TEXT NOT NULL);
CREATE INDEX "questions_topic_id_index" ON "questions" ("topic_id");
INSERT INTO schema_migrations VALUES(20231025023712,'2023-10-25T02:42:10');
INSERT INTO schema_migrations VALUES(20231025023821,'2023-10-25T02:42:10');
