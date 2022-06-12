{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE ScopedTypeVariables #-}

module CronMyLife.Persistence.Repository where

import CronMyLife.Persistence.Schema
import Data.String (IsString (fromString))
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

createUser :: Connection -> String  -> String -> IO [Only Int]
createUser conn wantedName wantedDescription = do
  let q = [r|INSERT INTO users (itemName, itemDescription) VALUES (?, ?) RETURNING id;|]
  query conn q (wantedName, wantedDescription)

createSchedule :: Connection -> String -> String -> IO [Only Int]
createSchedule conn wantedName wantedDescription = do
  let q = [r|INSERT INTO schedules (itemName, itemDescription) VALUES (?, ?) RETURNING id;|]
  query conn q (wantedName, wantedDescription)