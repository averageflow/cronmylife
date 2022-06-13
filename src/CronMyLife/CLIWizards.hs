module CronMyLife.CLIWizards where
import CronMyLife.Persistence.Repository
import Database.PostgreSQL.Simple
import Data.Int

userCreationWizard :: Connection -> IO ()
userCreationWizard conn = do
    putStrLn "Starting user creation wizard!"
    putStrLn "Please enter your name (up to 255 chars, emojis should be fine):"
    wantedName <- getLine
    putStrLn "Please enter your description (or just ENTER to skip):"
    wantedDescription <- getLine
    rs <- createUser conn wantedName wantedDescription
    let newUserId = fromOnly (head rs)
    putStrLn $ "Success creating user with id: " ++ show newUserId

scheduleCreationWizard :: Connection -> Int64 -> IO ()
scheduleCreationWizard conn givenUserId = do
    putStrLn "Creating new schedule!"
    putStrLn "Please input the new schedule name:"
    wantedSchedName <- getLine
    putStrLn "Please input the new schedule description:"
    wantedSchedDesc <- getLine
    rs <- createSchedule conn givenUserId wantedSchedName wantedSchedDesc
    let newschedId = fromOnly (head rs)
    putStrLn $ "Created schedule successfully with id:" ++ (show newschedId)