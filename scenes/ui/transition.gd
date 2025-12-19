extends CanvasLayer

func change_scene(path: String):
	var tween = create_tween()
	tween.tween_property($ColorRect.material, "shader_parameter/progress", 1.0, 0.5)
	await tween.finished
	
	get_tree().change_scene_to_file(path)

	var tween_out = create_tween()
	tween_out.tween_property($ColorRect.material, "shader_parameter/progress", 0.0, 0.5)
