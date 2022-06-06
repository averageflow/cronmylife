{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}
{-# OPTIONS_GHC -Wno-name-shadowing #-}

module CronMyLife.Persistent.Repository where

import Conduit
import Control.Monad.Logger
import Control.Monad.Reader
import Control.Monad.Writer
import CronMyLife.Persistent.Entities
import Database.Esqueleto hiding (from, on)
import Database.Esqueleto.Experimental
import Database.Persist.Sqlite
import CronMyLife.Persistent.Mapper (mapScheduleOwnerEntityToModel)
import CronMyLife.Model


runAction :: MonadUnliftIO m => SqliteConnectionInfo -> ReaderT SqlBackend (LoggingT m) a -> m a
runAction conn action = runStdoutLoggingT $ withSqliteConnInfo conn $ \backend -> runReaderT action backend

createAndGetJoe :: MonadUnliftIO m => SqliteConnectionInfo -> m (Maybe ScheduleOwnersEntity)
createAndGetJoe conn = runAction conn $ do
    joesId <- insert $ ScheduleOwnersEntity "Joe" (Just "Joe's Description") (Just "λ")
    get joesId

-- mapResultSet :: Maybe ScheduleOwnersEntity -> Maybe ScheduleOwner
-- mapResultSet = maybe Nothing mapScheduleOwnerEntityToModel

initialSchemaSetup :: MonadUnliftIO m => SqliteConnectionInfo -> m ()
initialSchemaSetup conn = runAction conn $
  runMigration $ migrate entityDefs $ entityDef (Nothing :: Maybe ScheduleOwnersEntity)

-- runSqlite' :: (MonadUnliftIO m) => Text -> ReaderT SqlBackend (NoLoggingT (ResourceT m)) a -> m a
-- runSqlite' = runSqlite

-- getScheduleOwnerById x = do
--     select $ do
--         scheduleOwners <- from $ table @ScheduleOwners
--         where_ (scheduleOwners ^. ScheduleOwnersIdentifier ==. val x)
--         pure scheduleOwners