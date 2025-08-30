-- +goose Up
-- +goose StatementBegin
CREATE TABLE list_items (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)), 2) || '-' || substr('ab89', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)), 2) || '-' || hex(randomblob(6)))),
    list_id TEXT NOT NULL REFERENCES lists(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    completed INTEGER DEFAULT 0 CHECK (completed IN (0, 1)),
    priority TEXT CHECK (priority IN ('low', 'medium', 'high')) DEFAULT 'medium',
    assigned_to TEXT REFERENCES family_members(id),
    due_date DATE,
    notes TEXT,
    sort_order INTEGER DEFAULT 0,
    completed_at DATETIME,
    completed_by TEXT REFERENCES family_members(id),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER update_list_items_updated_at 
    AFTER UPDATE ON list_items
BEGIN
    UPDATE list_items SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Trigger to set completed_at when item is completed
CREATE TRIGGER set_list_item_completed_at 
    AFTER UPDATE OF completed ON list_items
    WHEN NEW.completed = 1 AND OLD.completed = 0
BEGIN
    UPDATE list_items SET completed_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Trigger to clear completed_at when item is uncompleted
CREATE TRIGGER clear_list_item_completed_at 
    AFTER UPDATE OF completed ON list_items
    WHEN NEW.completed = 0 AND OLD.completed = 1
BEGIN
    UPDATE list_items SET completed_at = NULL WHERE id = NEW.id;
END;

CREATE INDEX idx_list_items_list_id ON list_items(list_id);
CREATE INDEX idx_list_items_assigned_to ON list_items(assigned_to);
CREATE INDEX idx_list_items_due_date ON list_items(due_date);
CREATE INDEX idx_list_items_completed ON list_items(completed);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TRIGGER IF EXISTS update_list_items_updated_at;
DROP TRIGGER IF EXISTS set_list_item_completed_at;
DROP TRIGGER IF EXISTS clear_list_item_completed_at;
DROP INDEX IF EXISTS idx_list_items_list_id;
DROP INDEX IF EXISTS idx_list_items_assigned_to;
DROP INDEX IF EXISTS idx_list_items_due_date;
DROP INDEX IF EXISTS idx_list_items_completed;
DROP TABLE IF EXISTS list_items;
-- +goose StatementEnd
