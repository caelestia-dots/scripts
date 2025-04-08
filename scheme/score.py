#!/bin/python

import sys

from materialyoucolor.quantize import ImageQuantizeCelebi
from materialyoucolor.hct import Hct
from materialyoucolor.utils.math_utils import sanitize_degrees_int, difference_degrees
from materialyoucolor.dislike.dislike_analyzer import DislikeAnalyzer


class Score:
    TARGET_CHROMA = 48.0
    WEIGHT_PROPORTION = 0.7
    WEIGHT_CHROMA_ABOVE = 0.3
    WEIGHT_CHROMA_BELOW = 0.1
    CUTOFF_CHROMA = 5.0
    CUTOFF_EXCITED_PROPORTION = 0.01

    def __init__(self):
        pass

    @staticmethod
    def score(colors_to_population: dict) -> list[int]:
        desired = 14
        filter_enabled = False
        dislike_filter = True

        colors_hct = []
        hue_population = [0] * 360
        population_sum = 0

        for rgb, population in colors_to_population.items():
            hct = Hct.from_int(rgb)
            colors_hct.append(hct)
            hue = int(hct.hue)
            hue_population[hue] += population
            population_sum += population

        hue_excited_proportions = [0.0] * 360

        for hue in range(360):
            proportion = hue_population[hue] / population_sum
            for i in range(hue - 14, hue + 16):
                neighbor_hue = int(sanitize_degrees_int(i))
                hue_excited_proportions[neighbor_hue] += proportion

        # Score colours
        scored_hct = []
        for hct in colors_hct:
            hue = int(sanitize_degrees_int(round(hct.hue)))
            proportion = hue_excited_proportions[hue]

            if filter_enabled and (
                hct.chroma < Score.CUTOFF_CHROMA
                or proportion <= Score.CUTOFF_EXCITED_PROPORTION
            ):
                continue

            proportion_score = proportion * 100.0 * Score.WEIGHT_PROPORTION
            chroma_weight = (
                Score.WEIGHT_CHROMA_BELOW
                if hct.chroma < Score.TARGET_CHROMA
                else Score.WEIGHT_CHROMA_ABOVE
            )
            chroma_score = (hct.chroma - Score.TARGET_CHROMA) * chroma_weight
            score = proportion_score + chroma_score
            scored_hct.append({"hct": hct, "score": score})

        scored_hct.sort(key=lambda x: x["score"], reverse=True)

        # Choose distinct colours
        chosen_colors = []
        for difference_degrees_ in range(90, 0, -1):
            chosen_colors.clear()
            for hct in [item["hct"] for item in scored_hct]:
                duplicate_hue = any(
                    difference_degrees(hct.hue, chosen_hct.hue) < difference_degrees_
                    for chosen_hct in chosen_colors
                )
                if not duplicate_hue:
                    chosen_colors.append(hct)
                if len(chosen_colors) >= desired:
                    break
            if len(chosen_colors) >= desired:
                break

        # Get primary colour
        got_primary = False
        for cutoff in range(20, 0, -1):
            for item in scored_hct:
                if item["hct"].chroma > cutoff and item["hct"].tone > cutoff * 3:
                    chosen_colors.insert(0, item["hct"])
                    got_primary = True
                    break
            if got_primary:
                break

        # Fix disliked colours
        if dislike_filter:
            for chosen_hct in chosen_colors:
                chosen_colors[chosen_colors.index(chosen_hct)] = (
                    DislikeAnalyzer.fix_if_disliked(chosen_hct)
                )

        return chosen_colors


if __name__ == "__main__":
    img = sys.argv[1]

    colours = ImageQuantizeCelebi(img, 1, 128)
    colours = [c.to_rgba()[:3] for c in Score.score(colours)]

    # print("".join(["\x1b[48;2;{};{};{}m   \x1b[0m".format(*colour) for colour in colours]))
    print(" ".join(["{:02X}{:02X}{:02X}".format(*colour) for colour in colours]))
