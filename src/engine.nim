import nimraylib_now
import state as State
import state_title as TitleState
import state_play as PlayState

type Engine* = object
    windowWidth : float
    windowHeight : float
    windowTitle : string
    gameWidth : float
    gameHeight : float
    camera : Camera2D
    camera_zoom : float
    current_state : State

proc NewEngine*() : Engine =
    #create new engine object
    var engine = Engine()
    engine.windowWidth = 1366
    engine.windowHeight = 768
    engine.camera_zoom = 3f
    engine.windowTitle = "Project Nim RPG - by Enigmanark"
    engine.gameWidth = engine.windowWidth / engine.camera_zoom
    engine.gameHeight = engine.windowHeight / engine.camera_zoom

    return engine

proc Initialize*(self : var Engine) =
    #initialize game
    initWindow(cint(self.windowWidth), cint(self.windowHeight), cstring(self.windowTitle))
    setTargetFPS(60)
    initAudioDevice()
    self.camera = Camera2D()
    self.camera.zoom = self.camera_zoom
    self.current_state = NewTitleState(self.gameWidth, self.gameHeight, self.windowWidth, self.windowHeight)

proc Update(self : var Engine) =
    let delta = getFrameTime()

    #update the current state
    self.current_state.Update(delta, self.camera)

    #get message of current state to see if we should state change
    #0 is do not change state
    #1 is title
    #2 is play
    let msg = self.current_state.GetMessage()
    if not(msg == 0):
        if msg == 2:
            #change to play state
            self.current_state.Unload()
            self.current_state = NewPlayState(self.gameWidth, self.gameHeight, self.windowWidth, self.windowHeight)
        elif msg == 1:
            #change to title state
            self.current_state.Unload()
            self.current_state = NewTitleState(self.gameWidth, self.gameHeight, self.windowWidth, self.windowHeight)

#draw the game
proc Draw(self : Engine) =
    beginDrawing()
    clearBackground(Black)
    self.current_state.Draw(self.camera)
    endDrawing()

#run the main loop
proc Run*(self : var Engine) =
    while not windowShouldClose():
        self.Update()
        self.Draw()

    closeAudioDevice()
    closeWindow()
