prefix operator * {}

prefix func *<T>(v: Parameter<T>) -> T {
    return v.value()
}

protocol Param {
	associatedtype ParamType
	func setValue(newValue: ParamType)
	func value() -> ParamType
}

public class Parameter<T>: Param {
	public init(name: String, initialValue val: T) {
		self.name = name
		self.val = val
	}

	public convenience init(_ val: T) {
		self.init(name: "Unnamed", initialValue: val)
	}

	func value() -> T {
		return val
	}

	func type() -> String {
		return "\(T.self)"
	}

	func setValue(newValue: T) {
		val = newValue
	}

	public let name: String
	var val: T
}

public class IntParam: Parameter<Int> {
	override public init(name: String, initialValue val: Int) {
		super.init(name: name, initialValue: val)
	}
}

public class DoubleParam: Parameter<Double> {
	override public init(name: String, initialValue val: Double) {
		super.init(name: name, initialValue: val)
	}
}

public class StringParam: Parameter<String> {
	override public init(name: String, initialValue val: String) {
		super.init(name: name, initialValue: val)
	}	
}
