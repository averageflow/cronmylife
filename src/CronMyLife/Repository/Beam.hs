-- {-# LANGUAGE DeriveGeneric #-}
-- {-# LANGUAGE FlexibleContexts #-}
-- {-# LANGUAGE FlexibleInstances #-}
-- {-# LANGUAGE GADTs #-}
-- {-# LANGUAGE MultiParamTypeClasses #-}
-- {-# LANGUAGE StandaloneDeriving #-}
-- {-# LANGUAGE TypeFamilies #-}
-- {-# LANGUAGE DeriveAnyClass #-}
-- {-# LANGUAGE TypeApplications #-}


-- module CronMyLife.Repository.Beam where

-- import Database.Beam

-- import Data.Int (Int64)
-- import Database.Beam.Sqlite.Syntax
-- import Database.Beam.Sqlite
-- import qualified Database.SQLite.Simple as Database.SQLite.Simple.Internal

-- data ScheduleItemT f = ScheduleItem
--   { _scheduleItemDate :: Columnar f Int64,
--     _scheduleDurationSeconds :: Columnar f Int64,
--     _scheduleItemsForDate :: Columnar f String
--   }
--   deriving (Generic)

-- instance Beamable ScheduleItemT


-- type ScheduleItem = ScheduleItemT Identity
-- type ScheduleItemId = PrimaryKey ScheduleItemT Identity

-- deriving instance Show ScheduleItem

-- deriving instance Eq ScheduleItem

-- instance Table ScheduleItemT where
--    data PrimaryKey ScheduleItemT f = ScheduleItemId (Columnar f Int64) deriving (Generic, Beamable)
--    primaryKey = ScheduleItemId . _scheduleItemDate

-- data ScheduleDB f = ScheduleDB
--                       { _scheduleItems :: f (TableEntity ScheduleItemT) }
--                         deriving (Generic, Database be)


-- scheduleDb :: DatabaseSettings be ScheduleDB
-- scheduleDb = defaultDbSettings

-- save :: Database.SQLite.Simple.Internal.Connection -> [ScheduleItemT Identity] -> IO ()
-- save conn t = do
--   {- for debug output -}
--   runBeamSqliteDebug putStrLn conn $
--     runInsert $
--       Database.Beam.insert (_scheduleItems scheduleDb) $
--           insertValues t

-- find :: Database.SQLite.Simple.Internal.Connection -> p -> IO ()
-- find conn t = do
--   runBeamSqliteDebug putStrLn conn $ do
--     let allItems = (_scheduleItems scheduleDb)
--     let stmt = select $ all_ allItems

--     items <- runSelectReturningList stmt
    
--     mapM_ (liftIO . putStrLn . show) items
