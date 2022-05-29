{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

module CronMyLife.Model where

import Data.Aeson
import Data.Map
import Data.Time.Clock.POSIX
import Data.Typeable (Typeable)
import GHC.Generics
import Data.Time

newtype ActivityCategory = ActivityCategory
  { activityCategoryName :: String
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)

data ActivityTimeFrame = ActivityTimeFrame
  { activityTimeFrameDurationInSeconds :: Float,
    activityTimeFrameStartInstant :: UTCTime
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
  deriving (Show, Eq, Generic, FromJSON, ToJSON)

data CentralSchedulerData = CentralSchedulerData
  { scheduleOwnerName :: String,
    scheduleData :: Map String [Activity]
  }
  deriving (Show, Eq, Generic, FromJSON, ToJSON)
