module CronMyLife.OptionsParser where

import CronMyLife.Model
import Data.List.Split
import Data.Semigroup ((<>))
import Options.Applicative

cronMyLifeOptions :: Parser CommandLineCronMyLifeOptions
cronMyLifeOptions =
  CommandLineCronMyLifeOptions
    <$> switch
      ( long "setup"
          <> help ""
      )
    <*> option
      auto
      ( long "user-id"
          <> help ""
          <> value (Just 0)
          <> metavar "INT"
      )
    <*> option
      auto
      ( long "schedule-id"
          <> help ""
          <> value (Just 0)
          <> metavar "INT"
      )

--   , quiet      :: Bool
--   , enthusiasm :: Int
--   <$> strOption
--       ( long "hello"
--      <> metavar "TARGET"
--      <> help "Target for the greeting" )
--   <*> switch
--       ( long "quiet"
--      <> short 'q'
--      <> help "Whether to be quiet" )
--   <*> option auto
--       ( long "enthusiasm"
--      <> help "How enthusiastically to greet"
--      <> showDefault
--      <> value 1
--      <> metavar "INT" )