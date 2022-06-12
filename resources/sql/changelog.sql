-- Creating the table for the schedules
CREATE TABLE IF NOT EXISTS schedules (
    id BIGSERIAL PRIMARY KEY,
    itemName VARCHAR(255) NOT NULL,
    itemDescription TEXT,
    itemIcon TEXT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP,
    deletedAt TIMESTAMP
);

-- Creating the table for the users
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    itemName VARCHAR(255) NOT NULL,
    itemDescription TEXT,
    itemIcon TEXT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP,
    deletedAt TIMESTAMP
);

-- Creating the table for the user relation with schedules
CREATE TABLE IF NOT EXISTS usersSchedules (
    userId BIGINT NOT NULL,
    scheduleId BIGINT NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP,
    deletedAt TIMESTAMP,
    CONSTRAINT userIdFk FOREIGN KEY(userId) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT scheduleIdFk FOREIGN KEY(scheduleId) REFERENCES schedules(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Creating the table for the categories of activities
CREATE TABLE IF NOT EXISTS categories (
    id BIGSERIAL PRIMARY KEY,
    itemName VARCHAR (255) NOT NULL,
    itemIcon TEXT,
    itemDescription TEXT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP,
    deletedAt TIMESTAMP
);

-- Creating the table for the activities
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
    CONSTRAINT activityscheduleIdFk FOREIGN KEY(scheduleId) REFERENCES schedules(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Creating the table for the activities relation with categories
CREATE TABLE IF NOT EXISTS activityCategories (
    
    activityId BIGINT NOT NULL,
    categoryId BIGINT NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP,
    deletedAt TIMESTAMP,
    CONSTRAINT activityIdFk FOREIGN KEY(activityId) REFERENCES activities(id) ON DELETE CASCADE ON UPDATE CASCADE, 
    CONSTRAINT categoryIdFk FOREIGN KEY(categoryId) REFERENCES categories(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Creating the table for the activity locations
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

-- Creating the table for the activities relation with locations
CREATE TABLE IF NOT EXISTS activityLocations (
    activityId BIGINT NOT NULL,
    locationId BIGINT NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP,
    deletedAt TIMESTAMP,
    CONSTRAINT activityLocationsIdFk FOREIGN KEY(activityId) REFERENCES activities(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT locationIdFk FOREIGN KEY(locationId) REFERENCES locations(id) ON DELETE CASCADE ON UPDATE CASCADE
);