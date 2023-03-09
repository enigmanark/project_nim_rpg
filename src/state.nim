import nimraylib_now

type State* = ref object of RootObj
    message* : int

method Update*(self : var State, delta : float, camera : var Camera2D) {.base.} =
    discard

method Draw*(self : State, camera : Camera2D) {.base.} =
    discard

method GetMessage*(self : State) : int {.base.} =
    return self.message

method Unload*(self : State) {.base.} =
    discard
