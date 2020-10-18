{-# LANGUAGE OverloadedStrings #-}

module Attr
  ( attr,
    grass,
    ground,
    obstacle,
  )
where

import Brick
import Graphics.Vty

grass, ground, obstacle :: AttrName
grass = "grass"
ground = "ground"
obstacle = "obstacle"

attr :: AttrMap
attr =
  attrMap
    defAttr
    [ (grass, fg green),
      (ground, fg yellow),
      (obstacle, fg red)
    ]
