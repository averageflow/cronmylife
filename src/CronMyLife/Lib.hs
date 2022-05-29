
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE MultiParamTypeClasses #-}

{-# LANGUAGE TypeFamilies #-}


module CronMyLife.Lib where

import CronMyLife.Model
import Data.Map hiding (map)
import Database.SQLite.Simple
import Database.Beam.Sqlite
import Database.Beam
import CronMyLife.Repository.Beam
import Data.Int (Int64)
import qualified Data.Map as Map hiding (map)
import Data.Aeson (encode)
import Data.ByteString.Lazy (toStrict)
import Data.Time.Clock.POSIX

getMockActivity :: Int64 -> Activity
getMockActivity now =
  Activity
    "Haskell Practice"
    (ActivityLocation "N 52° 30' 41.859''" "E 4° 56' 29.791''" "Home")
    [ActivityCategory "Perfecting skills", ActivityCategory "Computer"]
    (ActivityTimeFrame 3600 now)

getMockCentralSchedulerData :: [Int] -> Int64 -> CentralSchedulerData
getMockCentralSchedulerData xs now =
  CentralSchedulerData
    "Joe"
    ( fromList
        [ (now + 1, [getMockActivity $ now + 1]),
          (now + 2, [getMockActivity $ now + 2])
        ]
    )

modelToPersistentEntity :: Activity -> ScheduleItem
modelToPersistentEntity x = do
  let encoded = encode x
  ScheduleItem 
    (activityTimeFrameStartInstant . activityTimeFrame $ x)  
    (activityTimeFrameDurationInSeconds . activityTimeFrame $ x)
    (show $ toStrict encoded)

startApplication :: IO ()
startApplication = do
  -- by default show agenda in CLI
  -- showCentralSchedulerDataConsole scheduleData
  -- by default store state in JSON file
  -- storeScheduleStateJSONFile scheduleData
  now <- round `fmap` getPOSIXTime

  let fakeData = scheduleData (getMockCentralSchedulerData [1..20] now)
  let t = map modelToPersistentEntity (concatMap snd $ Map.toList fakeData)

  conn <- open "cronmylife.db"
  {- for debug output -}
  runBeamSqliteDebug putStrLn conn $
    runInsert $
      Database.Beam.insert (_scheduleItems scheduleDb) $
          insertValues t
