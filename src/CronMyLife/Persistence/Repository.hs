{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module CronMyLife.Persistence.Repository where
import System.IO
import Database.PostgreSQL.Simple
import Data.String (IsString(fromString))
import Data.Int
-- setupDatabaseSchema
--  createUser :: all required details -> INT64
--  getUser :: INT64 -> user details

q :: Query
q = "select ?"

-- getSchedulesForUser :: INT64 -> scheduleIDs
-- getSchedule :: INT64 -> timeperiod -> schedule data between certain time period
localPG :: ConnectInfo
localPG = defaultConnectInfo
        { connectHost = "127.0.0.1"
        , connectDatabase = "cronmylife"
        , connectUser = "atp"
        , connectPassword = "atp"
        }

setupConn :: IO Connection
setupConn = do
    conn <- connect localPG
    pure (conn)

setupDatabaseSchema :: Connection -> IO ()
setupDatabaseSchema conn = do
    handle <- openFile "resources/sql/changelog.sql" ReadMode
    contents <- hGetContents handle
    _ <- execute conn (fromString contents) ()
    hClose handle
    putStrLn ""

createUser :: Connection -> String -> IO [Only Int]
createUser conn wantedName = do
    let q = "INSERT INTO users (itemName) VALUES (?) RETURNING id;" 
    query conn q (Only wantedName)
