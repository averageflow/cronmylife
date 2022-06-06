{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleInstances #-}

module CronMyLife.Lib where

import           Database.Persist.Sqlite
import CronMyLife.Persistent.Repository


conn :: SqliteConnectionInfo
conn = mkSqliteConnectionInfo "./cronmylife.db"


startApplication :: IO()
startApplication = do
    initialSchemaSetup conn
    joe <- createAndGetJoe conn
    print joe
