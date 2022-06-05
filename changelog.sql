-- Run the following SQL snippet as a DB superuser

create role cronmylife_role with createdb login password 'cronmylife_role';
create database cronmylife_role with owner=cronmylife_role;

CREATE TABLE activities (
    id BIGSERIAL PRIMARY KEY,
    startInstant NUMERIC NOT NULL,
    durationSeconds NUMERIC NOT NULL
);

CREATE TABLE activityCategories (
    id BIGSERIAL PRIMARY KEY,
    categoryName VARCHAR(255) NOT NULL,
    categoryIcon VARCHAR(255) NOT NULL
);

CREATE TABLE activitiesActivityCategories (
    activityId BIGINT NOT NULL,
    activityCategoryId BIGINT NOT NULL,
    CONSTRAINT activityIdFk
        FOREIGN KEY(activityId) 
        REFERENCES activities(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT activityCategoryIdFk
        FOREIGN KEY(activityCategoryId) 
        REFERENCES activityCategories(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

