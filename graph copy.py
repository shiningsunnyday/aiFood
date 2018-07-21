class Vertex:
    def __init__(self, node):
        self.id = node
        self.adjacent = {}

    def __str__(self):
        return str(self.id) + ' adjacent: ' + str([x.id for x in self.adjacent])

    def add_neighbor(self, neighbor, weight=0):
        self.adjacent[neighbor] = weight

    def get_connections(self):
        return self.adjacent.keys()  

    def get_id(self):
        return self.id

    def get_weight(self, neighbor):
        
        if neighbor in self.adjacent.keys():
            return self.adjacent[neighbor]
        
        return 0

class Graph:
    def __init__(self):
        self.vert_dict = {}
        self.num_vertices = 0

    def __iter__(self):
        return iter(self.vert_dict.values())

    def add_vertex(self, node):
        self.num_vertices = self.num_vertices + 1
        new_vertex = Vertex(node)
        self.vert_dict[node] = new_vertex
        return new_vertex

    def get_vertex(self, n):
        if n in self.vert_dict:
            return self.vert_dict[n]
        else:
            return None

    def add_edge(self, frm, to):
        if frm not in self.vert_dict:
            self.add_vertex(frm)
        if to not in self.vert_dict:
            self.add_vertex(to)
        
        vertex1 = self.vert_dict[frm]
        vertex2 = self.vert_dict[to]
        
        if vertex1 not in vertex2.get_connections():
            vertex1.add_neighbor(vertex2, 0)
            vertex2.add_neighbor(vertex1, 0)
        
        weight = vertex1.get_weight(vertex2)
        
        vertex1.adjacent[vertex2] = weight + 1
        vertex2.adjacent[vertex1] = weight + 1

    def get_vertices(self):
        return self.vert_dict.keys()
