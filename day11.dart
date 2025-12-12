import 'dart:io';

Map parseLine(String line) {
    var device = line.substring(0, 3);
    var connections = line.substring(5).split(' ');
    return {device: connections};
}

int countPaths(Map devices, String start, String end) {
    Map cache = {};
    int _countPaths(Map devices, start, end) {
        if (start == end) {
            return 1;
        }
        if (cache.containsKey(start)) {
            return cache[start];
        } else {
            int count = 0;
            for (final next in devices[start] ?? []) {
                count += _countPaths(devices, next, end);
            }
            cache[start] = count;
            return count;
        }
    }
    return _countPaths(devices, start, end);
}

void part1(Map devices) {
    print(countPaths(devices, 'you', 'out'));
}

void part2(Map devices) {
    print(countPaths(devices, 'svr', 'fft') * countPaths(devices, 'fft', 'dac') * countPaths(devices, 'dac', 'out'));
}

void main() {
    var lines = File('day11.input').readAsLinesSync();
    var devices = lines.map(parseLine).reduce((a,b) => a..addAll(b));
    part1(devices);
    part2(devices);
}

