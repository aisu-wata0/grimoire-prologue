LowPoint(G) {
	t = 0
	for each vertex in V(G) (v) {
		v.state = 0
	}

	for each vertex in V(G) (v) {
		if v.state == 0 {
			v.parent = null
			LowPoint(G, v)
		}
	}
}

LowPoint(G, r) {
	r.state = 1
	t++
	r.pre = t
	for each neighbour w {
		if w.state = 0 {
			w.pai = r
			w.lvl = r.lvl + 1
			w.l = w.lvl
			LowPoint(G, w)
			if w.l < r.l {
				r.l = w.l
			}
		} else if w.state = 1 {
			if w.lvl < r.l {
				r.l = w.lvl
			}
		}
	}
	r.state = 2
	t++
	r.pos = t
}

BuscaLargura(G, r) {
	for v in V(G)
		v.state = 0

	Fila f
	r.state = 1
	f.push(r);

	while !f.empty {
		v = f.pop()
		for each v neighbours (n) {

		}
	}
}


ShortestPaths(G, r) {
	Queue q
	r.dist = 0
	r.state = 1
	q.push(r)
	while !q.empty {
		v = q.pop()
		for each v neighbour (n) {
			if n.state == 0 {
				n.parent = v
				n.dist = v.dist + 1
				n.state = 1
				q.push(n)
			}
		}
	}
}

ShortestPaths(G, r) {
	G.bipartite = true
	Queue q
	r.state = 1
	r.dist = 0
	q.push(r)
	while !q.empty {
		v = q.pop()
		for each v neighbour n {
			if (n.state == 0 ) {
				n.parent = v
				n.dist = v.dist + 1
				n.state = 1
				q.push(n)
			} else if (n.state == 1) {
				if (v.dist == n.dist) {
					G.bipartite = false
				}
			}
		}
	}
}
