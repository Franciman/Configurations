import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.SetWMName
import XMonad.Util.SpawnOnce

myConfig = desktopConfig

main = xmobar myConfig
     { terminal = "sakura"
     , modMask  = mod4Mask
     -- , startupHook = setWMName "LG3D"
     } >>= xmonad

