import nimraylib_now
import state as State

type TitleState* = ref object of State
    gameWidth : float
    gameHeight : float
    windowWidth : float
    windowHeight : float

proc NewTitleState*(gw : float, gh : float, ww : float, wh : float) : TitleState =
    var titleState = TitleState()
    titleState.message = 0
    titleState.gameWidth = gw
    titleState.gameHeight = gh
    titleState.windowWidth = ww
    titleState.windowHeight = wh
    return titleState

method Update*(self : var TitleState, delta : float, camera : var Camera2D) =
    if isKeyPressed(KeyboardKey.ENTER):
        self.message = 2

method Draw*(self : TitleState, camera : Camera2D) =
    let text = "Project Nim RPG v0.0.1 by Enigmanark"
    let text_offset = measureText(cstring(text), 35) / 2
    let text_x = self.windowWidth / 2 - text_offset
    drawText(cstring(text), cint(text_x), cint(self.windowHeight / 2), 35, White)
