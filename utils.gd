class_name Utils


enum ShakeType {
	SMALL,
	MEDIUM,
	BIG,
	EXPLOSION
	}

const SHAKE_CONFIGS: Dictionary = {
	ShakeType.SMALL: {
		"offset": Vector2(8.0, 6.0),
		"reduction": 7.0,
		"frequency": 50.0
	},
	ShakeType.MEDIUM: {
		"offset": Vector2(15.0, 12.0),
		"reduction": 5.0,
		"frequency": 40.0
	},
	ShakeType.BIG: {
		"offset": Vector2(25.0, 20.0),
		"reduction": 3.5,
		"frequency": 35.0
	},
	ShakeType.EXPLOSION: {
		"offset": Vector2(35.0, 30.0),
		"reduction": 2.5,
		"frequency": 30.0
	}
}
