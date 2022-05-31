//
//  Shape.swift
//  rays
//
//  Created by Daniel Valencia on 4/20/22.
//

protocol Shape: Thing {
    var color: Color {get set}

    func intersect(startingPoint:Point, vector:Vector) -> [Intersection]
}

struct Intersection {
    let point: Point
    let orthoNormal: Vector
    let distance: Double
}

struct Sphere: Shape {
    var location: Point
    var radius: Double
    var color: Color

    init(point: Point, r: Double, color: Color) {
        self.location = point
        self.radius = r
        self.color = color
    }

    init(x:Double, y:Double, z:Double, r:Double, c: Color) {
        self.init(point:Point(x:x, y:y, z:z), r:r, color:c)
    }

    func intersect(startingPoint:Point, vector:Vector) -> [Intersection] {
        // d = (-b +/- sqrt(b² - 4ac)) / 2a
        //
        // where:
        //  a = 1
        //  b = 2 * (vector ・ (startingPoint - center))
        //  c = |startingPoint - center|² - radius²
        //
        // center ≡ location

        let a: Double = 1.0
        let b: Double = startingPoint.sub(that:location.asVector()).asVector().dot(that:vector) * 2.0
        let c: Double = startingPoint.sub(that:location.asVector()).asVector().getNormSquared() - (radius * radius)
        
        let twoA: Double = 2 * a
        let termBesidesSquareRoot: Double = -b / twoA
        let thingInsideSquareRoot: Double = (b * b) - (4 * a * c)

        if (thingInsideSquareRoot < 0) {
            return []
        } else
        if (thingInsideSquareRoot == 0) {
            let d = termBesidesSquareRoot
            return [makeIntersection(startingPoint:startingPoint, vector:vector, distance:d)]
        } else {
            let d1 = termBesidesSquareRoot - (thingInsideSquareRoot.squareRoot() / twoA)
            let d2 = termBesidesSquareRoot + (thingInsideSquareRoot.squareRoot() / twoA)
            return [
                makeIntersection(startingPoint:startingPoint, vector:vector, distance:d1),
                makeIntersection(startingPoint:startingPoint, vector:vector, distance:d2)]
        }
    }
    
    func makeIntersection(startingPoint:Point, vector:Vector, distance:Double) -> Intersection {
        let intersectionPoint = startingPoint.add(that:vector.mul(that:distance))
        let normal = intersectionPoint.asVector().sub(that:location.asVector())
        let orthoNormal = normal.div(that:normal.getNorm())
        return Intersection(point:intersectionPoint, orthoNormal:orthoNormal, distance:distance)
    }
}

