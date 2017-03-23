import Glibc

enum EdgeType {
	case wall, hall, path, undefined
}

//This is relative to the vertex that triggered its creation
enum EdgePosition {
	case left, top, right, bottom, placed
}

class Edge {
	var key: Int = random()
	//maze builds out from the top left corner. Point further from that is b
	var a: Vertex? = nil
	var b: Vertex? = nil
	var type: EdgeType = EdgeType.undefined
	var position: EdgePosition
	
	init(_ position: EdgePosition) {
		self.position = position
	}
	
	func toCharacter() -> Character {
		switch(type){
			case EdgeType.wall:			
				return "█"
			case EdgeType.hall:
				return " "
			case EdgeType.path:
				return "."
			default:
				return "?"
		}
	}
}

extension Edge: Comparable { 
	static func < (lhs: Edge, rhs: Edge) -> Bool {		
		return lhs.key < rhs.key
	}
	
	static func <= (lhs: Edge, rhs: Edge) -> Bool {
		return lhs.key <= rhs.key
	}
	
	static func > (lhs: Edge, rhs: Edge) -> Bool {
		return lhs.key < rhs.key
	}
	
	static func >= (lhs: Edge, rhs: Edge) -> Bool {
		return lhs.key <= rhs.key
	}
	
	static func == (lhs: Edge, rhs: Edge) -> Bool {
		return lhs.key == rhs.key
	}
}