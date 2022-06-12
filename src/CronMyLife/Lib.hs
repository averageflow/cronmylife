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
import CronMyLife.Persistence.Repository (getUserScheduleIds)
import Data.Int
import Database.PostgreSQL.Simple (Only (fromOnly))
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

enterEventFlow :: CommandLineCronMyLifeOptions -> IO ()
enterEventFlow options = do
  conn <- setupConn
  if setup options
    then do
      setupDatabaseSchema conn
      userCreationWizard conn
      exitSuccess
    else pure ()

  let givenUserId = read (userId options) :: Int64
  if givenUserId < 1
    then putStrLn "Invalid user id! Exiting..." >> exitFailure
    else do
      scheduleIds <- getUserScheduleIds conn givenUserId
      if (length scheduleIds) > 0 then do
        putStrLn "Available schedules: "
        mapM_ (\x -> print x) (scheduleIds)
      else do
        wantedSchedName <- getLine
        wantedSchedDesc <- getLine
        rs <- createSchedule conn wantedSchedName wantedSchedDesc
        let newschedId = fromOnly (head rs)
        putStrLn $ "Created schedule successfully with id:" ++ (show newschedId)
      
      putStrLn "What schedule do you want to open? Please specify its numeric id"
      wantedScheduleId <- getLine
      ched <- getScheduleById conn (read wantedScheduleId :: Int64)
      print ched
