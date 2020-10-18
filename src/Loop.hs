{-# LANGUAGE NoImplicitPrelude #-}

module Loop
  ( loop,
    fps,
  )
where

import Brick.BChan
import ClassyPrelude
import Control.Concurrent
import Types

fps :: Int
fps = 15

delay :: Int
delay = 1000000 `div` fps

loop :: BChan Tick -> IO ()
loop chan = void . forkIO . forever $ do
  writeBChan chan Tick
  threadDelay delay
