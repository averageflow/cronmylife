{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE ScopedTypeVariables #-}

module CronMyLife.Lib where

import CronMyLife.Model
import CronMyLife.OptionsParser
import Options.Applicative
import System.Exit


import CronMyLife.Persistence.Repository
import Database.PostgreSQL.Simple (Only(fromOnly))
import CronMyLife.CLIWizards


runApplication :: IO ()
runApplication = enterEventFlow =<< execParser opts
  where
    opts =
      info
        (cronMyLifeOptions <**> helper)
        ( fullDesc
            <> progDesc ""
            <> header ""
        )

enterEventFlow :: CommandLineCronMyLifeOptions -> IO ()
enterEventFlow options = do
  conn <- setupConn
  if setup options
    then do
      setupDatabaseSchema conn 
      userCreationWizard conn
    else pure ()

  
