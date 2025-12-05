import 'dart:io';

void main() {
    var lines = File('day5.input').readAsLinesSync();
    part1(lines);
    part2(lines);
}

class Range {
    int min=0, max=0;
    Range(this.min, this.max);
    Range.fromString(String s) {
        var list = s.split('-').map(int.parse);
        min = list.first;
        max = list.last;
    }
    bool contains(int i) {
        return min <= i && i <= max;
    }
    bool overlaps(Range other) {
        return other.contains(min) || contains(other.min);
    }
    void merge(Range other) {
        min = (min < other.min) ? min : other.min;
        max = (max > other.max) ? max : other.max;
    }
}

void part1(List lines) {
    var i = lines.indexOf('');
    var ranges = lines.sublist(0,i).map((s) => Range.fromString(s));
    var ids = lines.sublist(i+1).map((id) => int.parse(id));
    print(ids.map((id) => ranges.map((r) => r.contains(id)).reduce((a,b) => a || b)).where((x) => x == true).length);
}

void part2(List lines) {
    var i = lines.indexOf('');
    var ranges = lines.sublist(0,i).map((s) => Range.fromString(s)).toList();
    while (true) {
        List<Range> next = [];
        for (int i=0; i < ranges.length; i++) {
            bool merged = false;
            for (int j=i+1; j < ranges.length; j++) {
                if (ranges[j].overlaps(ranges[i])) {
                    ranges[j].merge(ranges[i]);
                    merged = true;
                }
            }
            if (!merged) {
                next.add(ranges[i]);
            }
        }
        if (ranges.length == next.length) break;
        ranges = next;
    }
    print(ranges.map((r) => r.max-r.min+1).reduce((a,b) => a+b));
}

