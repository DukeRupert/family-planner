-- +goose Up
-- +goose StatementBegin
CREATE TABLE lists (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)), 2) || '-' || substr('ab89', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)), 2) || '-' || hex(randomblob(6)))),
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('todo', 'grocery', 'shopping', 'notes', 'chores', 'other')),
    description TEXT,
    owner_id TEXT REFERENCES family_members(id),
    is_shared INTEGER DEFAULT 0 CHECK (is_shared IN (0, 1)),
    archived INTEGER DEFAULT 0 CHECK (archived IN (0, 1)),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER update_lists_updated_at 
    AFTER UPDATE ON lists
BEGIN
    UPDATE lists SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE INDEX idx_lists_owner_id ON lists(owner_id);
CREATE INDEX idx_lists_type ON lists(type);
CREATE INDEX idx_lists_archived ON lists(archived);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TRIGGER IF EXISTS update_lists_updated_at;
DROP INDEX IF EXISTS idx_lists_owner_id;
DROP INDEX IF EXISTS idx_lists_type;
DROP INDEX IF EXISTS idx_lists_archived;
DROP TABLE IF EXISTS lists;
-- +goose StatementEnd
