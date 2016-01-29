import XMonad
import XMonad.Util.Run (safeSpawn)
import XMonad.Util.Paste (pasteSelection)
import XMonad.Hooks.ManageDocks (manageDocks, avoidStruts)
import XMonad.Config.Desktop (desktopConfig)
import XMonad.Config.Gnome (gnomeConfig, gnomeRegister)
import XMonad.Layout.Spacing (spacing)
import XMonad.Layout.NoBorders (smartBorders)
import qualified XMonad.StackSet as W
import XMonad.Layout.IM
import XMonad.Layout.ShowWName (showWName)
-- import XMonad.Actions.Volume (lowerVolume, raiseVolume, toggleMute)

import XMonad.Hooks.DynamicLog

import Data.Monoid ((<>))
import qualified Data.Map as Map
import Data.Map (Map)

myTerminal = "xterm"

myLayout = showWName $ tiled ||| Full
  where
    -- default tiling alg partitions the screen into two panes
    tiled = spacing pxspacing $ Tall nmaster delta ratio

    -- spacing between panes
    pxspacing = 0

    -- The default number of windows in the master pane
    nmaster = 1

    -- default proportion of the screen occupied by the master pane
    ratio = 7/11

    -- percent of screen to increment by when resizing panes
    delta = 5/100

myLayoutHook = smartBorders $ avoidStruts myLayout

myStartupHook :: X ()
myStartupHook = do
  startupHook desktopConfig
  safeSpawn myTerminal []

myKeys :: XConfig Layout -> Map (ButtonMask, KeySym) (X ())
myKeys XConfig { modMask = mask } = Map.fromList
  [ ((mask, xK_s), spawn "scrot -s ~/Pictures/screenshots/%Y-%m-%d_$wx$h.png")
  , ((mask, xK_v), pasteSelection)
  , ((mask, xK_grave), safeSpawn "emacs" [])
  ]

myConfig = desktopConfig
  { modMask = mod4Mask
  , startupHook = myStartupHook
  , terminal = myTerminal
  , layoutHook = myLayoutHook
  , borderWidth = 2
  , normalBorderColor = "#3C3B37" -- dark gray
  , focusedBorderColor = "#68B1D0" -- light gray
  , keys = myKeys <> keys desktopConfig
  }


main = do
  config <- xmobar myConfig
  xmonad config
