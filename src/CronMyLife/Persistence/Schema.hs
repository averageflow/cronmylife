{-# LANGUAGE QuasiQuotes #-}

module CronMyLife.Persistence.Schema where

import Text.RawString.QQ

createSchedulesTableStmt :: [Char]
createSchedulesTableStmt =
  [r|
CREATE TABLE IF NOT EXISTS schedules (
    id BIGSERIAL PRIMARY KEY,
    itemName VARCHAR(255) NOT NULL,
    itemDescription TEXT,
    itemIcon TEXT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP,
    deletedAt TIMESTAMP
);
|]

createUsersTableStmt :: [Char]
createUsersTableStmt =
  [r|
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    itemName VARCHAR(255) NOT NULL,
    itemDescription TEXT,
    itemIcon TEXT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP,
    deletedAt TIMESTAMP
);
|]

createUserToScheduleRelationTableStmt :: [Char]
createUserToScheduleRelationTableStmt =
  [r|
CREATE TABLE IF NOT EXISTS usersSchedules (
    userId BIGINT NOT NULL,
    scheduleId BIGINT NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP,
    deletedAt TIMESTAMP,
    CONSTRAINT userIdFk 
        FOREIGN KEY(userId) 
        REFERENCES users(id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT scheduleIdFk 
        FOREIGN KEY(scheduleId) 
        REFERENCES schedules(id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);
|]

createCategoriesTableStmt :: [Char]
createCategoriesTableStmt =
  [r|
CREATE TABLE IF NOT EXISTS categories (
    id BIGSERIAL PRIMARY KEY,
    itemName VARCHAR (255) NOT NULL,
    itemIcon TEXT,
    itemDescription TEXT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP,
    deletedAt TIMESTAMP
);
|]

createActivitiesTableStmt :: [Char]
createActivitiesTableStmt =
  [r|
CREATE TABLE IF NOT EXISTS activities (
    id BIGSERIAL PRIMARY KEY,
    scheduleId BIGINT NOT NULL,
    durationSeconds BIGINT NOT NULL,
    startInstant BIGINT NOT NULL,
    itemName VARCHAR(255) NOT NULL,
    itemDescription TEXT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP,
    deletedAt TIMESTAMP,
    CONSTRAINT activityscheduleIdFk 
        FOREIGN KEY(scheduleId) 
        REFERENCES schedules(id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);
|]

createActivityToCategoryRelationTableStmt :: [Char]
createActivityToCategoryRelationTableStmt =
  [r|
CREATE TABLE IF NOT EXISTS activityCategories (
    activityId BIGINT NOT NULL,
    categoryId BIGINT NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP,
    deletedAt TIMESTAMP,
    CONSTRAINT activityIdFk 
        FOREIGN KEY(activityId) 
        REFERENCES activities(id) 
        ON DELETE CASCADE ON UPDATE CASCADE, 
    CONSTRAINT categoryIdFk 
        FOREIGN KEY(categoryId) 
        REFERENCES categories(id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);
|]

createLocationsTableStmt :: [Char]
createLocationsTableStmt =
  [r|
CREATE TABLE IF NOT EXISTS locations (
    id BIGSERIAL PRIMARY KEY,
    latitude NUMERIC NOT NULL,
    longitude NUMERIC NOT NULL,
    itemName VARCHAR(255) NOT NULL,
    itemDescription TEXT,
    mapURL TEXT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP,
    deletedAt TIMESTAMP
);
|]

createActivityToLocationTableStmt :: String
createActivityToLocationTableStmt =
  [r|
CREATE TABLE IF NOT EXISTS activityLocations (
    activityId BIGINT NOT NULL,
    locationId BIGINT NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP,
    deletedAt TIMESTAMP,
    CONSTRAINT activityLocationsIdFk FOREIGN KEY(activityId) REFERENCES activities(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT locationIdFk FOREIGN KEY(locationId) REFERENCES locations(id) ON DELETE CASCADE ON UPDATE CASCADE
);
|]