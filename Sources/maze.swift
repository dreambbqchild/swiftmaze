import Glibc
import SwiftPriorityQueue

class Maze {
	var width: Int
	var height: Int
	var edgeQueue = PriorityQueue<Edge>()
	var verticies: [Vertex?]
	var startingVertex: Vertex?	
	
	init(width: Int, height: Int) {
		self.width = width
		self.height = height
		
		verticies = [Vertex?](repeating: nil, count: width * height)
		
		print("Ready to render maze that's \(width) x \(height) in size")
	}
	
	private func collectNewEdges(fromVertex: Vertex) {
		let edges = fromVertex.fillEdges(parentMaze: self)
		
		for edge in edges {
			edgeQueue.push(edge)
		}
	}
	
	private func positionFor(vertex: Vertex, edge: Edge) -> (column: Int, row: Int) {
		if edge.position == EdgePosition.left {
			return (vertex.column - 1, vertex.row)
		}
		else if edge.position == EdgePosition.top {
			return (vertex.column, vertex.row - 1)
		}
		else if edge.position == EdgePosition.right {
			return (vertex.column + 1, vertex.row)
		}
		else if edge.position == EdgePosition.bottom {
			return (vertex.column, vertex.row + 1)
		}
		
		return (-1, -1)
	}
	
	private func findFurthestVertex(currentVertex: Vertex, lastVertex: Vertex?, distance: Int) -> (vertex: Vertex, distance: Int, path: Path) {
		let path = Path(withVertex: currentVertex)
		var result = (vertex: currentVertex, distance: distance, path: path)
		let edges = [currentVertex.left, currentVertex.top, currentVertex.right, currentVertex.bottom]
		
		for potentialEdge in edges {
			if let edge = potentialEdge {
				if edge.type != EdgeType.hall {
					continue
				}
				
				let nextVertex = (edge.a === currentVertex ? edge.b : edge.a)
				if nextVertex !== lastVertex  {
					let info = findFurthestVertex(currentVertex: nextVertex!, lastVertex: currentVertex, distance: distance + 1)
					if info.distance > result.distance {					
						result = info
						path.next = result.path
						path.edge = edge
						result.path = path
					}
				}
			}
		}		
		
		return result
	}
	
	private func placeEntrance() {
		let row = random() % height
		let column = 0 //random() % width		
		let first = Vertex(row: row, column: column)
		first.type = VertexType.start
		
		verticies[row * width + column] = first
		startingVertex = first
		
		collectNewEdges(fromVertex: first)
	}
	
	func build() {
		print("Placing start")
		placeEntrance()
		
		print("Placing edges")
		while(!edgeQueue.isEmpty) {
			if let edge = edgeQueue.pop() {
				let placedVertex = (edge.a ?? edge.b)!
				let nextPosition = positionFor(vertex: placedVertex, edge: edge)
				let index = nextPosition.row * width + nextPosition.column
				
				if verticies[index] != nil {
					edge.type = EdgeType.wall
					if edge.a == nil {
						edge.a = verticies[index]
					} else {
						edge.b = verticies[index]
					}
					continue
				}		
				
				edge.type = EdgeType.hall
				
				let newVertex = Vertex(row: nextPosition.row, column: nextPosition.column, existingEdge: edge)
				verticies[index] = newVertex
				collectNewEdges(fromVertex: newVertex)
			}
		}
		
		print("Finding furthest for exit")
		let furthest = findFurthestVertex(currentVertex: startingVertex!, lastVertex: nil, distance: 0)
		furthest.vertex.type = VertexType.end
		
		var path: Path? = furthest.path
		while(path != nil) {
			if path?.vertex.type == VertexType.hall {
				path?.vertex.type = VertexType.path
			}
			path?.edge?.type = EdgeType.path
			path = path?.next
		}
		
		print("")
	}	
	
	func render() -> String {
		var result = ""
		
		for row in 0...height - 1 {
					
			for column in 0...width - 1 {					
				if row > 0 {
					result.append("█")
					result.append(verticies[row * width + column]!.top!.toCharacter())			
				} else {
					result.append("██")
				}
			}
			result.append("█\n")
			
			for column in 0...width - 1 {
				if column > 0 {
					result.append(verticies[row * width + column]!.left!.toCharacter())
				} else {
					result.append("█")					
				}
				
				result.append(verticies[row * width + column]!.toCharacter())
			}
			
			result.append("█\n")
		}
		
		let bottom = String(repeating: "█", count: width * 2 + 1);
		result.append(bottom)
		
		return result
	}
}