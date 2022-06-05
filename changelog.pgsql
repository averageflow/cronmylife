

CREATE TABLE activities (
    id BIGSERIAL PRIMARY KEY,
    start_instant NUMERIC NOT NULL,
    duration_seconds NUMERIC NOT NULL,
    created_at timestamp with time zone not null default current_timestamp
);

CREATE TABLE activity_categories (
    id BIGSERIAL PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL,
    category_icon VARCHAR(255) NOT NULL,
    created_at timestamp with time zone not null default current_timestamp
);

CREATE TABLE activities_activity_categories (
    activity_id BIGINT NOT NULL,
    activity_category_id BIGINT NOT NULL,
    CONSTRAINT activity_id_fk
        FOREIGN KEY(activity_id) 
        REFERENCES activities(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT activity_category_id_fk
        FOREIGN KEY(activity_category_id) 
        REFERENCES activity_categories(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

