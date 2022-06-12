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

import CronMyLife.Model
import CronMyLife.OptionsParser
import Options.Applicative
import System.Exit


import CronMyLife.Persistence.Repository


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
  if setupDatabase options
    then do
      setupDatabaseSchema conn 
      putStrLn "Successfully setup DB! Please now start the user creation wizard!"
      exitSuccess
    else pure ()

  -- if (bootStrapUser options)
  --   then do
  --     -- TODO: create a wizard-like experience
  --     (joeId, joe) <- createAndGetJoe conn
  --     print joe
  --     case joe of
  --       Nothing -> print ("Error creating user") >> exitFailure
  --       Just x -> do
  --         (schedId, sched) <- createAndGetSchedule conn (joeId)
  --         print (sched)
  --         exitSuccess
  --   else pure ()

  -- 2 different flow, or user gives userid and schedule
  -- or then userid only then we show list of schedules

  -- case (userId options) of
  --   Nothing -> putStrLn "Please provide your user id!" >> exitFailure
  --   Just x -> do
  --     (joeId, joe) <- getUserDetails conn x
  --     print joe

-- else pure ()

-- case joe of
--   Nothing -> print ("Could not find expected user in DB! No schedule to show! Exiting") >> exitFailure
--   Just x -> do
--     print (mapScheduleOwnerEntityToModel x)
--     sched <- createAndGetSchedule conn (toSqlKey (1))
--     print (sched)
