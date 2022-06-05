{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

module CronMyLife.Model where

import Data.Aeson
import Data.Map
import Data.Typeable (Typeable)
import GHC.Generics
import Data.Int (Int64)

data ActivityCategory = ActivityCategory
  { categoryName :: String,
    categoryIcon :: String
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)

data ActivityTimeFrame = ActivityTimeFrame
  { durationSeconds :: Int64,
    startInstant :: Int64
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)

data ActivityLocation = ActivityLocation
  { latitudeCoordinates :: String,
    longitudeCoordinates :: String,
    locationName :: String,
    mapURL :: String
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)

data Activity = Activity
  { activityName :: String,
    activityLocations :: [ActivityLocation],
    activityCategories :: [ActivityCategory],
    activityTimeFrame :: ActivityTimeFrame
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON, Typeable)

data ApplicationState = ApplicationState
  { scheduleOwnerName :: String,
    scheduleData :: Map Int64 [Activity]
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)
