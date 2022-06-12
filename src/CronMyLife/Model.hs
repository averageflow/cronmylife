{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

module CronMyLife.Model where

import Data.Aeson
import Data.Int (Int64)
import Data.Map
import Data.Typeable (Typeable)
import GHC.Generics
import Data.Time (UTCTime)

data ActivityCategory = ActivityCategory
  { --categoryIdentifier :: Maybe Int64,
    categoryName :: String,
    categoryIcon :: String
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)

data ActivityTimeFrame = ActivityTimeFrame
  { durationSeconds :: Int64,
    startInstant :: UTCTime
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)

data ActivityLocation = ActivityLocation
  { --activityLocationIdentifier :: Maybe Int64,
    latitude :: String,
    longitude :: String,
    locationName :: String,
    mapURL :: String
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)

data Activity = Activity
  { --activityIdentifier :: Maybe Int64,
    activityScheduleId :: Maybe Int64,
    activityName :: String,
    activityLocations :: [ActivityLocation],
    activityCategories :: [ActivityCategory],
    activityTimeFrame :: ActivityTimeFrame
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON, Typeable)

data Schedule = Schedule
  { --scheduleIdentifier :: Maybe Int64,
    scheduleOwnerId :: Maybe Int64,
    scheduleActivities :: Map Int64 [Activity]
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)

data ApplicationState = ApplicationState
  { scheduleOwner :: ScheduleOwner,
    scheduleData :: Schedule
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)

data ScheduleOwner = ScheduleOwner
  { --scheduleOwnerIdentifier :: Maybe Int64,
    scheduleOwnerName :: String,
    scheduleOwnerDescription :: Maybe String,
    scheduleOwnerAvatar :: Maybe String
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)

data CommandLineCronMyLifeOptions = CommandLineCronMyLifeOptions
  { setup :: Bool,
    userId :: String
    -- scheduleId :: Maybe Int64
  }
  deriving (Show, Eq)