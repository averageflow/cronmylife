{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DefaultSignatures #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DeriveGeneric #-}

module CronMyLife.Repository.Opaleye where

import Data.Int
import Data.Profunctor.Product.TH (makeAdaptorAndInstance)
import Data.Time
import qualified Database.PostgreSQL.Simple as PGS
import Opaleye
import Opaleye.Internal.PGTypesExternal
import Prelude hiding (sum)
import Database.PostgreSQL.Simple.Types (Default)
import GHC.Generics

getDbConn :: IO PGS.Connection
getDbConn =
  PGS.connect
    PGS.ConnectInfo
      { PGS.connectHost = "localhost",
        PGS.connectPort = 5432,
        PGS.connectDatabase = "cronmylife",
        PGS.connectUser = "atp",
        PGS.connectPassword = "atp"
      }


data ActivityEntity' key startInstant durationSeconds createdAt = ActivityEntity
  { activityKey :: key,
    startInstant :: startInstant,
    durationSeconds :: durationSeconds,
    createdAt :: createdAt
  }
  deriving (Show, Generic, Eq)


type ActivityEntity = ActivityEntity' Int Int Int UTCTime

type ActivityEntityFieldWrite = ActivityEntity' (Maybe (Field SqlInt8)) (Field SqlInt8) (Field SqlInt8) (Maybe (Field PGTimestamptz))

type ActivityEntityFieldRead = ActivityEntity' ((Field SqlInt8)) (Field SqlInt8) (Field SqlInt8) ((Field PGTimestamptz))

$(makeAdaptorAndInstance "pActivityEntity" ''ActivityEntity')

activitiesTable :: Table ActivityEntityFieldWrite ActivityEntityFieldRead
activitiesTable =
  table
    "activities"
    ( pActivityEntity
        ActivityEntity
          { activityKey = optionalTableField "id",
            startInstant = requiredTableField "start_instant",
            durationSeconds = requiredTableField "duration_seconds",
            createdAt = optionalTableField "created_at"
          }
    )

findAllActivities :: Select ActivityEntityFieldRead
findAllActivities = selectTable activitiesTable

insertActivities :: [ActivityEntityFieldWrite] -> Insert Int64
insertActivities xs =
  Insert
    { iTable = activitiesTable,
      iRows = map toFields xs,
      iReturning = rCount,
      iOnConflict = Nothing
    }