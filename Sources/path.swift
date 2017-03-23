class Path {
	let vertex: Vertex 
	var edge: Edge?
	var next: Path? = nil
	
	init(withVertex: Vertex){
		vertex = withVertex
	}
}