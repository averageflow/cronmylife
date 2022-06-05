
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE DefaultSignatures #-}


module CronMyLife.Lib where

import CronMyLife.Model
import Data.Map hiding (map)
import CronMyLife.Repository.Opaleye
import Data.Int (Int64)
import qualified Data.Map as Map hiding (map)
import Data.Aeson (encode)
import Data.ByteString.Lazy (toStrict)
import Opaleye

import Prelude hiding (sum)
import Data.Int
import Data.Time.Clock.POSIX
import Data.Profunctor.Product.Default


getMockActivity :: Int64 -> Activity
getMockActivity now =
  Activity
    "Haskell Practice"
    [ActivityLocation "N 52° 30' 41.859''" "E 4° 56' 29.791''" "Home" ""]
    [ActivityCategory "Perfecting skills" "", ActivityCategory "Computer" ""]
    (ActivityTimeFrame 3600 now)

getMockCentralSchedulerData :: [Int] -> Int64 -> ApplicationState
getMockCentralSchedulerData xs now =
  ApplicationState
    "Joe"
    ( fromList
        [ (now + 1, [getMockActivity $ now + 1]),
          (now + 2, [getMockActivity $ now + 2])
        ]
    )



startApplication = do
  now <- round `fmap` getPOSIXTime

  let fakeData = scheduleData (getMockCentralSchedulerData [1, 2] now)

  conn <- getDbConn

  insertResult <- runInsert conn (insertActivities [(ActivityEntity Nothing 1 1 Nothing)])

  print insertResult

  findResult ::[ActivityEntityFieldRead] <- runSelect conn findAllActivities

  print(findResult)




printSql :: Default Unpackspec a a => Select a -> IO ()
printSql = putStrLn . maybe "Empty select" id . showSql