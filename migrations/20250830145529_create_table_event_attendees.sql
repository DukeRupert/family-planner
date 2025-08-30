-- +goose Up
-- +goose StatementBegin
CREATE TABLE event_attendees (
    event_id TEXT NOT NULL REFERENCES calendar_events(id) ON DELETE CASCADE,
    member_id TEXT NOT NULL REFERENCES family_members(id) ON DELETE CASCADE,
    status TEXT CHECK (status IN ('pending', 'accepted', 'declined')) DEFAULT 'pending',
    PRIMARY KEY (event_id, member_id)
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS event_attendees;
-- +goose StatementEnd
