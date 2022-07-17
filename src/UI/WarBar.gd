extends Control

func set_value(value : float) -> void:
	$Tween.interpolate_property($TextureProgress, "value", $TextureProgress.value, value, 0.7 , Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.interpolate_property($TextureRect, "anchor_left", $TextureRect.anchor_left, value, 0.7 , Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.interpolate_property($TextureRect, "anchor_right", $TextureRect.anchor_right, value, 0.7 , Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
