-- +goose Up
-- +goose StatementBegin
CREATE TABLE activity_log (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)), 2) || '-' || substr('ab89', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)), 2) || '-' || hex(randomblob(6)))),
    actor_id TEXT REFERENCES family_members(id),
    action TEXT NOT NULL CHECK (action IN ('created', 'updated', 'completed', 'deleted', 'shared', 'invited')),
    entity_type TEXT NOT NULL CHECK (entity_type IN ('event', 'list', 'list_item', 'family_member')),
    entity_id TEXT NOT NULL,
    details TEXT, -- JSON string for SQLite
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_activity_log_actor ON activity_log(actor_id);
CREATE INDEX idx_activity_log_entity ON activity_log(entity_type, entity_id);
CREATE INDEX idx_activity_log_created_at ON activity_log(created_at);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP INDEX IF EXISTS idx_activity_log_actor;
DROP INDEX IF EXISTS idx_activity_log_entity;
DROP INDEX IF EXISTS idx_activity_log_created_at;
DROP TABLE IF EXISTS activity_log;
-- +goose StatementEnd
