//
//  Light.swift
//  rays
//
//  Created by Daniel Valencia on 4/21/22.
//

struct Light: Thing {
    var location: Point {get {shape.location} set {shape.location = newValue}}
    var color: Color {get {shape.color} set {shape.color = newValue}}
    var intensity: Double
    var shape: Sphere

    func intersect(startingPoint:Point, vector:Vector) -> [Intersection] {
        return shape.intersect(startingPoint:startingPoint, vector:vector)
    }

    init(point:Point, r:Double, color:Color, i:Double) {
        self.shape = Sphere(point:point, r:r, color:color)
        self.intensity = i
    }

    init(x:Double, y:Double, z:Double, r:Double, color:Color, i:Double) {
        self.init(point:Point(x:x, y:y, z:z), r:r, color:color, i:i)
    }
}
