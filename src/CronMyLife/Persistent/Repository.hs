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


runAction conn action = runStdoutLoggingT $ withSqliteConnInfo (conn) $ \backend -> runReaderT action backend

createAndGetJoe conn = runAction conn $ do
  joesId <- insert $ ScheduleOwners 1 "Joe" (Just "Joe's Description") (Just "λ")
  get joesId

initialSchemaSetup conn = runAction conn $ do
  runMigration $ migrate entityDefs $ entityDef (Nothing :: Maybe ScheduleOwners)

-- runSqlite' :: (MonadUnliftIO m) => Text -> ReaderT SqlBackend (NoLoggingT (ResourceT m)) a -> m a
-- runSqlite' = runSqlite

-- getScheduleOwnerById x = do
--     select $ do
--         scheduleOwners <- from $ table @ScheduleOwners
--         where_ (scheduleOwners ^. ScheduleOwnersIdentifier ==. val x)
--         pure scheduleOwners