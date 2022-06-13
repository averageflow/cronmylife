{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE ScopedTypeVariables #-}

module CronMyLife.Persistence.Repository where

import CronMyLife.Persistence.Schema
import Data.Int
import Data.String 
import Data.Time 
import Database.PostgreSQL.Simple
import Text.RawString.QQ
import Database.PostgreSQL.Simple.Time (ZonedTimestamp, LocalTimestamp)

--  getUser :: INT64 -> user details

-- getSchedulesForUser :: INT64 -> scheduleIDs
-- getSchedule :: INT64 -> timeperiod -> schedule data between certain time period
localPG :: ConnectInfo
localPG =
  defaultConnectInfo
    { connectHost = "127.0.0.1",
      connectDatabase = "cronmylife",
      connectUser = "atp",
      connectPassword = "atp"
    }

setupConn :: IO Connection
setupConn = do
  connect localPG

setupDatabaseSchema :: Connection -> IO ()
setupDatabaseSchema conn = withTransaction conn $ do
  mapM_ (\x -> execute conn (fromString x) ()) ddlStatements
  putStrLn "Successfully setup database schema!"
  where
    ddlStatements =
      [ createUsersTableStmt,
        createSchedulesTableStmt,
        createUserToScheduleRelationTableStmt,
        createCategoriesTableStmt,
        createActivitiesTableStmt,
        createActivityToCategoryRelationTableStmt,
        createLocationsTableStmt,
        createActivityToLocationTableStmt
      ]

createUser :: Connection -> String -> String -> IO [Only Int64]
createUser conn wantedName wantedDescription = withTransaction conn $ do
  let q = [r|INSERT INTO users (itemName, itemDescription) VALUES (?, ?) RETURNING id;|]
  query conn q (wantedName, wantedDescription)

createSchedule :: Connection -> Int64 -> String -> String -> IO [Only Int64]
createSchedule conn userId wantedName wantedDescription = withTransaction conn $ do
  let q = [r|
  WITH insertedSchedule AS (
    INSERT INTO schedules (itemName, itemDescription) VALUES (?, ?) RETURNING id
  )
  INSERT INTO usersSchedules (userId, scheduleId) 
    VALUES(?, (SELECT id FROM insertedSchedule)) 
    RETURNING (SELECT id FROM insertedSchedule);
  |]
  query conn q (wantedName, wantedDescription, userId)

getUserSchedules :: Connection -> Int64 -> IO [(Int64,String, String, LocalTimestamp)]
getUserSchedules conn userId = do
  let q = [r|
  SELECT schedules.id, schedules.itemName, schedules.itemDescription, schedules.createdAt 
  FROM (
    usersSchedules 
    INNER JOIN schedules ON usersSchedules.scheduleId = schedules.Id
  )
  WHERE userId = ?;
  |]
  query conn q (Only userId)

getScheduleById :: Connection -> Int64 -> IO [(Int64, String, String, LocalTimestamp, Int64, String, String, Int64, LocalTimestamp)]
getScheduleById conn scheduleId = do
  let q =
        [r|
    SELECT schedules.id,
        schedules.itemName,
        schedules.itemDescription,
        schedules.createdAt,
        activities.id,
        activities.itemName,
        activities.itemDescription,
        activities.durationSeconds,
        activities.createdAt
    FROM (
            schedules
            INNER JOIN usersSchedules ON schedules.id = usersSchedules.scheduleId
            INNER JOIN users ON usersSchedules.userId = users.id
            INNER JOIN activities ON schedules.id = activities.scheduleId
        )
    WHERE schedules.id = ?;
  |]
  query conn q (Only scheduleId)