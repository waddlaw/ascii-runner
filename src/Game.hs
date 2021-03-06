module Game (play) where

import qualified Actions
import Attr
import Brick
import Brick.BChan
import ClassyPrelude
import Control.Lens
import Draw
import Graphics.Vty
import Loop
import System.Random
import Types
import Window

handleTick :: UI -> EventM Name (Next UI)
handleTick ui = do
  let sp = ui ^. speed
  s <- liftIO getDimensions
  r <- liftIO $ getStdRandom (randomR (sp, sp * 3))
  continue $ Actions.frame r (ui & dimensions .~ s)

handleEvent :: UI -> BrickEvent Name Tick -> EventM Name (Next UI)
handleEvent ui (VtyEvent (EvKey (KChar 'q') [])) = halt ui
handleEvent ui (VtyEvent (EvKey KEnter [])) = continue $ Actions.restart ui
handleEvent ui (VtyEvent (EvKey (KChar ' ') [])) = continue $ Actions.jump ui
handleEvent ui (AppEvent Tick) = handleTick ui
handleEvent ui _ = continue ui

app :: App UI Tick Name
app =
  App
    { appDraw = draw,
      appChooseCursor = neverShowCursor,
      appHandleEvent = handleEvent,
      appStartEvent = return,
      appAttrMap = const attr
    }

getSpeed :: IO Int
getSpeed = do
  args <- getArgs
  return $ case args of
    [sp] -> fromMaybe 10 $ readMay sp
    _ -> 10

play :: IO ()
play = do
  chan <- newBChan 1
  loop chan
  s <- getDimensions
  sp <- getSpeed
  cfg <- standardIOConfig
  vty <- mkVty cfg
  void $ customMain vty (mkVty defaultConfig) (Just chan) app $ create s sp
