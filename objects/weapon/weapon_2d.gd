class_name Weapon2D
extends Node2D

@export var bullet_scene:PackedScene

@export var fire_range:=200.0: set = set_fire_range

@export var fire_cooldown := 1.0

@onready var _bullet_spawn_location := $BulletSpawnPosition2D
@onready var _cooldown_timer := $CooldownTimer
@onready var _range_area := $RangeArea2D
@onready var _animation_player := $AnimationPlayer
@onready var _range_shape: CircleShape2D = $RangeArea2D/CollisionShape2D.shape
signal fired

func _ready() -> void:
    set_fire_range(fire_range)

func _physics_process(delta: float) -> void:
    if not _cooldown_timer.is_stopped():
        return
    var targets:Array = _range_area.get_overlapping_areas()

    if targets.is_empty():
        return
    var target: Node2D = targets[0] #target first detected target
    shoot_at(target.global_position)

#update the collision radius to be as wide as the fire range
func set_fire_range(new_range:float) -> void:
    fire_range = new_range
    if not is_inside_tree():
        await ready
    _range_shape.radius = fire_range
    
func shoot_at(target_position:Vector2) -> void:
    look_at(target_position)
    _animation_player.play("shoot")

    var bullet = bullet_scene.instantiate()
    add_child(bullet)
    bullet.global_position = _bullet_spawn_location.global_position
    bullet.fly_to(target_position)
    _cooldown_timer.start(fire_cooldown)
    fired.emit()
    pass
