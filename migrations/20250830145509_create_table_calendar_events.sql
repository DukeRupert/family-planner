-- +goose Up
-- +goose StatementBegin
CREATE TABLE calendar_events (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)), 2) || '-' || substr('ab89', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)), 2) || '-' || hex(randomblob(6)))),
    title TEXT NOT NULL,
    description TEXT,
    start_datetime DATETIME NOT NULL,
    end_datetime DATETIME,
    all_day INTEGER DEFAULT 0 CHECK (all_day IN (0, 1)),
    location TEXT,
    category TEXT CHECK (category IN ('appointment', 'school', 'work', 'family', 'personal', 'other')) DEFAULT 'personal',
    priority TEXT CHECK (priority IN ('low', 'medium', 'high')) DEFAULT 'medium',
    recurrence_rule TEXT,
    created_by TEXT REFERENCES family_members(id),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER update_calendar_events_updated_at 
    AFTER UPDATE ON calendar_events
BEGIN
    UPDATE calendar_events SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE INDEX idx_events_start_datetime ON calendar_events(start_datetime);
CREATE INDEX idx_events_created_by ON calendar_events(created_by);
CREATE INDEX idx_events_category ON calendar_events(category);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TRIGGER IF EXISTS update_calendar_events_updated_at;
DROP INDEX IF EXISTS idx_events_start_datetime;
DROP INDEX IF EXISTS idx_events_created_by;
DROP INDEX IF EXISTS idx_events_category;
DROP TABLE IF EXISTS calendar_events;
-- +goose StatementEnd
