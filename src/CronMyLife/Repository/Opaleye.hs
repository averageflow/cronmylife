{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TemplateHaskell #-}

module CronMyLife.Repository.Opaleye where


import Prelude hiding (sum)

import           Opaleye 

import           Data.Profunctor.Product (p2, p3)
import           Data.Profunctor.Product.Default (Default)
import           Data.Profunctor.Product.TH (makeAdaptorAndInstance)
import           Data.Time.Calendar (Day)

import qualified Database.PostgreSQL.Simple as PGS


-- modelToPersistentEntity :: Activity -> ScheduleItem
-- modelToPersistentEntity x = do
--   let encoded = encode x
--   ScheduleItem 
--     (activityTimeFrameStartInstant . activityTimeFrame $ x)  
--     (activityTimeFrameDurationInSeconds . activityTimeFrame $ x)
--     (show $ toStrict encoded)

-- let t = map modelToPersistentEntity (concatMap snd $ Map.toList fakeData)

getDbConn :: IO PGS.Connection
getDbConn = PGS.connect PGS.ConnectInfo
  { PGS.connectHost = "localhost"
  , PGS.connectPort = 5432
  , PGS.connectDatabase = "cronmylife"
  , PGS.connectUser = "cronmylife_role"
  , PGS.connectPassword = "cronmylife_role"
  }

activitiesTable :: Table (Field SqlInt8, Field SqlInt8) (Field SqlInt8, Field SqlInt8)
activitiesTable = table "activities" (p2 ( tableField "startInstant"
                                          , tableField "durationSeconds"))

activityCategoriesTable :: Table (Field SqlText, Field SqlText) (Field SqlText, Field SqlText)

activityCategoriesTable = table "activityCategories" (p2 (tableField "categoryName"
                                                         , tableField "categoryIcon"))
