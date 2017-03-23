enum VertexType {
	case hall, start, end, path
}

class Vertex {
	var type = VertexType.hall
	var left: Edge? = nil
	var top: Edge? = nil
	var right: Edge? = nil
	var bottom: Edge? = nil
	var row: Int
	var column: Int	
	
	init(row: Int, column: Int) {
		self.row = row
		self.column = column	
	}
	
	convenience init(row: Int, column: Int, existingEdge: Edge) {
		self.init(row: row, column: column)

		if existingEdge.position == EdgePosition.left {
			right = existingEdge
			existingEdge.b = self
		}
		else if existingEdge.position == EdgePosition.top {
			bottom = existingEdge
			existingEdge.b = self
		}
		else if existingEdge.position == EdgePosition.right {
			left = existingEdge
			existingEdge.a = self
		}
		else if existingEdge.position == EdgePosition.bottom {
			top = existingEdge
			existingEdge.a = self
		}
		
		existingEdge.position = EdgePosition.placed
	}
	
	func fillEdges(parentMaze: Maze) -> [Edge] {
		var result = [Edge]();
		
		if(left == nil && column > 0) {
			left = Edge(EdgePosition.left)
			left?.a = self
			result.append(left!)
		}
		
		if(top == nil && row > 0){
			top = Edge(EdgePosition.top)
			top?.a = self
			result.append(top!)
		}
		
		if(right == nil && column < parentMaze.width - 1) {
			right = Edge(EdgePosition.right)
			right?.b = self
			result.append(right!)
		}
		
		if(bottom == nil && row < parentMaze.height - 1) {
			bottom = Edge(EdgePosition.bottom)
			bottom?.b = self
			result.append(bottom!)
		}
		
		return result
	}
	
	func toCharacter() -> Character {
		switch(type) {
			case VertexType.start:
				return "S"
			case VertexType.end:			
				return "E"
			case VertexType.path:
				return "."
			default:
				return " "
		}
	}
}