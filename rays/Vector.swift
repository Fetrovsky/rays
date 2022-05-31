//
//  Vector.swift
//  rays
//
//  Created by Daniel Valencia on 4/21/22.
//

// A vector is modeled as the target point when the starting point is the origin.
struct Vector {
    var point: Point

    var x: Double {get {point.x} set {point.x = newValue}}
    var y: Double {get {point.y} set {point.y = newValue}}
    var z: Double {get {point.z} set {point.z = newValue}}

    init(x:Double, y:Double, z:Double) {
        self.point = Point(x:x, y:y, z:z)
    }

    init(x:Int, y:Int, z: Int) {
        self.init(x:Double(x), y:Double(y), z:Double(z))
    }

    public init(p:Point) {
        self.point = p
    }

    init() {
        self.point = Point()
    }

    func add(that:Vector) -> Vector {
        return Vector(x: x + that.x, y: y + that.y, z: z + that.z)
    }

    func add(that:Point) -> Point {
        return self.add(that:Vector(p:that)).point
    }

    func sub(that:Vector) -> Vector {
        return Vector(x: x - that.x, y: y - that.y, z: z - that.z)
    }

    func sub(that:Point) -> Point {
        return self.sub(that:Vector(p:that)).point
    }

    func mul(that:Double) -> Vector {
        return Vector(x: x * that, y: y * that, z: z * that)
    }

    func div(that:Double) -> Vector {
        return Vector(x: x / that, y: y / that, z: z / that)
    }

    func dot(that:Vector) -> Double {
        return (x * that.x) + (y * that.y) + (z * that.z)
    }

    func cross(that:Vector) -> Vector {
        return Vector(
            x: (self.y * that.z) - (self.z * that.y),
            y: (self.z * that.x) - (self.x * that.z),
            z: (self.x * that.y) - (self.y * that.x))
    }

    func getNorm() -> Double {
        return getNormSquared().squareRoot()
    }

    func getNormSquared() -> Double {
        return (point.x * point.x) + (point.y * point.y) + (point.z * point.z)
    }
}
