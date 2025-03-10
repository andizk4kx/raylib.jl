#=/*******************************************************************************************
*
*   raylib [shapes] example - bouncing ball
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   Example originally created with raylib 2.5, last time updated with raylib 2.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2013-2025 Ramon Santamaria (@raysan5)
*
********************************************************************************************/=#
#adapted to julia 2025 Andreas Wagner
#include "raylib.h"

#//------------------------------------------------------------------------------------
#// Program main entry point
#//------------------------------------------------------------------------------------
include("../raylib.jl")

    #// Initialization
    #//---------------------------------------------------------
    const  screenWidth = 800
    const  screenHeight = 450

    SetConfigFlags(UInt32(FLAG_MSAA_4X_HINT))
    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - bouncing ball")

    ballPosition = Vector2( GetScreenWidth()/2.0, GetScreenHeight()/2.0 )
    ballSpeed = Vector2( 5.0, 4.0 )
    ballRadius = 20.0

    pause = false
    framesCounter = 0

    SetTargetFPS(60)             #// Set our game to run at 60 frames-per-second
    #//----------------------------------------------------------

    #// Main game loop
    while (!WindowShouldClose())    #// Detect window close button or ESC key
    
        #// Update
        #//-----------------------------------------------------
        if (IsKeyPressed(key_space)) 
            global pause = !pause
        end
            if (!pause)
        
                ballPosition.x += ballSpeed.x
                ballPosition.y += ballSpeed.y

            #// Check walls collision for bouncing
                if ((ballPosition.x >= (GetScreenWidth() - ballRadius)) || (ballPosition.x <= ballRadius)) 
                   ballSpeed.x *= -1.0
                end
                if ((ballPosition.y >= (GetScreenHeight() - ballRadius)) || (ballPosition.y <= ballRadius)) 
                    ballSpeed.y *= -1.0
                end
        
            else 
                global framesCounter = framesCounter+1
            
            end
        
        #//-----------------------------------------------------

        #// Draw
        #//-----------------------------------------------------
        BeginDrawing();

            ClearBackground(RAYWHITE)

            DrawCircleV(ballPosition, ballRadius, MAROON)
            DrawText("PRESS SPACE to PAUSE BALL MOVEMENT", 10, GetScreenHeight() - 25, 20, LIGHTGRAY)

            #// On pause, we draw a blinking message
            if (pause && (mod(div(framesCounter,30),2 ))==0 ) 
                DrawText("PAUSED", 350, 200, 30, GRAY)
            end
            DrawFPS(10, 10)

        EndDrawing()
        #//-----------------------------------------------------
    end

    #// De-Initialization
    #//---------------------------------------------------------
    CloseWindow();       #// Close window and OpenGL context
    #//----------------------------------------------------------=#