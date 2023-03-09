import random
import nimraylib_now

type Room = object
    x : int
    y : int
    w : int
    h : int

type Dungeon* = array[0..101, array[0..101, int]]

type DungeonData* = object
    dungeon* : Dungeon
    floorAtlas : Texture2D
    wallAtlas : Texture2D
    widthInTiles* : int
    heightInTiles* : int

const
    AIR* = 0
    WALL* = 1
    FLOOR* = 2

proc GenerateTiles(self : var DungeonData, max_w : int, max_h : int) =
    randomize()
    let max_room_w = 12
    let min_room_w = 5
    let max_room_h = 12
    let min_room_h = 5

    self.widthInTiles = max_w
    self.heightINTiles = max_h
    # Clear the dungeon data
    for y in 0..max_w-1:
        for x in 0..max_h-1:
            self.dungeon[y][x] = AIR


    var rooms: seq[Room] = @[]
    var max_rooms : int
    if max_w > max_h:
        max_rooms = int(max_w / 2)
    else:
        max_rooms = int(max_h / 2)

    for i in 0..<max_rooms:
        # Generate a random room
        var room = Room()
        room.x = rand(1..max_w-10)
        room.y = rand(1..max_h-10)
        room.w = rand(min_room_w..max_room_w)
        room.h = rand(min_room_h..max_room_h)

        # Check for overlapping with existing rooms
        var overlaps = false
        for other_room in rooms:
            if (room.x < other_room.x + other_room.w + 1 and
                room.x + room.w + 1 > other_room.x and
                room.y < other_room.y + other_room.h + 1 and
                room.y + room.h + 1 > other_room.y):
                overlaps = true
                break

        if not overlaps:
            # Add the new room to the list and set the tiles to FLOOR
            rooms.add(room)
            for y in room.y + 1..room.y + room.h - 2:
                for x in room.x + 1..room.x + room.w - 2:
                    self.dungeon[y][x] = FLOOR

            # Add walls around the room
            for y in room.y..room.y + room.h - 1:
                for x in room.x..room.x + room.w - 1:
                    if x == room.x or x == room.x + room.w - 1 or y == room.y or y == room.y + room.h - 1:
                        self.dungeon[y][x] = WALL

            # Connect the rooms with corridors
            for i in 0..<len(rooms)-1:
                var r1 = rooms[i]
                var r2 = rooms[i+1]

                # Create a corridor between the two rooms
                var x = r1.x + r1.w div 2
                var y = r1.y + r1.h div 2

                while x != r2.x + r2.w div 2:
                    if x < r2.x + r2.w div 2:
                        x += 1
                    else:
                        x -= 1
                    self.dungeon[y][x] = FLOOR

                    # Add walls perpendicular to the corridor
                    if self.dungeon[y-1][x] != FLOOR and self.dungeon[y+1][x] != FLOOR:
                        self.dungeon[y-1][x] = WALL
                        self.dungeon[y+1][x] = WALL

                while y != r2.y + r2.h div 2:
                    if y < r2.y + r2.h div 2:
                        y += 1
                    else:
                        y -= 1
                    self.dungeon[y][x] = FLOOR

                    # Add walls perpendicular to the corridor
                    if self.dungeon[y][x-1] != FLOOR and self.dungeon[y][x+1] != FLOOR:
                        self.dungeon[y][x-1] = WALL
                        self.dungeon[y][x+1] = WALL
            # Add walls around the corridors
            for y in 0..len(self.dungeon)-1:
                for x in 0..len(self.dungeon[y])-1:
                    if self.dungeon[y][x] == FLOOR:
                        if self.dungeon[y-1][x] == AIR:
                            self.dungeon[y-1][x] = WALL
                        if self.dungeon[y+1][x] == AIR:
                            self.dungeon[y+1][x] = WALL
                        if self.dungeon[y][x-1] == AIR:
                            self.dungeon[y][x-1] = WALL
                        if self.dungeon[y][x+1] == AIR:
                            self.dungeon[y][x+1] = WALL

proc GenerateDungeon*(maxW : int, maxH : int) : DungeonData =
    var dungeonData = DungeonData()
    dungeonData.GenerateTiles(maxW, maxH)
    dungeonData.floorAtlas = loadTexture("res/Floor.png")
    dungeonData.wallAtlas = loadTexture("res/Wall.png")

    return dungeonData

proc DrawTile*(self : DungeonData, tile : int, position : Vector2) =
    let tileSize = 16

    if tile == FLOOR:
        let floor_atlas_y = 7 * tile_size
        let floor_atlas_x = 1 * tile_size
        var src = Rectangle()
        src.x = float(floor_atlas_x)
        src.y = float(floor_atlas_y)
        src.width = float(tileSize)
        src.height = float(tileSize)
        drawTextureRec(self.floorAtlas, src, position, White)
    elif tile == WALL:
        let wall_atlas_y = 6 * tileSize
        let wall_atlas_x = 3 * tileSize
        var src = Rectangle()
        src.x = float(wall_atlas_x)
        src.y = float(wall_atlas_y)
        src.width = float(tileSize)
        src.height = float(tileSize)
        drawTextureRec(self.wallAtlas, src, position, White)
