module CronMyLife.CLIWizards where
import CronMyLife.Persistence.Repository
import Database.PostgreSQL.Simple

-- TODO: create a wizard-like experience
userCreationWizard conn = do
    putStrLn "Starting user creation wizard!"
    putStrLn "Please enter your name (up to 255 chars, emojis should be fine):"
    wantedName <- getLine
    putStrLn "Please enter your description (or just ENTER to skip):"
    wantedDescription <- getLine
    rs <- createUser conn wantedName wantedDescription
    let newUserId = fromOnly (head rs)
    putStrLn $ "Success creating user with id: " ++ show newUserId