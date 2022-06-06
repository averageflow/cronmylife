{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}

module CronMyLife.Lib where

import CronMyLife.Persistent.Mapper
import CronMyLife.Persistent.Repository
import Database.Persist.Sqlite
import System.Exit
import CronMyLife.Persistent.Entities (EntityField(ScheduleOwnersEntityId, SchedulesEntityScheduleOwnersEntityId))
import Database.Esqueleto (val)

conn :: SqliteConnectionInfo
conn = mkSqliteConnectionInfo "./cronmylife.db"

startApplication :: IO ()
startApplication = do
  initialSchemaSetup conn
  joe <- createAndGetJoe conn
  case joe of
    Nothing -> print ("Could not find expected user in DB! No schedule to show! Exiting") >> exitFailure
    Just x -> print (mapScheduleOwnerEntityToModel x)

  sched <- createAndGetSchedule conn 1
  print (sched)
  
  

