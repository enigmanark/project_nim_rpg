import nimraylib_now
import state as State
import dungeon
import random
import sprite_animated
import player as Player

type PlayState* = ref object of State
    gameWidth : float
    gameHeight : float
    windowWidth : float
    windowHeight : float
    dungeonData : DungeonData
    player : Player

proc PlacePlayer(self : var PlayState) =
    var placed = false
    self.player = NewPlayer("res/player.png", 0, 0)
    while not placed:
        echo "Trying to place player..."
        randomize()
        let x = rand(0..self.dungeonData.widthInTiles)
        let y = rand(0..self.dungeonData.heightInTiles)
        if self.dungeonData.dungeon[y][x] == FLOOR:
            self.player.position.x = cfloat(x * 16)
            self.player.position.y = cfloat(y * 16)
            placed = true
            echo "Placed played."

proc NewPlayState*(gw : float, gh : float, ww : float, wh : float) : PlayState =
    var playState = PlayState()
    playState.message = 0
    playState.gameWidth = gw
    playState.gameHeight = gh
    playState.windowWidth = ww
    playState.windowHeight = wh
    playState.dungeonData = GenerateDungeon(30, 30)
    playState.PlacePlayer()
    return playState

method Update*(self : var PlayState, delta : float, camera : var Camera2D) =
    #update player
    self.player.Update(delta)

    #regenerate dungeon with the r key
    if isKeyPressed(KeyboardKey.R):
        randomize()
        self.dungeonData = GenerateDungeon(rand(30..100), rand(30..100))
        self.PlacePlayer()

    #update camera
    camera.target = self.player.position
    let x_off = self.windowWidth / 2
    let y_off = self.windowHeight / 2
    camera.offset = Vector2(x : x_off, y : y_off)

method Draw*(self : PlayState, camera : Camera2D) =
    beginMode2D(camera)
    #draw dungeon
    for y in 0..<len(self.dungeonData.dungeon):
        for x in 0..<len(self.dungeonData.dungeon[y]):
            let tile = self.dungeonData.dungeon[y][x]
            let pos_x : float = float(x) * 16f
            let pos_y : float = float(y) * 16f
            let pos = Vector2(x : pos_x, y : pos_y)
            self.dungeonData.DrawTile(tile, pos)

    #draw player
    self.player.Draw()

    endMode2D()

    #draw fps text
    let fps = getFPS()
    let fps_text = $fps
    let text = "FPS: " & fps_text
    drawText(cstring(text), 10, 10, 25, White)
