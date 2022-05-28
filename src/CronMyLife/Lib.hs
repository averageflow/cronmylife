module CronMyLife.Lib where

import CronMyLife.Model
import CronMyLife.Presentation
import Data.Map
import Data.Time ( UTCTime )
import CronMyLife.Persistence ( storeScheduleStateJSONFile )

getMockActivity :: UTCTime -> Activity
getMockActivity now =
  Activity
    "Haskell Practice"
    (ActivityLocation "N 52° 30' 41.859''" "E 4° 56' 29.791''" "Home")
    [ActivityCategory "Perfecting skills", ActivityCategory "Computer"]
    (ActivityTimeFrame 3600 now)

getMockCentralSchedulerData :: [Int] -> UTCTime -> CentralSchedulerData
getMockCentralSchedulerData xs now =
  CentralSchedulerData
    "Joe"
    ( fromList
        [ (show now, getMockActivity now),
          ("2022-05-28 20:36:00.976250179 UTC", getMockActivity now)
        ]
    )

startApplication :: CentralSchedulerData -> IO ()
startApplication scheduleData = do
    -- by default show agenda in CLI
    showCentralSchedulerDataConsole scheduleData
    -- by default store state in JSON file
    storeScheduleStateJSONFile scheduleData