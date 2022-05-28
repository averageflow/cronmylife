module CronMyLife.Presentation where

import CronMyLife.Model
import Data.Aeson (ToJSON, encode)
import Data.Map (Map, traverseWithKey)
import Data.Text.Encoding (decodeUtf8)

showCentralSchedulerDataConsole :: CentralSchedulerData -> IO (Map String ())
showCentralSchedulerDataConsole xs =
  traverseWithKey
    showDataCLI
    (scheduleData xs)

sepCLI :: String
sepCLI = "+--------------------------------------------------+"

showDataCLI :: String -> Activity -> IO ()
showDataCLI k v = do
  putStrLn sepCLI >> putStrLn k >> putStrLn sepCLI
  putStrLn $ "name: " ++ activityName v

  putStrLn "location: "
  putStrLn $ "\tlatitude: " ++ (latCoords . activityLocation) v
  putStrLn $ "\tlongitude: " ++ (longCoords . activityLocation) v

  putStrLn $ "categories: " ++ concatMap 
    (\x -> "\n\t- " ++ activityCategoryName x) 
    (activityCategories v)
  putStrLn $ "time frame: " ++ activityName v


  putStrLn sepCLI  >> putStrLn ""
