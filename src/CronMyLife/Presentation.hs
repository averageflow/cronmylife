{-# LANGUAGE BlockArguments #-}
module CronMyLife.Presentation where

import CronMyLife.Model
import Data.Map (Map, traverseWithKey)
import Text.Printf
import Data.Int (Int64)

showCentralSchedulerDataConsole :: ApplicationState -> IO (Map Int64 ())
showCentralSchedulerDataConsole xs =
  traverseWithKey
    showDataCLI
    (scheduleData xs)

sepCLI :: String
sepCLI = "+--------------------------------------------------+"

showActivityCLI :: String -> Activity -> String
showActivityCLI k activity = formatted
  where
    categoriesData = concatMap
      (\category -> "\n\t- " ++ categoryName category)
      (activityCategories activity)

    locationsData = concatMap 
      (\x -> printf "\n\t- latitude: %s\n\t  longitude: %s"  (latitudeCoordinates  x) (longitudeCoordinates x)) 
      (activityLocations activity)

    formatted = printf "%s\n\
      \%s\n\
      \%s\n\
      \- name: %s\n\
      \  locations:\n\
      \%s\
      \  categories:\
      \  \t%s\n\
      \  time: %s\n" sepCLI k sepCLI (activityName activity) (locationsData :: String) categoriesData ""

showDataCLI :: Int64 -> [Activity] -> IO ()
showDataCLI k v = putStrLn (concatMap (showActivityCLI $ show k) v)

