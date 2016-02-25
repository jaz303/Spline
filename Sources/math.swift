import Foundation

public func abs(x: Int) -> Int {
	return Int(Foundation.abs(Int32(x)))
}

public func abs(x: Double) -> Double {
	return Foundation.fabs(x)
}

public func ceil(x: Double) -> Double {
	return Foundation.ceil(x)
}

// TODO: generics?
public func clamp(val: Double, min: Double, max: Double) -> Double {
	if (val < min) { return min }
	if (val > max) { return max }
	return val
}

// TODO: generics?
public func clamp(val: Int, min: Int, max: Int) -> Int {
	if (val < min) { return min }
	if (val > max) { return max }
	return val
}

public func distsq(x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) -> Double {
	let dx = x2 - x1, dy = y2 - y1
	return dx*dx + dy*dy
}

public func distsq(x1: Double, _ y1: Double, _ z1: Double, _ x2: Double, _ y2: Double, _ z2: Double) -> Double {
	let dx = x2 - x1, dy = y2 - y1, dz = z2 - z1
	return dx*dx + dy*dy + dz*dz
}

public func dist(x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) -> Double {
	let dx = x2 - x1, dy = y2 - y1
	return Foundation.sqrt(dx*dx + dy*dy)
}

public func dist(x1: Double, _ y1: Double, _ z1: Double, _ x2: Double, _ y2: Double, _ z2: Double) -> Double {
	let dx = x2 - x1, dy = y2 - y1, dz = z2 - z1
	return Foundation.sqrt(dx*dx + dy*dy + dz*dz)
}

public func exp(x: Double) -> Double {
	return Foundation.exp(x)
}

public func floor(val: Double) -> Double {
	return Foundation.floor(val)
}

public func lerp(val: Double, from: Double, to: Double) -> Double {
	return from + (to - from) * val
}

public func log(x: Double) -> Double {
	return Foundation.log(x)
}

public func mag(x: Double, _ y: Double) -> Double {
	return dist(0, 0, x, y)
}

public func magsq(x: Double, _ y: Double) -> Double {
	return distsq(0, 0, x, y)
}

public func mag(x: Double, _ y: Double, _ z: Double) -> Double {
	return dist(0, 0, 0, x, y, z)
}

public func magsq(x: Double, _ y: Double, _ z: Double) -> Double {
	return distsq(0, 0, 0, x, y, z)
}

public func map(val: Double, from fromLow: Double, _ fromHigh: Double, to toLow: Double, _ toHigh: Double) -> Double {
	let amt = (val - fromLow) / (fromHigh - fromLow)
	return toLow + (toHigh - toLow) * amt
}

public func norm(val: Double, low: Double, high: Double) -> Double {
	return map(val, from: low, high, to: 0, 1)
}

public func pow(val: Double, exp: Double) -> Double {
	return Foundation.pow(val, exp)
}

public func round(val: Double) -> Double {
	return Foundation.round(val)
}

public func sq(val: Int) -> Int {
	return val * val
}

public func sq(val: Double) -> Double {
	return val * val
}

public func sqrt(val: Double) -> Double {
	return Foundation.sqrt(val)
}