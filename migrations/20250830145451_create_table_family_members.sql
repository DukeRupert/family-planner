-- +goose Up
-- +goose StatementBegin
CREATE TABLE family_members (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)), 2) || '-' || substr('ab89', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)), 2) || '-' || hex(randomblob(6)))),
    name TEXT NOT NULL,
    email TEXT UNIQUE,
    role TEXT CHECK (role IN ('parent', 'child', 'guardian', 'other')),
    color_preference TEXT CHECK (length(color_preference) = 7 AND color_preference LIKE '#%'),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Trigger to auto-update updated_at
CREATE TRIGGER update_family_members_updated_at 
    AFTER UPDATE ON family_members
BEGIN
    UPDATE family_members SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TRIGGER IF EXISTS update_family_members_updated_at;
DROP TABLE IF EXISTS family_members;
-- +goose StatementEnd
