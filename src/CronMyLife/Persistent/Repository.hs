{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE TypeApplications #-}

{-# OPTIONS_GHC -Wno-name-shadowing #-}

module CronMyLife.Persistent.Repository where

import Conduit
import Control.Monad.Logger
import Control.Monad.Reader
import Control.Monad.Writer
import CronMyLife.Model
import CronMyLife.Persistent.Entities
import CronMyLife.Persistent.Mapper (mapScheduleOwnerEntityToModel)
import Database.Esqueleto hiding (from, on)
import Database.Esqueleto.Experimental
import Database.Persist.Sqlite hiding ((==.))

runAction :: MonadUnliftIO m => SqliteConnectionInfo -> ReaderT SqlBackend (LoggingT m) a -> m a
runAction conn action = runStdoutLoggingT $ withSqliteConnInfo conn $ \backend -> runReaderT action backend

createAndGetJoe :: MonadUnliftIO m => SqliteConnectionInfo -> m (Maybe ScheduleOwnersEntity)
createAndGetJoe conn = runAction conn $ do
  joesId <- insert $ ScheduleOwnersEntity "Joe" (Just "Joe's Description") (Just "λ")
  get joesId

createAndGetSchedule conn owner = runAction conn $ do
  sched <- insert $ SchedulesEntity (from owner) ""
  get sched

getApplicationStateForSchedule conn scheduleId = runAction conn $ do
  select $ do
    (schedule :& activities) <-
        from $ table @SchedulesEntity
        `innerJoin` table @ActivitiesEntity
        `on` (\(schedule :& activities) -> schedule ^. SchedulesEntityId ==. activities ^. ActivitiesEntitySchedulesEntityId)
    where_ (schedule ^. SchedulesEntityId ==. val scheduleId)
    pure (schedule, activities)


initialSchemaSetup :: MonadUnliftIO m => SqliteConnectionInfo -> m ()
initialSchemaSetup conn = runAction conn $ do
  runMigration $ migrate entityDefs $ entityDef (Nothing :: Maybe ActivityCategoriesEntity) 
  runMigration $ migrate entityDefs $ entityDef (Nothing :: Maybe ActivityLocationsEntity)
  runMigration $ migrate entityDefs $ entityDef (Nothing :: Maybe ActivitiesEntity)
  runMigration $ migrate entityDefs $ entityDef (Nothing :: Maybe SchedulesEntity)
  runMigration $ migrate entityDefs $ entityDef (Nothing :: Maybe ScheduleOwnersEntity)

-- mapResultSet :: Maybe ScheduleOwnersEntity -> Maybe ScheduleOwner
-- mapResultSet = maybe Nothing mapScheduleOwnerEntityToModel

-- runSqlite' :: (MonadUnliftIO m) => Text -> ReaderT SqlBackend (NoLoggingT (ResourceT m)) a -> m a
-- runSqlite' = runSqlite

-- getScheduleOwnerById x = do
--     select $ do
--         scheduleOwners <- from $ table @ScheduleOwners
--         where_ (scheduleOwners ^. ScheduleOwnersIdentifier ==. val x)
--         pure scheduleOwners