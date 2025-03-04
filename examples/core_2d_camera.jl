#=/*******************************************************************************************
*
*   raylib [core] example - 2D Camera system
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 1.5, last time updated with raylib 3.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2016-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/=#
#adapted to julia 2025 Andreas Wagner (using CoPilot)

include("../raylib.jl")

const MAX_BUILDINGS = 100

# Initialisierung
const screenWidth = 800
const screenHeight = 450

InitWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera")

player = Rectangle(400, 280, 40, 40)
buildings = Vector{Rectangle}(undef, MAX_BUILDINGS)
buildColors = Vector{Color}(undef, MAX_BUILDINGS)

spacing = 0

for i in 1:MAX_BUILDINGS
    width = Float32(GetRandomValue(50, 200))
    height = Float32(GetRandomValue(100, 800))
    y = screenHeight - 130.0 - height
    x = -6000.0 + spacing

    buildings[i] = Rectangle(x, y, width, height)
    spacing += width
    
    global spacing +=  width
    
    buildColors[i] = Color(
        GetRandomValue(200, 240),
        GetRandomValue(200, 240), 
        GetRandomValue(200, 250),
        255
    )
end

camera = Camera2D(
    Vector2(screenWidth/2.0, screenHeight/2.0), # offset
    Vector2(player.x + 20.0, player.y + 20.0),  # target
    0.0,  # rotation
    1.0   # zoom
)

SetTargetFPS(60)

# Main game loop
while !WindowShouldClose()
    # Update
    if IsKeyDown(key_right) 
        player.x += 2
    elseif IsKeyDown(key_left)
        player.x -= 2
    end

    camera.target = Vector2(player.x + 20, player.y + 20)

    if IsKeyDown(key_a)
        camera.rotation -= 1
    elseif IsKeyDown(key_s) 
        camera.rotation += 1
    end

    if camera.rotation > 40
        camera.rotation = 40
    elseif camera.rotation < -40
        camera.rotation = -40
    end

    camera.zoom += GetMouseWheelMove() * 0.05

    if camera.zoom > 3.0
        camera.zoom = 3.0
    elseif camera.zoom < 0.1
        camera.zoom = 0.1
    end

    if IsKeyPressed(key_r)
        camera.zoom = 1.0
        camera.rotation = 0.0
    end

    # Draw
    BeginDrawing()
    
    ClearBackground(RAYWHITE)
    
    BeginMode2D(camera)
    
    DrawRectangle(-6000, 320, 13000, 8000, DARKGRAY)
    
    for i in 1:MAX_BUILDINGS
        DrawRectangleRec(buildings[i], buildColors[i])
    end
    
    DrawRectangleRec(player, RED)
    
    DrawLine(
        Int64(camera.target.x), Int64(-screenHeight*10),
        Int64(camera.target.x), Int64(screenHeight*10), 
        GREEN
    )
    DrawLine(
        Int64(-screenWidth*10),Int64(camera.target.y),
        Int64(screenWidth*10), Int64(camera.target.y),
        GREEN
    )
    
    EndMode2D()
    
    DrawText("SCREEN AREA", 640, 10, 20, RED)
    
    DrawRectangle(0, 0, screenWidth, 5, RED)
    DrawRectangle(0, 5, 5, screenHeight - 10, RED)
    DrawRectangle(screenWidth - 5, 5, 5, screenHeight - 10, RED)
    DrawRectangle(0, screenHeight - 5, screenWidth, 5, RED)
    
    DrawRectangle(10, 10, 250, 113, Fade(SKYBLUE, 0.5))
    DrawRectangleLines(10, 10, 250, 113, BLUE)
    
    DrawText("Free 2d camera controls:", 20, 20, 10, BLACK)
    DrawText("- Right/Left to move Offset", 40, 40, 10, DARKGRAY)
    DrawText("- Mouse Wheel to Zoom in-out", 40, 60, 10, DARKGRAY)
    DrawText("- A / S to Rotate", 40, 80, 10, DARKGRAY)
    DrawText("- R to reset Zoom and Rotation", 40, 100, 10, DARKGRAY)
    
    EndDrawing()
end

CloseWindow()
