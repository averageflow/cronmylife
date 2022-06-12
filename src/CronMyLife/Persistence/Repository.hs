{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE ScopedTypeVariables #-}

module CronMyLife.Persistence.Repository where

import CronMyLife.Persistence.Schema
import Data.Int
import Data.String (IsString (fromString))
import Data.Time (UTCTime)
import Database.PostgreSQL.Simple
import Text.RawString.QQ

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

createSchedule :: Connection -> String -> String -> IO [Only Int64]
createSchedule conn wantedName wantedDescription = withTransaction conn $ do
  let q = [r|INSERT INTO schedules (itemName, itemDescription) VALUES (?, ?) RETURNING id;|]
  query conn q (wantedName, wantedDescription)

getUserScheduleIds :: Connection -> Int64 -> IO [(Int64, Int64, UTCTime)]
getUserScheduleIds conn userId = do
  let q = [r|SELECT userId, scheduleId, createdAt FROM usersSchedules WHERE userId = ?|]
  query conn q (Only userId)

getScheduleById :: Connection -> Int64 -> IO [(Int64, String, String, UTCTime, Int64, String, String, Int64, UTCTime)]
getScheduleById conn scheduleId = do
  let q =
        [r|
SELECT  schedules.id, 
          schedules.itemName, 
          schedules.itemDescription, 
          schedules.createdAt,
          activities.id,
          activities.itemName,
          activities.itemDescription,
          activities.durationSeconds,
          activities.createdAt
  FROM schedules 
    INNER JOIN usersSchedules ON usersSchedules.scheduleId = schedules.id
    INNER JOIN users ON usersSchedules.userId = users.id
    INNER JOIN activities ON activities.scheduleId = schedules.id
  WHERE schedules.id = ?;
  |]
  query conn q (Only scheduleId)