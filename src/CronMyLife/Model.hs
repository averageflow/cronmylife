{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

module CronMyLife.Model where

import Data.Aeson
import Data.Map
import Data.Typeable (Typeable)
import GHC.Generics
import Data.Int (Int64)

newtype ActivityCategory = ActivityCategory
  { activityCategoryName :: String
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)

data ActivityTimeFrame = ActivityTimeFrame
  { activityTimeFrameDurationInSeconds :: Int64,
    activityTimeFrameStartInstant :: Int64
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)

data ActivityLocation = ActivityLocation
  { latCoords :: String,
    longCoords :: String,
    activityLocationName :: String
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)

data Activity = Activity
  { activityName :: String,
    activityLocation :: ActivityLocation,
    activityCategories :: [ActivityCategory],
    activityTimeFrame :: ActivityTimeFrame
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON, Typeable)

data CentralSchedulerData = CentralSchedulerData
  { scheduleOwnerName :: String,
    scheduleData :: Map Int64 [Activity]
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)
