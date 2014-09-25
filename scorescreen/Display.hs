module Display where

{- to Do:
    [x] edit file to take parameter for Title of Page
    [ ] make a page for each group (Global, you, ta's, sections, time) --Jon
    [ ] beautify it --Dat
    [ ] add top 10 addicts and avg to each page + std dev --Dat
    [ ] create navigation pane --Jon
-}

import qualified Data.ByteString.Char8 as B

-- prints html to specified file
display :: String -> String -> [[B.ByteString]] -> [[B.ByteString]] -> Int -> IO ()
display title fileLoc bss addicts avg = do
       writeFile fileLoc $ file title (listToTable $ removeJunk bss) (listToAddicts addicts) (show avg)
       
 
-- creates html string      
file :: String -> String -> String -> String -> String
file title top addicts avg =    "<!DOCTYPE html>\n"
                             ++ "<html>\n"
                             ++ "<head>\n"
                             ++ "<link type=\"text/css\" rel=\"stylesheet\" href=\"stylesheet.css\" >\n"
                             ++ "<title>" ++ title ++ "</title>\n"
                             ++ "</head>\n"
                             ++ "<body>\n"
                             ++ "<center><img src=\"./img/typespeedlogo.png\"/></center>"
                             ++ "<br>"
                             ++ "<h3> &#8212 " ++ title ++ " &#8212 </h3>"
                             ++ top 
                             ++ addicts
                             ++ "<br>\n"
                             ++ "<strong>Average score: " ++ avg ++ "</strong>\n"
                             ++ "</body>\n"
                             ++ "</html>\n"


-- converts scores into html table format for all stats
listToTable :: [[B.ByteString]] -> String
listToTable bss =    "<center>\n"
                  ++ "<table>\n"
                  ++ "<tr>\n"
                  ++ "<th>Score</th>\n<th>Username</th>\n<th>Chars Entered</th>\n<th>Words Entered</th>\n<th>Duration (s)</th>\n"
                  ++ "</tr>\n"
                  ++ rows bss
                  ++ "</table>\n"
                  ++ "</center>\n"
    where rows [] = ""
          rows (bs':bss') =    "<tr>\n"
                            ++ entries bs'
                            ++ "</tr>\n"
                            ++ rows bss'
          entries [] = ""
          entries (b'':bs'') =    "<td>"
                               ++ B.unpack b''
                               ++ "</td>\n"
                               ++ entries bs''


-- converts scores into html table format for addicts
listToAddicts :: [[B.ByteString]] -> String
listToAddicts bss =  "<center>\n"
                  ++ "<br>\n"
                  ++ "<h3> &#8212 Top 10 Addicts &#8212 </h3>"
                  ++ "<table>\n"
                  ++ "<tr>\n"
                  ++ "<th>Times Played</th>\n<th>Username</th>\n"
                  ++ "</tr>\n"
                  ++ rows bss
                  ++ "</table>\n"
                  ++ "</center>\n"
    where rows [] = ""
          rows (bs':bss') =    "<tr>\n"
                            ++ entries bs'
                            ++ "</tr>\n"
                            ++ rows bss'
          entries [] = ""
          entries (b'':bs'') =    "<td>"
                               ++ B.unpack b''
                               ++ "</td>\n"
                               ++ entries bs''


-- removes unwanted data from scores, leaving score, total count, enter offset,
-- name, and duration
removeJunk :: [[B.ByteString]] -> [[B.ByteString]]
removeJunk [] = []
removeJunk (bs:bss) = ((head bs) : (bs !! 3) : take 2 (tail bs) ++ [timeify (bs !! 6)]) : removeJunk bss
    where timeify b = B.pack $ show $ (read $ B.unpack b) / 100.0
