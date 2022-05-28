module CronMyLife.Persistence where

import Data.Aeson (ToJSON, encode)
import qualified Data.ByteString
import Data.ByteString.Lazy (toStrict)

storeScheduleStateJSONFile :: ToJSON a => a -> IO ()
storeScheduleStateJSONFile scheduleData = Data.ByteString.writeFile "state.cronmylife.json" (toStrict . encode $ scheduleData)
