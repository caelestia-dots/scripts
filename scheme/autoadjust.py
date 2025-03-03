#!/bin/python3

import sys
from math import sqrt
from colorsys import rgb_to_hls, hls_to_rgb

light_colours = [
    "dc8a78",
    "dd7878",
    "ea76cb",
    "8839ef",
    "d20f39",
    "e64553",
    "fe640b",
    "df8e1d",
    "40a02b",
    "179299",
    "04a5e5",
    "209fb5",
    "1e66f5",
    "7287fd",
]

dark_colours = [
    "f5e0dc",
    "f2cdcd",
    "f5c2e7",
    "cba6f7",
    "f38ba8",
    "eba0ac",
    "fab387",
    "f9e2af",
    "a6e3a1",
    "94e2d5",
    "89dceb",
    "74c7ec",
    "89b4fa",
    "b4befe",
]

def hex_to_rgb(hex: str) -> tuple[int, int, int]:
    """Convert a hex string to an RGB tuple in the range [0, 1]."""
    return tuple(int(hex[i:i+2], 16) / 255 for i in (0, 2, 4))

def rgb_to_hex(rgb: tuple[int, int, int]) -> str:
    """Convert an RGB tuple in the range [0, 1] to a hex string."""
    return "".join(f"{round(i * 255):02X}" for i in rgb)

def hex_to_hls(hex: str) -> tuple[float, float, float]:
    return rgb_to_hls(*hex_to_rgb(hex))

def adjust(hex: str, light: float = 0, sat: float = 0) -> str:
    h, l, s = hex_to_hls(hex)
    l = max(0, min(1, l + light))
    s = max(0, min(1, s + sat))
    return rgb_to_hex(hls_to_rgb(h, l, s))

def distance(colour: str, base: str) -> float:
    r1, g1, b1 = hex_to_rgb(colour)
    r2, g2, b2 = hex_to_rgb(base)
    return sqrt((r2 - r1)**2 + (g2 - g1)**2 + (b2 - b1)**2)

def smart_sort(colours: list[str], base: list[str]) -> list[str]:
    sorted_colours = [None] * len(colours)
    distances = {}

    for colour in colours:
        dist = [(i, distance(colour, b)) for i, b in enumerate(base)]
        dist.sort(key=lambda x: x[1])
        distances[colour] = dist

    for colour in colours:
        while len(distances[colour]) > 0:
            i, dist = distances[colour][0]

            if sorted_colours[i] is None:
                sorted_colours[i] = colour, dist
                break
            elif sorted_colours[i][1] > dist:
                old = sorted_colours[i][0]
                sorted_colours[i] = colour, dist
                colour = old

            distances[colour].pop(0)

    return [i[0] for i in sorted_colours]

def mix(a: str, b: str, w: float) -> str:
    r1, g1, b1 = hex_to_rgb(a)
    r2, g2, b2 = hex_to_rgb(b)
    return rgb_to_hex((r1 * (1 - w) + r2 * w, g1 * (1 - w) + g2 * w, b1 * (1 - w) + b2 * w))

def mix_colours(colours: list[str], base: list[str], amount: float) -> list[str]:
    for i, b in enumerate(base):
        colours[i] = mix(colours[i], b, amount)

if __name__ == "__main__":
    light = sys.argv[1] == "light"

    added_sat = 0.5 if light else 0.1
    base = light_colours if light else dark_colours

    colours = []
    for colour in sys.argv[3].split(" ")[1:]:
        colours.append(adjust(colour, sat=added_sat))  # TODO: optional adjust

    colours = smart_sort(colours, base)  # TODO: optional smart sort

    mix_colours(colours, base, 0)  # TODO: customize mixing from config

    for colour in colours:
        print(colour)

    for layer in sys.argv[4:]:
        print(layer.split(" ")[0])

    # Success and error colours # TODO: customize mixing
    print(mix(colours[8], base[8], 0.9))  # Success (green)
    print(mix(colours[4], base[4], 0.9))  # Error (red)
