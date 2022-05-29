{-# LANGUAGE BlockArguments #-}
module CronMyLife.Presentation where

import CronMyLife.Model
import Data.Aeson (ToJSON, encode)
import Data.Map (Map, traverseWithKey)
import Data.Text.Encoding (decodeUtf8)
import Text.Printf

showCentralSchedulerDataConsole :: CentralSchedulerData -> IO (Map String ())
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

showDataCLI :: String -> [Activity] -> IO ()
showDataCLI k v = putStrLn (concatMap (showActivityCLI k) v)
  
