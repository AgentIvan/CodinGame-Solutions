import math
from operator import sub, add, mul
def hexagonal_to_cubic(col, row):
    x = col - row // 2
    z = row
    y = 0 - x - z
    return x, y, z


def cubic_to_hexagonal(x, y, z):
    col = x + z // 2
    row = z
    return col, row


class Cube:
    def __new__(cls, *args):
        if len(args) == 1:
            arg = args[0]
            if isinstance(arg, Hex):
                args = hexagonal_to_cubic(arg.c, arg.r)
            if isinstance(arg, Cube):
                return arg

        self = super().__new__(cls)
        self.x, self.y, self.z = args
        return self

    def __repr__(self):
        return "Cube({self.x}, {self.y}, {self.z})".format(self=self)

    def __iter__(self):
        """Iteration enables conversion to other data types:
        >>> tuple(Cube(1, 0, -1))
            (1, 0, -1)"""
        yield self.x
        yield self.y
        yield self.z

    def __add__(self, other):
        return Cube(*map(add, self, Cube(other)))

    def __sub__(self, other):
        return Cube(*map(sub, self, Cube(other)))

    def __neg__(self):
        return Cube(0, 0, 0) - self

    def __mul__(self, other: int):
        assert isinstance(other, int)
        assert isinstance(self, Cube)
        return Cube(*(crd * int for crd in self))

    def __len__(self):
        return 3

    def euclidean(self, other=None):
        """The length of the line that connects the centers of the two tiles"""
        if other:
            difference = self - Cube(other)
        else:
            difference = self
        return math.sqrt(sum(map(mul, difference, difference)) / 2)

    def manhattan(self, other=None):
        """The distance between two cells equals the minimum number of cells to 
        go through to get from one to the other. This is the distance the game uses."""
        if other:
            difference = self - Cube(other)
        else:
            difference = self
        return sum(map(abs, difference)) // 2

    def angle(self, other) -> float:
        "Calculate the direction (in the range 0-6) you would have to go from self to other"
        d = Cube(other) - self
        theta = math.atan2(3 * (d.x + d.y), math.sqrt(3) * (d.x - d.y)) / math.radians(60)
        return theta if theta >= 0 else 6 + theta


class Hex:
    def __new__(cls, *args):
        if len(args) == 1:
            arg = args[0]
            if isinstance(arg, Cube):
                args = cubic_to_hexagonal(arg.x, arg.y, arg.z)
            if isinstance(arg, Hex):
                return arg

        self = super().__new__(cls)
        self.c, self.r = args
        return self

    def __repr__(self):
        return "Hex({self.c}, {self.r})".format(self=self)

    def __str__(self):
        return "{self.x} {self.y}".format(self=self)

    def __iter__(self):
        """Iteration enables conversion to other data types:
        >>> tuple(Hex(1, 2))
            (1, 2)"""
        yield self.c
        yield self.r
        
    def __len__(self):
        return 2

    def __add__(self, other):
        return Hex(Cube(self) + Cube(other))

    def __sub__(self, other):
        return Hex(Cube(self) - Cube(other))

    def euclidean(self, other):
        return Cube(self).euclidean(other)

    def manhattan(self, other):
        return Cube(self).manhattan(other)

    def angle(self, other):
        return Cube(self).angle(Cube(other))
