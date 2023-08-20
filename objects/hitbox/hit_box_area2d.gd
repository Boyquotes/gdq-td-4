class_name HitBoxArea2D
extends Area2D

enum Teams {PLAYER, ENEMY}

# We export the value so we can set it from the Inspector.
@export var team:= Teams.PLAYER

@export var damage := 1

## If `true`, this hitbox can deal damage to multiple targets.
@export var can_hit_multiple := false 

func _ready() -> void:
    area_entered.connect(_on_area_entered)

func _on_area_entered(area:Area2D) -> void:
    apply_hit(area) # apply a hit for the area over our hitbox
    pass

func apply_hit(hurt_box:HurtBoxArea2D) -> void:
    if team == hurt_box.team: 
        return
    # We have yet to create the hurt box but we'll define a `get_hurt()` method
    # on it to receive damage.
    hurt_box.get_hurt(damage)

    # If this hitbox can only hit one target, we turn off its `monitoring`
    # property.
    # We use `set_deferred()` to do so because we can't toggle the property
    # while the engine is processing physics.
    set_deferred("monitoring", can_hit_multiple)

    
