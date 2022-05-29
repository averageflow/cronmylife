{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE DeriveAnyClass #-}


module CronMyLife.Repository.Beam where

import Database.Beam

import Data.Int (Int64)

data ScheduleItemT f = ScheduleItem
  { _scheduleItemDate :: Columnar f Int64,
    _scheduleDurationSeconds :: Columnar f Int64,
    _scheduleItemsForDate :: Columnar f String
  }
  deriving (Generic)

instance Beamable ScheduleItemT


type ScheduleItem = ScheduleItemT Identity
type ScheduleItemId = PrimaryKey ScheduleItemT Identity

deriving instance Show ScheduleItem

deriving instance Eq ScheduleItem

instance Table ScheduleItemT where
   data PrimaryKey ScheduleItemT f = ScheduleItemId (Columnar f Int64) deriving (Generic, Beamable)
   primaryKey = ScheduleItemId . _scheduleItemDate

data ScheduleDB f = ScheduleDB
                      { _scheduleItems :: f (TableEntity ScheduleItemT) }
                        deriving (Generic, Database be)


scheduleDb :: DatabaseSettings be ScheduleDB
scheduleDb = defaultDbSettings
