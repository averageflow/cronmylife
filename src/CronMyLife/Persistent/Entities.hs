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
ActivityCategories
    identifier Int
    name String
    icon String Maybe 
    ActivityCategoriesPK identifier
    deriving Show

ActivityLocations
    identifier Int
    latitude String Maybe 
    longitude String Maybe
    name String
    mapURL String Maybe
    ActivityLocationsPK identifier
    deriving Show

Activities
    identifier Int
    scheduleId Int
    durationSeconds Int
    startInstant Int
    name String
    ActivitiesPK identifier scheduleId
    deriving Show

Schedules
    identifier Int 
    scheduleOwnerId Int
    SchedulesPK identifier scheduleOwnerId
    deriving Show

ScheduleOwners
    identifier Int
    name String
    description String Maybe
    avatar String Maybe
    ScheduleOwnersPK identifier
    deriving Show
|]
