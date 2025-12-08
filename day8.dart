import 'dart:io';
import 'dart:math';
import 'dart:collection';

void main() {
    var lines = File('day8.input').readAsLinesSync();
    var boxes = parseBoxes(lines).toList();
    var distances = calculateDistances(boxes);

    Map circuits = {};
    for (final b in boxes)
        circuits[b] = { b };

    part1(circuits, distances);
    part2(circuits, distances);
}

void part1(circuits, distances) {
    for (final [a,b] in distances.values.toList().sublist(0,1000)) {
        circuits[a].addAll(circuits[b]);
        for (final e in circuits[a])
            circuits[e] = circuits[a];
    }
    var sizes = circuits.values.toSet().map((s) => s.length).toList()..sort();
    print(sizes.sublist(sizes.length-3).reduce((a,b) => a*b));
}

void part2(circuits, distances) {
    for (final [a,b] in distances.values.toList().sublist(1000)) {
        circuits[a].addAll(circuits[b]);
        for (final e in circuits[a])
            circuits[e] = circuits[a];
        if (circuits[a].length == circuits.length) {
            print(a.x*b.x);
            break;
        }
    }
}

class JunctionBox {
    int x,y,z;
    JunctionBox(this.x, this.y, this.z);
}

Iterable parseBoxes(List lines) sync* {
    for (final [x,y,z] in lines.map((line) => line.split(',').map(int.parse).toList())) {
        yield JunctionBox(x,y,z);
    }
}

SplayTreeMap<num, List> calculateDistances(List boxes) {
    var distances = SplayTreeMap<num, List>();
    for (int i=0; i<boxes.length; i++) {
        for (int j=i+1; j<boxes.length; j++) {
            var d = distance(boxes[i], boxes[j]);
            distances[d] = [boxes[i], boxes[j]];
        }
    }
    return distances;
}

num distance(a, b) {
    return sqrt(pow(b.x-a.x, 2) + pow(b.y-a.y, 2) + pow(b.z-a.z, 2));
}
