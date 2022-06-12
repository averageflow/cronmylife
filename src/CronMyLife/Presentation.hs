{-# LANGUAGE BlockArguments #-}

module CronMyLife.Presentation where

import CronMyLife.Model
import Data.Int (Int64)
import Data.Map (Map, traverseWithKey)
import Text.Printf

showCentralSchedulerDataConsole :: ApplicationState -> IO (Map Int ())
showCentralSchedulerDataConsole xs =
  traverseWithKey
    showDataCLI
    (scheduleActivities . scheduleData $ xs)

sepCLI :: String
sepCLI = "+--------------------------------------------------+"

showActivityCLI :: String -> Activity -> String
showActivityCLI k activity = formatted
  where
    categoriesData =
      concatMap
        (\category -> "\n\t- " ++ categoryName category)
        (activityCategories activity)

    locationsData =
      concatMap
        (\x -> printf "\n\t- latitude: %s\n\t  longitude: %s" (latitude x) (longitude x))
        (activityLocations activity)

    formatted =
      printf
        "%s\n\
        \%s\n\
        \%s\n\
        \- name: %s\n\
        \  locations:\n\
        \%s\
        \  categories:\
        \  \t%s\n\
        \  time: %s\n"
        sepCLI
        k
        sepCLI
        (activityName activity)
        (locationsData :: String)
        categoriesData
        ""

showDataCLI k v = putStrLn (concatMap (showActivityCLI $ show k) v)
