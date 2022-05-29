{-# LANGUAGE BlockArguments #-}
module CronMyLife.Presentation where

import CronMyLife.Model
import Data.Map (Map, traverseWithKey)
import Text.Printf
import Data.Int (Int64)

showCentralSchedulerDataConsole :: CentralSchedulerData -> IO (Map Int64 ())
showCentralSchedulerDataConsole xs =
  traverseWithKey
    showDataCLI
    (scheduleData xs)

sepCLI :: String
sepCLI = "+--------------------------------------------------+"

showActivityCLI :: String -> Activity -> String
showActivityCLI k activity = formatted
  where 
    categoriesData = concatMap (\category -> "\n\t- " ++ activityCategoryName category) (activityCategories activity)
    formatted = printf "%s\n\
      \%s\n\
      \%s\n\
      \- name: %s\n\
      \  location:\n\
      \  \tlatitude: %s\n\
      \  \tlongitude: %s\n\
      \  categories:\
      \  \t%s\n\
      \  time: %s\n" sepCLI k sepCLI (activityName activity) (latCoords $ activityLocation activity) (longCoords $ activityLocation activity) (categoriesData) ""

showDataCLI :: Int64 -> [Activity] -> IO ()
showDataCLI k v = putStrLn (concatMap (showActivityCLI $ show k) v)
  
