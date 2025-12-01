extends Area2D
@onready var canvas_layer: CanvasLayer = $"../CanvasLayer"




func _on_body_entered(body: CharacterBody2D) -> void:
	canvas_layer.visible = true
