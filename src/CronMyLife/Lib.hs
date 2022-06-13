{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}

module CronMyLife.Lib where

import CronMyLife.CLIWizards
import CronMyLife.Model
import CronMyLife.OptionsParser
import CronMyLife.Persistence.Repository
import Data.Int
import Database.PostgreSQL.Simple
import Options.Applicative
import System.Exit

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

initialPreparationStage :: Connection -> Bool -> IO ()
initialPreparationStage conn setupMode =
  if setupMode
    then do
      setupDatabaseSchema conn
      userCreationWizard conn
      exitSuccess
    else pure()

enterEventFlow :: CommandLineCronMyLifeOptions -> IO ()
enterEventFlow options = do
  conn <- setupConn
  initialPreparationStage conn (setup options)

  if cliOptionsUserId < 1
    then putStrLn "Invalid user id! Exiting..." >> exitFailure
    else do
      schedules <- getUserSchedules conn cliOptionsUserId
      if not (null schedules) then do
        putStrLn "Available schedules: "
        mapM_ print schedules
      else
        scheduleCreationWizard conn cliOptionsUserId

      putStrLn "What schedule do you want to open? Please specify its numeric id"
      wantedScheduleId <- getLine
      sched <- getScheduleById conn (read wantedScheduleId :: Int64)
      print sched

  where
    cliOptionsUserId = read (userId options) :: Int64
