package main

import "vendor:box2d"
import "vendor:raylib"

main :: proc() {
    screen_width:  i32 = 800
    screen_height: i32 = 600
    raylib.InitWindow(screen_width, screen_height, "Jogo da Foca")
    raylib.SetTargetFPS(60)

    defer raylib.CloseWindow()

    game := init_game()
    defer box2d.DestroyWorld(game.world)

    foca_texture := raylib.LoadTexture("assets/pixil-frame-0.png")
    defer raylib.UnloadTexture(foca_texture)

    for !raylib.WindowShouldClose() {
        
        if !game.game_over {
            update_player(&game.player)

            time_step: f32 = 1.0 / 60.0
            box2d.World_Step(game.world, time_step, 4)

            pos_foca_metros := box2d.Body_GetPosition(game.player.body)
            if pos_foca_metros.y * 50.0 > 650.0 {
                game.game_over = true
            }
        } else {
            if raylib.IsKeyPressed(.R) {
                reset_game(&game)
            }
        }

        raylib.BeginDrawing()
        raylib.ClearBackground(raylib.RAYWHITE)

        raylib.DrawRectangle(
            i32(game.geleira.x - game.geleira.width / 2.0),
            i32(game.geleira.y - game.geleira.height / 2.0),
            i32(game.geleira.width),
            i32(game.geleira.height),
            raylib.LIGHTGRAY,
        )

        pos_metros := box2d.Body_GetPosition(game.player.body)
        pos_pixels_x := pos_metros.x * 50.0
        pos_pixels_y := pos_metros.y * 50.0

        source_rect := raylib.Rectangle{0, 0, f32(foca_texture.width), f32(foca_texture.height)}
        dest_rect   := raylib.Rectangle{pos_pixels_x, pos_pixels_y, game.player.width, game.player.height}
        origem := raylib.Vector2{game.player.width / 2.0, game.player.height / 2.0}
        
        raylib.DrawTexturePro(foca_texture, source_rect, dest_rect, origem, 0.0, raylib.WHITE)

        if game.game_over {
            raylib.DrawRectangle(0, 0, screen_width, screen_height, raylib.Fade(raylib.BLACK, 0.6))
            raylib.DrawText("A FOCA CAIU DA GELEIRA!", 180, 250, 32, raylib.RED)
            raylib.DrawText("Pressione 'R' para Recomeçar", 240, 310, 20, raylib.WHITE)
        }

        raylib.EndDrawing()
    }
}