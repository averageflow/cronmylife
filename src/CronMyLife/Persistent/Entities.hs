{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}
{-# OPTIONS_GHC -Wno-name-shadowing #-}

module CronMyLife.Persistent.Entities where

import Database.Esqueleto hiding (from, on)
import Database.Persist.TH

share
  [mkPersist sqlSettings, mkEntityDefList "entityDefs"]
  [persistLowerCase|
ActivityCategoriesEntity
    name String
    icon String Maybe 
    deriving Show

ActivitiesActivityCategoriesEntity
    activitiesEntityId ActivitiesEntityId
    activityCategoriesEntityId ActivityCategoriesEntityId

ActivityLocationsEntity
    latitude String Maybe 
    longitude String Maybe
    name String
    mapURL String Maybe
    deriving Show

ActivitiesActivityLocationsEntity
    activitiesEntityId ActivitiesEntityId
    activityLocationsEntityId ActivityLocationsEntityId

ActivitiesEntity
    schedulesEntityId SchedulesEntityId
    durationSeconds Int
    startInstant Int
    name String
    deriving Show

SchedulesEntity
    scheduleOwnersEntityId ScheduleOwnersEntityId
    scheduleName String
    deriving Show

ScheduleOwnersEntity
    name String
    description String Maybe
    avatar String Maybe
    deriving Show 
|]
