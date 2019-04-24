extends Node

const DEFAULT_FREEZE := 40


func freeze_frame(delay: int = DEFAULT_FREEZE) -> void:
	OS.delay_msec(delay)
