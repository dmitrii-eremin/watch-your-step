extends CanvasLayer

func change_scene(path: String):
	# Käynnistä animaatio (esim. shaderin 'progress' -arvon nostaminen)
	var tween = create_tween()
	tween.tween_property($ColorRect.material, "shader_parameter/progress", 1.0, 0.5)
	await tween.finished
	
	# Vaihda skene
	get_tree().change_scene_to_file(path)
	
	# Animaatio takaisin päin
	var tween_out = create_tween()
	tween_out.tween_property($ColorRect.material, "shader_parameter/progress", 0.0, 0.5)
