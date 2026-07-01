package main

import "vendor:box2d"

Geleira :: struct {
    body:   ^box2d.Body,
    width:  f32,
    height: f32,
    x: f32,
    y: f32,
}

Game :: struct {
    world:  ^box2d.World,
    player: Player,
    geleira: Geleira,
    game_over: bool,
}

init_game :: proc() -> Game {
    game: Game

    world_def := box2d.DefaultWorldDef()
    world_def.gravity = box2d.Vec2{0.0, 9.81}

    game.world = box2d.CreateWorld(&world_def)

    game.geleira.width = 500.0
    game.geleira.height = 40.0
    game.geleira.x = 400.0
    game.geleira.y = 530.0

    geleira_def := box2d.DefaultBodyDef()
    geleira_def.type = .staticBody 
    geleira_def.position = box2d.Vec2{
        game.geleira.x * PIXELS_TO_METERS,
        game.geleira.y * PIXELS_TO_METERS,
    }

    game.geleira.body = box2d.CreateBody(game.world, &geleira_def)

    hx := (game.geleira.width / 2.0) * PIXELS_TO_METERS
    hy := (game.geleira.height / 2.0) * PIXELS_TO_METERS
    
    geleira_box := box2d.MakeBox(hx, hy)
    box2d.CreateFixture(game.geleira.body, &geleira_box, 0.0)

    game.player = init_player(game.world)

    game.game_over = false
    return game
}

reset_game :: proc(game: ^Game) {
    pos_inicial := box2d.Vec2{400.0 * PIXELS_TO_METERS, 500.0 * PIXELS_TO_METERS}
    box2d.Body_SetTransform(game.player.body, pos_inicial, 0.0)
    
    box2d.Body_SetLinearVelocity(game.player.body, box2d.Vec2{0.0, 0.0})

    game.game_over = false
}