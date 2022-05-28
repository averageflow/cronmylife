module Main where

import CronMyLife.Lib
import Data.Time.Clock.POSIX

-- initialize the application with mock activities
main = do
  now <- getCurrentTime -- 2022-05-28 20:36:00.976250179 UTC
  let centralSchedulerData = getMockCentralSchedulerData [1 .. 20] now

  startApplication centralSchedulerData
