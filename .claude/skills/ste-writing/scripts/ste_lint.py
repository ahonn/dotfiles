#!/usr/bin/env python3
"""Count-based checks for prose written with the ste-writing skill.

Checks sentence length, semicolons, dashes that join clauses, comma chains in
Chinese sentences, and paragraph length. Word choice, voice, and hedges need
judgment, so this script does not check them.

Usage: ste_lint.py [--strict] [--lang auto|en|zh] [FILE ...]
Reads stdin when no FILE is given. Exit status: 0 clean, 1 findings, 2 error.
"""

import argparse
import re
import sys

# Sentence limits as (prose, strict). English counts words. Chinese counts
# units: one unit is one CJK character or one Latin word, number, or code span.
LIMITS = {"en": (25, 20), "zh": (40, 32)}
MAX_PARAGRAPH_SENTENCES = 6
MAX_ZH_CLAUSES = 3

CJK = "㐀-䶿一-鿿"
CJK_CHAR = re.compile("[%s]" % CJK)
# A hyphenated word, a path, and a dotted name each count as one word.
WORD = re.compile(r"[A-Za-z0-9]+(?:[-'’._/][A-Za-z0-9]+)*")

FENCE = re.compile(r"^\s*(?:```|~~~)")
# Headings, table rows, block quotes, and HTML comments are not prose to check.
SKIPPED_LINE = re.compile(r"^\s*(?:#|\||>|<!--)")
LIST_ITEM = re.compile(r"^\s*(?:[-*+]|\d+[.)])\s+")

INLINE_CODE = re.compile(r"`[^`]*`")
LINK = re.compile(r"!?\[([^\]]*)\]\([^)]*\)")
URL = re.compile(r"https?://\S+")
EMPHASIS = re.compile(r"\*{1,3}|_{2,3}")

ABBREVIATIONS = ("e.g.", "i.e.", "etc.", "vs.", "cf.")
EN_SENTENCE_END = re.compile(r"(?<=[.!?])[\"')\]]*\s+")
ZH_SENTENCE_END = re.compile(r"(?<=[。！？])|(?<=[.!?])\s+")
JOINING_DASH = re.compile(r"—|\s(?:–|--)\s")


def blocks(text):
    """Return (line_number, prose) for each paragraph and each list item."""
    lines = text.splitlines()
    first = 0
    if lines and lines[0].strip() == "---":  # YAML front matter
        for index in range(1, len(lines)):
            if lines[index].strip() == "---":
                first = index + 1
                break

    found = []
    current = []
    current_line = 0
    in_fence = False
    for number, line in enumerate(lines[first:], first + 1):
        is_fence = bool(FENCE.match(line))
        is_item = bool(LIST_ITEM.match(line))
        is_boundary = is_fence or in_fence or not line.strip() or bool(SKIPPED_LINE.match(line))
        if current and (is_boundary or is_item):
            found.append((current_line, " ".join(current)))
            current = []
        if is_fence:
            in_fence = not in_fence
        if is_boundary:
            continue
        if not current:
            current_line = number
        current.append(LIST_ITEM.sub("", line).strip())
    if current:
        found.append((current_line, " ".join(current)))
    return found


def clean(prose):
    """Reduce Markdown inline syntax to the words that a reader sees."""
    prose = INLINE_CODE.sub(" CODE ", prose)
    prose = LINK.sub(r"\1", prose)
    prose = URL.sub(" URL ", prose)
    return re.sub(r"\s+", " ", EMPHASIS.sub("", prose))


def detect_language(prose):
    cjk = len(CJK_CHAR.findall(prose))
    latin = len(re.findall(r"[A-Za-z]+", prose))
    return "zh" if cjk > latin else "en"


def sentences(prose, language):
    for abbreviation in ABBREVIATIONS:
        prose = prose.replace(abbreviation, abbreviation.replace(".", ""))
    pattern = ZH_SENTENCE_END if language == "zh" else EN_SENTENCE_END
    return [part.strip() for part in pattern.split(prose) if part.strip()]


def size(sentence, language):
    words = len(WORD.findall(sentence))
    if language == "zh":
        return words + len(CJK_CHAR.findall(sentence))
    return words


def check_sentence(sentence, language, limit):
    count = size(sentence, language)
    if count > limit:
        unit = "units" if language == "zh" else "words"
        yield "sentence-length", "%d %s, limit %d" % (count, unit, limit)
    if ";" in sentence or "；" in sentence:
        yield "semicolon", "split the sentence, or use a list"
    if JOINING_DASH.search(sentence):
        yield "dash", "split the sentence, or use a colon"
    if language == "zh":
        clauses = sentence.count("，") + 1
        if clauses > MAX_ZH_CLAUSES:
            yield "comma-chain", "%d clauses, limit %d" % (clauses, MAX_ZH_CLAUSES)


def lint(text, forced_language, strict):
    """Return (line_number, rule, detail, sentence) for each finding."""
    findings = []
    for line, prose in blocks(text):
        prose = clean(prose)
        language = detect_language(prose) if forced_language == "auto" else forced_language
        limit = LIMITS[language][1 if strict else 0]
        parts = sentences(prose, language)
        if len(parts) > MAX_PARAGRAPH_SENTENCES:
            detail = "%d sentences, limit %d" % (len(parts), MAX_PARAGRAPH_SENTENCES)
            findings.append((line, "paragraph-length", detail, parts[0]))
        for sentence in parts:
            for rule, detail in check_sentence(sentence, language, limit):
                findings.append((line, rule, detail, sentence))
    return findings


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("files", nargs="*", metavar="FILE")
    parser.add_argument(
        "--strict",
        action="store_true",
        help="use the sentence limits for procedures and error messages",
    )
    parser.add_argument("--lang", choices=("auto", "en", "zh"), default="auto")
    args = parser.parse_args()
    sys.stdout.reconfigure(encoding="utf-8")

    status = 0
    for path in args.files or ["-"]:
        try:
            if path == "-":
                text = sys.stdin.buffer.read().decode("utf-8")
            else:
                with open(path, encoding="utf-8") as handle:
                    text = handle.read()
        except (OSError, UnicodeDecodeError) as error:
            print("%s: %s" % (path, error), file=sys.stderr)
            status = 2
            continue
        for line, rule, detail, sentence in lint(text, args.lang, args.strict):
            excerpt = sentence if len(sentence) <= 60 else sentence[:57] + "..."
            print("%s:%d: %s: %s: %s" % (path, line, rule, detail, excerpt))
            status = status or 1
    return status


if __name__ == "__main__":
    sys.exit(main())
