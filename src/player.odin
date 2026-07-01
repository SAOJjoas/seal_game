package main

import "vendor:box2d"

PIXELS_TO_METERS :: 1.0 / 50.0

Player :: struct {
    body: ^box2d.Body,
    speed: f32,
    width: f32,
    height: f32,
}

init_player :: proc(world: ^box2d.World) -> Player {
    player: Player

    player.width = 26.0 
    player.height = 24.0 
    player.speed = 8.0 

    body_def := box2d.DefaultBodyDef() 
    body_def.type = .dynamicBody
    body_def.fixedRotation = true
    body_def.position = box2d.Vec2{400.0 * PIXELS_TO_METERS, 500.0 * PIXELS_TO_METERS} 

    player.body = box2d.CreateBody(world, &body_def) 

    radius := (player.width / 2.0) * PIXELS_TO_METERS 

    player_circle := box2d.MakeCircle(radius) [cite: 6]
    box2d.CreateFixture(player.body, &player_circle, 0.0) [cite: 6]

    return player 
}

update_player :: proc(player: ^Player) {
    current_velocity := box2d.Body_GetLinearVelocity(player.body) [cite: 7]
    new_velocity := current_velocity [cite: 7]

    if raylib.IsKeyPressed(.A) || raylib.IsKeyPressed(.LEFT) { [cite: 7]
        new_velocity.x = -player.speed [cite: 7]
    }
    
    if raylib.IsKeyPressed(.D) || raylib.IsKeyPressed(.RIGHT) { [cite: 8]
        new_velocity.x = player.speed [cite: 8]
    }

    box2d.Body_SetLinearVelocity(player.body, new_velocity) [cite: 8]
}