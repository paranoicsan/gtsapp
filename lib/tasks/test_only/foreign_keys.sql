DROP TABLE "companies";
PRAGMA foreign_keys=ON;
BEGIN TRANSACTION;
CREATE TABLE "companies" (
	"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	"title" varchar(255),
	"date_added" date,
	"rubricator" integer,
	"created_at" datetime,
	"updated_at" datetime,
	"company_status_id" integer,
	"author_user_id" integer NOT NULL,
	"editor_user_id" integer NOT NULL,
	"company_source_id" integer,
	"agent_id" integer,
	"comments" varchar(255),
	"reason_deleted_on" varchar(255),
	FOREIGN KEY(agent_id) REFERENCES users(id),
	FOREIGN KEY(editor_user_id) REFERENCES users(id) ON DELETE RESTRICT,
	FOREIGN KEY(author_user_id) REFERENCES users(id) ON DELETE RESTRICT
);
COMMIT;