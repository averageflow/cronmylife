
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE MultiParamTypeClasses #-}

{-# LANGUAGE TypeFamilies #-}


module CronMyLife.Lib where

import CronMyLife.Model
import Data.Map hiding (map)
import CronMyLife.Repository.Opaleye
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

getMockCentralSchedulerData :: [Int] -> Int64 -> ApplicationState
getMockCentralSchedulerData xs now =
  CentralSchedulerData
    "Joe"
    ( fromList
        [ (now + 1, [getMockActivity $ now + 1]),
          (now + 2, [getMockActivity $ now + 2])
        ]
    )



startApplication :: IO ()
startApplication = do
  -- by default show agenda in CLI
  -- showCentralSchedulerDataConsole scheduleData
  -- by default store state in JSON file
  -- storeScheduleStateJSONFile scheduleData
  now <- round `fmap` getPOSIXTime

  let fakeData = scheduleData (getMockCentralSchedulerData [1, 2] now)
  

  -- conn <- open "cronmylife.db"
  -- CronMyLife.Repository.Opaleye.save conn t

  -- CronMyLife.Repository.Opaleye.find conn t
  print fakeData

