{-# LANGUAGE OverloadedStrings #-}

module CronMyLife.Persistence.Repository where
import System.IO
import Database.PostgreSQL.Simple
import Data.String (IsString(fromString))
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