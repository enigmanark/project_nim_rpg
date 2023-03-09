import nimraylib_now

type AnimatedSprite* = ref object of RootObj
    position* : Vector2
    texture* : Texture2D
    srcRect* : Rectangle
    animDelay* : float
    animTimer* : float

proc NewAnimatedSprite*(path : string, x : float, y : float) : AnimatedSprite =
    var sprite = AnimatedSprite()
    sprite.srcRect = Rectangle()
    sprite.srcRect.x = 0
    sprite.srcRect.y = 0
    sprite.srcRect.width = 16
    sprite.srcRect.height = 16
    sprite.position = Vector2(x : x, y : y)
    sprite.texture = loadTexture(path)
    sprite.animDelay = 0.2f
    sprite.animTimer = 0f
    return sprite

method Draw*(self : AnimatedSprite) {.base.} =
    drawTextureRec(self.texture, self.srcRect, self.position, White)

method Update*(self : AnimatedSprite, delta : float) {.base.} =
    self.animTimer += delta
    if self.animTimer >= self.animDelay:
        self.animTimer = 0f
        if self.srcRect.x == 0:
            self.srcRect.x = 16
        else:
            self.srcRect.x = 0
