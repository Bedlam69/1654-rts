extends CharacterBody2D

var has_task = false
var target_crop = null
var target_pos = Vector2()

func assign_task(crop_node, storehouse_pos):
    has_task = true
    target_crop = crop_node
    target_pos = storehouse_pos

func _physics_process(delta):
    if has_task and target_crop:
        var direction = (target_crop.global_position - global_position).normalized()
        velocity = direction * 40
        move_and_slide()

        if global_position.distance_to(target_crop.global_position) < 8:
            # Поднял урожай
            target_crop.queue_free()
            target_crop = null
            target_pos = get_parent().storehouse_position

        elif target_crop == null and target_pos != null:
            var dir2 = (target_pos - global_position).normalized()
            velocity = dir2 * 40
            move_and_slide()
            if global_position.distance_to(target_pos) < 8:
                has_task = false
