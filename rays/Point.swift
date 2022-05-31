//
//  Point.swift
//  rays
//
//  Created by Daniel Valencia on 4/21/22.
//

// Represents a point in 3D Space.

struct Point {
    var x: Double
    var y: Double
    var z: Double

    init(x:Double, y:Double, z:Double) {
        self.x = x
        self.y = y
        self.z = z
    }

    init(x:Int, y:Int, z: Int) {
        self.init(x:Double(x), y:Double(y), z:Double(z))
    }

    init() {
        self.init(x:0, y:0, z:0)
    }

    func asVector() -> Vector {
        return Vector(p:self)
    }

    func distanceSquared(to:Point) -> Double {
        return to.asVector().sub(that:self.asVector()).getNormSquared()
    }

    func distanceTo(that:Point) -> Double {
        return distanceSquared(to:that).squareRoot()
    }

    func add(that:Vector) -> Point {
        return self.asVector().add(that:that).point
    }

    func sub(that:Vector) -> Point {
        return self.asVector().sub(that:that).point
    }

    func mul(that:Double) -> Point {
        return self.asVector().mul(that:that).point
    }

    func div(that:Double) -> Point {
        return self.asVector().div(that:that).point
    }
}
