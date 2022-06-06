{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

module CronMyLife.Model where

import Data.Aeson
import Data.Map
import Data.Typeable (Typeable)
import GHC.Generics

data ActivityCategory = ActivityCategory
  { --categoryIdentifier :: Maybe Int,
    categoryName :: String,
    categoryIcon :: String
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)

data ActivityTimeFrame = ActivityTimeFrame
  { durationSeconds :: Int,
    startInstant :: Int
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)

data ActivityLocation = ActivityLocation
  { --activityLocationIdentifier :: Maybe Int,
    latitude :: String,
    longitude :: String,
    locationName :: String,
    mapURL :: String
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)

data Activity = Activity
  { --activityIdentifier :: Maybe Int,
    activityScheduleId :: Maybe Int,
    activityName :: String,
    activityLocations :: [ActivityLocation],
    activityCategories :: [ActivityCategory],
    activityTimeFrame :: ActivityTimeFrame
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON, Typeable)

data Schedule = Schedule
  { --scheduleIdentifier :: Maybe Int,
    scheduleOwnerId :: Maybe Int,
    scheduleActivities :: Map Int [Activity]
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)

data ApplicationState = ApplicationState
  { scheduleOwner :: ScheduleOwner,
    scheduleData :: Schedule
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)

data ScheduleOwner = ScheduleOwner
  { --scheduleOwnerIdentifier :: Maybe Int,
    scheduleOwnerName :: String,
    scheduleOwnerDescription :: Maybe String,
    scheduleOwnerAvatar :: Maybe String
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)
