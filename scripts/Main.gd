extends Node2D

const MAP_WIDTH = 20
const MAP_HEIGHT = 20
const TILE_SIZE = 64

var food = 10
var wood = 20

var tile_scene = preload("res://scenes/Tile.tscn")
var peasant_scene = preload("res://scenes/Peasant.tscn")
var farm_scene = preload("res://scenes/Farm.tscn")
var crop_scene = preload("res://scenes/Crop.tscn")
var storehouse_position = Vector2(10, 10)

var tile_grid = []
var player_units = []
var farms = []
var crops = []

func _ready():
    generate_map()
    spawn_peasant(Vector2(5, 5))
    setup_ui()

func generate_map():
    for y in range(MAP_HEIGHT):
        var row = []
        for x in range(MAP_WIDTH):
            var tile = tile_scene.instance()
            tile.position = Vector2(x, y) * TILE_SIZE
            add_child(tile)
            row.append(tile)
        tile_grid.append(row)

func spawn_peasant(tile_pos):
    var unit = peasant_scene.instance()
    unit.position = tile_pos * TILE_SIZE
    unit.connect("build_request", self, "build_farm")
    add_child(unit)
    player_units.append(unit)

func build_farm(tile_pos):
    if wood >= 10:
        var farm = farm_scene.instance()
        farm.position = tile_pos * TILE_SIZE
        add_child(farm)
        farms.append(farm)
        wood -= 10

func _process(delta):
    get_node("HUD/FoodLabel").text = "Хлеб: %d" % food
    get_node("HUD/WoodLabel").text = "Дерево: %d" % wood

    for farm in farms:
        farm.time_since_last_production += delta
        if farm.time_since_last_production > 10.0:
            var crop = crop_scene.instance()
            crop.position = farm.position + Vector2(16, 16)
            add_child(crop)
            crops.append(crop)
            farm.time_since_last_production = 0

    for unit in player_units:
        if unit.has_task == false and crops.size() > 0:
            var target_crop = crops.pop_front()
            unit.assign_task(target_crop, storehouse_position)
            break

func setup_ui():
    var build_button = Button.new()
    build_button.text = "Построить ферму"
    build_button.rect_position = Vector2(20, 20)
    build_button.connect("pressed", self, "on_build_farm_button_pressed")
    get_node("HUD").add_child(build_button)

func on_build_farm_button_pressed():
    var tile_pos = Vector2(7, 7)
    build_farm(tile_pos)
