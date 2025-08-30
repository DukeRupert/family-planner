-- +goose Up
-- +goose StatementBegin
CREATE TABLE notifications (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)), 2) || '-' || substr('ab89', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)), 2) || '-' || hex(randomblob(6)))),
    recipient_id TEXT NOT NULL REFERENCES family_members(id),
    type TEXT NOT NULL CHECK (type IN ('event_reminder', 'task_due', 'list_shared', 'event_invite', 'other')),
    title TEXT NOT NULL,
    message TEXT,
    reference_id TEXT,
    reference_type TEXT CHECK (reference_type IN ('event', 'list_item', 'list', 'other')),
    scheduled_for DATETIME,
    sent_at DATETIME,
    read_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_notifications_recipient ON notifications(recipient_id);
CREATE INDEX idx_notifications_scheduled ON notifications(scheduled_for);
CREATE INDEX idx_notifications_type ON notifications(type);
CREATE INDEX idx_notifications_read_at ON notifications(read_at);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP INDEX IF EXISTS idx_notifications_recipient;
DROP INDEX IF EXISTS idx_notifications_scheduled;
DROP INDEX IF EXISTS idx_notifications_type;
DROP INDEX IF EXISTS idx_notifications_read_at;
DROP TABLE IF EXISTS notifications;
-- +goose StatementEnd
