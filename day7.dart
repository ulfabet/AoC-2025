import 'dart:io';

const start = 'S';
const splitter = '^';

void main() {
    var lines = File('day7.input').readAsLinesSync();
    part1(lines);
    part2(lines);
}

int sum(a, b) { return a+b; }

void part1(List lines) {
    Set beams = { lines.first.indexOf(start) };
    int count = 0;
    for (final line in lines.sublist(1)) {
        Set splitters = splitter.allMatches(line).map((m) => m.start).toSet();
        Set beamsToSplit = beams.intersection(splitters);
        if (beamsToSplit.isNotEmpty) {
            count += beamsToSplit.length;
            Set splitBeams = {};
            for (final beam in beamsToSplit) {
                splitBeams.add(beam-1);
                splitBeams.add(beam+1);
            }
            beams = beams.difference(beamsToSplit);
            beams = beams.union(splitBeams);
        }
    }
    print(count);
}

void part2(List lines) {
    List beams = List.filled(lines.first.length, 0);
    beams[lines.first.indexOf(start)] = 1;
    for (final line in lines.sublist(1)) {
        for (final i in splitter.allMatches(line).map((m) => m.start)) {
            int n = beams[i];
            if (n > 0) {
                beams[i-1] += n;
                beams[i+1] += n;
                beams[i] = 0;
            }
        }
    }
    print(beams.reduce(sum));
}
