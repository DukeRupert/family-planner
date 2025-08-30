-- +goose Up
-- +goose StatementBegin
CREATE TABLE list_sharing (
    list_id TEXT NOT NULL REFERENCES lists(id) ON DELETE CASCADE,
    member_id TEXT NOT NULL REFERENCES family_members(id) ON DELETE CASCADE,
    permission TEXT CHECK (permission IN ('view', 'edit', 'admin')) DEFAULT 'view',
    PRIMARY KEY (list_id, member_id)
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS list_sharing;
-- +goose StatementEnd
