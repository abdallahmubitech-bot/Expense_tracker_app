"""Renders pixel previews of the SpendWise UI from the widget source.

Every colour, string and measurement below is taken from the Flutter widget
code in lib/ so the previews match what the app draws.
"""

import math
import os

from PIL import Image, ImageDraw, ImageFont

S = 2  # supersampling factor
W, H = 390, 844
NAV_H = 68

FONT_REG = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
FONT_BOLD = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"

# ---- palette from lib/core/theme/app_colors.dart -------------------------
PRIMARY = (0x9C, 0x27, 0xB0)
PRIMARY_LIGHT = (0xE1, 0xBE, 0xE7)
PRIMARY_DARK = (0x7B, 0x1F, 0xA2)
ACCENT = (0xE0, 0x40, 0xFB)
TEXT1 = (0x21, 0x21, 0x21)
TEXT2 = (0x75, 0x75, 0x75)
DIVIDER = (0xBD, 0xBD, 0xBD)
ON_PRIMARY = (0xFF, 0xFF, 0xFF)
SURFACE = (0xFF, 0xFB, 0xFE)
SURFACE_CONT = (0xF7, 0xF2, 0xFA)
SURFACE_DARK = (0x15, 0x12, 0x18)
SURFACE_CONT_DARK = (0x22, 0x1E, 0x27)
TEXT1_DARK = (0xED, 0xE7, 0xF6)
TEXT2_DARK = (0xB0, 0xA9, 0xBE)
DIVIDER_DARK = (0x3A, 0x34, 0x42)

CAT_COLORS = {
    "food": (0xFF, 0x70, 0x43),
    "groceries": (0x66, 0xBB, 0x6A),
    "transport": (0x42, 0xA5, 0xF5),
    "shopping": (0xAB, 0x47, 0xBC),
    "bills": (0x26, 0xA6, 0x9A),
    "health": (0xEF, 0x53, 0x50),
    "entertainment": (0x7E, 0x57, 0xC2),
    "travel": (0x29, 0xB6, 0xF6),
    "other": (0x9E, 0x9E, 0x9E),
}

_font_cache = {}


def font(size, bold=False):
    key = (size, bold)
    if key not in _font_cache:
        _font_cache[key] = ImageFont.truetype(
            FONT_BOLD if bold else FONT_REG, max(1, int(size * S))
        )
    return _font_cache[key]


def rgba(color, a=1.0):
    return (color[0], color[1], color[2], int(round(255 * a)))


class Canvas:
    """Draws in 390x844 logical units over a supersampled RGBA image.

    Every primitive is drawn on a transparent tile and alpha composited, so
    translucent fills and shadows blend like Flutter's painter does.
    """

    def __init__(self, background=(255, 255, 255)):
        self.img = Image.new("RGBA", (W * S, H * S), rgba(background))

    # -- compositing core -------------------------------------------------
    def _draw(self, x0, y0, x1, y1, fn):
        px0 = max(0, int(math.floor(x0 * S)))
        py0 = max(0, int(math.floor(y0 * S)))
        px1 = min(self.img.width, int(math.ceil(x1 * S)))
        py1 = min(self.img.height, int(math.ceil(y1 * S)))
        if px1 <= px0 or py1 <= py0:
            return
        layer = Image.new("RGBA", (px1 - px0, py1 - py0), (0, 0, 0, 0))
        fn(ImageDraw.Draw(layer), px0, py0)
        self.img.alpha_composite(layer, (px0, py0))

    # -- primitives -------------------------------------------------------
    def rect(self, x, y, w, h, fill=None, radius=0, outline=None, width=1):
        if fill is None and outline is None:
            return
        self._draw(
            x - width, y - width, x + w + width, y + h + width,
            lambda d, ox, oy: d.rounded_rectangle(
                [x * S - ox, y * S - oy, (x + w) * S - ox - 1, (y + h) * S - oy - 1],
                radius=radius * S, fill=fill, outline=outline,
                width=max(1, int(width * S)),
            ),
        )

    def circle(self, cx, cy, r, fill=None, outline=None, width=1):
        self._draw(
            cx - r - width, cy - r - width, cx + r + width, cy + r + width,
            lambda d, ox, oy: d.ellipse(
                [(cx - r) * S - ox, (cy - r) * S - oy,
                 (cx + r) * S - ox, (cy + r) * S - oy],
                fill=fill, outline=outline, width=max(1, int(width * S)),
            ),
        )

    def line(self, x1, y1, x2, y2, color, width=1):
        self._draw(
            min(x1, x2) - width, min(y1, y2) - width,
            max(x1, x2) + width, max(y1, y2) + width,
            lambda d, ox, oy: d.line(
                [x1 * S - ox, y1 * S - oy, x2 * S - ox, y2 * S - oy],
                fill=color, width=max(1, int(width * S)),
            ),
        )

    def poly(self, points, fill=None, outline=None):
        xs = [p[0] for p in points]
        ys = [p[1] for p in points]
        self._draw(
            min(xs), min(ys), max(xs), max(ys),
            lambda d, ox, oy: d.polygon(
                [(x * S - ox, y * S - oy) for x, y in points],
                fill=fill, outline=outline,
            ),
        )

    def arc(self, cx, cy, r, start, end, color, width=1):
        self._draw(
            cx - r - width, cy - r - width, cx + r + width, cy + r + width,
            lambda d, ox, oy: d.arc(
                [(cx - r) * S - ox, (cy - r) * S - oy,
                 (cx + r) * S - ox, (cy + r) * S - oy],
                start, end, fill=color, width=max(1, int(width * S)),
            ),
        )

    def text(self, x, y, s, size=14, color=TEXT1, bold=False, anchor="la"):
        f = font(size, bold)
        box = f.getbbox(s)
        w_units = (box[2] - box[0]) / S
        h_units = (box[3] - box[1]) / S
        self._draw(
            x - w_units, y - h_units, x + w_units + 2, y + h_units * 2 + 2,
            lambda d, ox, oy: d.text((x * S - ox, y * S - oy), s, font=f,
                                     fill=color, anchor=anchor),
        )

    def measure(self, s, size=14, bold=False):
        box = font(size, bold).getbbox(s)
        return (box[2] - box[0]) / S, (box[3] - box[1]) / S

    def shadow(self, x, y, w, h, radius, color=(0, 0, 0), blur=24, strength=0.16,
               dy=10):
        """Approximates a Flutter BoxShadow with stacked translucent rings."""
        steps = 12
        for i in range(steps, 0, -1):
            grow = blur * (i / steps) ** 1.5
            a = strength / steps
            self.rect(x - grow, y - grow + dy,
                      w + grow * 2, h + grow * 2,
                      fill=rgba(color, a), radius=radius + grow)

    def paste(self, other):
        self.img.alpha_composite(other)


# ---- icons drawn from primitives -----------------------------------------
def icon(c, kind, cx, cy, size, color, weight=None):
    r = size / 2
    w = max(1.3, size * 0.095) if weight is None else weight
    white = (255, 255, 255, 255)

    if kind == "plus":
        c.line(cx - r, cy, cx + r, cy, color, w)
        c.line(cx, cy - r, cx, cy + r, color, w)
    elif kind == "close":
        q = r * 0.6
        c.line(cx - q, cy - q, cx + q, cy + q, color, w)
        c.line(cx + q, cy - q, cx - q, cy + q, color, w)
    elif kind == "chevron_left":
        c.line(cx + r * 0.3, cy - r * 0.55, cx - r * 0.3, cy, color, w)
        c.line(cx - r * 0.3, cy, cx + r * 0.3, cy + r * 0.55, color, w)
    elif kind == "chevron_right":
        c.line(cx - r * 0.3, cy - r * 0.55, cx + r * 0.3, cy, color, w)
        c.line(cx + r * 0.3, cy, cx - r * 0.3, cy + r * 0.55, color, w)
    elif kind == "insights":
        bw = size * 0.19
        c.rect(cx - r * 0.72, cy + size * 0.06, bw, size * 0.36, fill=color, radius=bw / 2)
        c.rect(cx - bw / 2, cy - size * 0.44, bw, size * 0.86, fill=color, radius=bw / 2)
        c.rect(cx + r * 0.72 - bw, cy - size * 0.16, bw, size * 0.58, fill=color, radius=bw / 2)
    elif kind in ("receipt", "bills"):
        c.rect(cx - r * 0.6, cy - r * 0.8, size * 0.6, size * 0.8, fill=color, radius=1.5)
        for i in range(3):
            c.line(cx - r * 0.34, cy - r * 0.42 + i * r * 0.38,
                   cx + r * 0.34, cy - r * 0.42 + i * r * 0.38, white, w * 0.75)
    elif kind == "settings":
        c.circle(cx, cy, r * 0.34, fill=color)
        for i in range(8):
            a = math.radians(i * 45)
            x1, y1 = cx + math.cos(a) * r * 0.55, cy + math.sin(a) * r * 0.55
            x2, y2 = cx + math.cos(a) * r * 0.95, cy + math.sin(a) * r * 0.95
            c.line(x1, y1, x2, y2, color, w * 1.9)
        c.circle(cx, cy, r * 0.62, fill=None, outline=color, width=w * 1.5)
    elif kind == "restaurant":
        c.line(cx - r * 0.5, cy - r * 0.9, cx - r * 0.5, cy + r * 0.88, color, w)
        c.line(cx - r * 0.86, cy - r * 0.9, cx - r * 0.86, cy - r * 0.06, color, w * 0.85)
        c.line(cx - r * 0.14, cy - r * 0.9, cx - r * 0.14, cy - r * 0.06, color, w * 0.85)
        c.line(cx - r * 0.86, cy - r * 0.06, cx - r * 0.14, cy - r * 0.06, color, w * 0.85)
        c.line(cx + r * 0.52, cy - r * 0.9, cx + r * 0.52, cy + r * 0.88, color, w)
        c.poly([(cx + r * 0.16, cy - r * 0.9), (cx + r * 0.52, cy - r * 0.74),
                (cx + r * 0.52, cy - r * 0.2), (cx + r * 0.16, cy - r * 0.2)], fill=color)
    elif kind == "groceries":
        c.arc(cx, cy - r * 0.34, r * 0.4, 180, 360, color, w)
        c.poly([(cx - r * 0.82, cy - r * 0.24), (cx + r * 0.82, cy - r * 0.24),
                (cx + r * 0.56, cy + r * 0.86), (cx - r * 0.56, cy + r * 0.86)], fill=color)
    elif kind == "transport":
        c.rect(cx - r * 0.64, cy - r * 0.82, size * 0.64, size * 0.94, fill=color, radius=2.5)
        c.rect(cx - r * 0.42, cy - r * 0.58, size * 0.2, size * 0.2, fill=white, radius=1)
        c.rect(cx + r * 0.06, cy - r * 0.58, size * 0.2, size * 0.2, fill=white, radius=1)
        c.circle(cx - r * 0.4, cy + r * 0.3, r * 0.15, fill=white)
        c.circle(cx + r * 0.4, cy + r * 0.3, r * 0.15, fill=white)
    elif kind == "shopping":
        c.arc(cx, cy - r * 0.36, r * 0.36, 180, 360, color, w)
        c.rect(cx - r * 0.68, cy - r * 0.3, size * 0.68, size * 0.92, fill=color, radius=2.5)
    elif kind == "health":
        c.circle(cx - r * 0.34, cy - r * 0.24, r * 0.42, fill=color)
        c.circle(cx + r * 0.34, cy - r * 0.24, r * 0.42, fill=color)
        c.poly([(cx - r * 0.72, cy - r * 0.06), (cx + r * 0.72, cy - r * 0.06),
                (cx, cy + r * 0.84)], fill=color)
    elif kind == "entertainment":
        c.rect(cx - r * 0.82, cy - r * 0.58, size * 0.82, size * 0.58, fill=color, radius=2)
        for dx in (-0.45, -0.15, 0.15, 0.45):
            c.rect(cx + r * dx - 1.1, cy - r * 0.5, 2.2, size * 0.1, fill=white)
            c.rect(cx + r * dx - 1.1, cy + r * 0.4, 2.2, size * 0.1, fill=white)
    elif kind == "education":
        c.poly([(cx - r * 0.86, cy - r * 0.42), (cx, cy - r * 0.82),
                (cx, cy + r * 0.78), (cx - r * 0.86, cy + r * 0.38)], fill=color)
        c.poly([(cx + r * 0.86, cy - r * 0.42), (cx, cy - r * 0.82),
                (cx, cy + r * 0.78), (cx + r * 0.86, cy + r * 0.38)],
              fill=rgba(color, 0.6))
    elif kind == "travel":
        c.poly([(cx, cy - r * 0.92), (cx + r * 0.92, cy + r * 0.28),
                (cx + r * 0.12, cy + r * 0.1), (cx + r * 0.06, cy + r * 0.92),
                (cx - r * 0.06, cy + r * 0.92), (cx - r * 0.12, cy + r * 0.1),
                (cx - r * 0.92, cy + r * 0.28)], fill=color)
    elif kind == "other":
        for dx, dy in ((-0.42, -0.42), (0.42, -0.42), (-0.42, 0.42), (0.42, 0.42)):
            c.rect(cx + r * dx - size * 0.13, cy + r * dy - size * 0.13,
                   size * 0.26, size * 0.26, fill=color, radius=1.5)
    elif kind == "calendar":
        c.rect(cx - r * 0.8, cy - r * 0.66, size * 0.8, size * 0.78, fill=None,
               outline=color, width=w, radius=2)
        c.line(cx - r * 0.8, cy - r * 0.26, cx + r * 0.8, cy - r * 0.26, color, w)
        c.line(cx - r * 0.42, cy - r * 0.88, cx - r * 0.42, cy - r * 0.54, color, w)
        c.line(cx + r * 0.42, cy - r * 0.88, cx + r * 0.42, cy - r * 0.54, color, w)
    elif kind == "savings":
        c.circle(cx, cy, r * 0.74, fill=color)
        c.circle(cx - r * 0.1, cy - r * 0.1, r * 0.2, fill=white)
        c.line(cx + r * 0.32, cy - r * 0.62, cx + r * 0.66, cy - r * 0.62, color, w * 1.5)
    elif kind == "fire":
        c.poly([(cx, cy - r * 0.95), (cx + r * 0.52, cy - r * 0.06),
                (cx + r * 0.34, cy + r * 0.72), (cx - r * 0.34, cy + r * 0.72),
                (cx - r * 0.52, cy - r * 0.06)], fill=color)
    elif kind == "check":
        c.circle(cx, cy, r * 0.86, fill=rgba(color, 0.22))
        c.line(cx - r * 0.36, cy + r * 0.02, cx - r * 0.04, cy + r * 0.32, color, w * 1.3)
        c.line(cx - r * 0.04, cy + r * 0.32, cx + r * 0.4, cy - r * 0.32, color, w * 1.3)
    elif kind == "light":
        c.circle(cx, cy, r * 0.42, fill=color)
        for i in range(8):
            a = math.radians(i * 45)
            c.line(cx + math.cos(a) * r * 0.62, cy + math.sin(a) * r * 0.62,
                   cx + math.cos(a) * r * 0.95, cy + math.sin(a) * r * 0.95, color, w)
    elif kind == "dark":
        c.circle(cx, cy, r * 0.78, fill=color)
        c.circle(cx + r * 0.36, cy - r * 0.32, r * 0.64, fill=SURFACE_CONT)
    elif kind == "system":
        c.circle(cx, cy, r * 0.8, fill=None, outline=color, width=w)
        c.poly([(cx, cy - r * 0.8), (cx + r * 0.8, cy), (cx, cy + r * 0.8),
                (cx - r * 0.8, cy)], fill=color)
    elif kind == "sad":
        c.circle(cx, cy, r * 0.9, fill=None, outline=color, width=w)
        c.circle(cx - r * 0.32, cy - r * 0.2, r * 0.1, fill=color)
        c.circle(cx + r * 0.32, cy - r * 0.2, r * 0.1, fill=color)
        c.arc(cx, cy + r * 0.34, r * 0.42, 200, 340, color, w)


def status_bar(c, fg):
    c.text(28, 15, "9:41", 13, fg, True)
    for i in range(4):
        hgt = 3.2 + i * 2.3
        c.rect(300 + i * 5.6, 27 - hgt, 3.4, hgt, fill=fg, radius=0.8)
    for rad in (9.5, 6.4, 3.2):
        c.arc(336, 27, rad, 216, 324, fg, 1.7)
    c.rect(356, 19, 22.5, 11.5, fill=None, outline=fg, width=1.2, radius=3)
    c.rect(358.3, 21.3, 15.5, 7, fill=fg, radius=1.6)
    c.rect(379.5, 22.6, 2.2, 4.2, fill=rgba(fg, 0.6), radius=1)


def nav_bar(c, index, dark=False):
    bg = SURFACE_CONT_DARK if dark else (255, 255, 255)
    on = TEXT1_DARK if dark else TEXT1
    muted = TEXT2_DARK if dark else TEXT2
    c.rect(0, H - NAV_H, W, NAV_H, fill=bg)
    c.line(0, H - NAV_H, W, H - NAV_H, rgba(DIVIDER_DARK if dark else DIVIDER, 0.6), 1)
    items = [("insights", "Dashboard"), ("receipt", "Expenses"), ("settings", "Settings")]
    for i, (kind, label) in enumerate(items):
        cx = 65 + i * 130
        selected = i == index
        if selected:
            c.rect(cx - 32, H - NAV_H + 8, 64, 32,
                   fill=PRIMARY_DARK if dark else PRIMARY_LIGHT, radius=16)
        icon(c, kind, cx, H - NAV_H + 24, 20, PRIMARY if selected else muted)
        c.text(cx, H - NAV_H + 46, label, 11, PRIMARY if selected else muted,
               selected, "ma")


def fab(c):
    cx, cy = W - 44, H - NAV_H - 44
    c.shadow(cx - 28, cy - 28, 56, 56, 28, (0x4A, 0x0C, 0x54), 22, 0.30, dy=8)
    c.circle(cx, cy, 28, fill=PRIMARY)
    icon(c, "plus", cx, cy, 26, ON_PRIMARY, 2.4)


def avatar(c, key, cx, cy, size=44, dark=False):
    base = CAT_COLORS[key]
    c.circle(cx, cy, size / 2, fill=rgba(base, 0.24 if dark else 0.15))
    icon(c, "restaurant" if key == "food" else key, cx, cy, size * 0.5, base)


CATS = [
    ("food", "Food & Dining", 420.00, 6),
    ("groceries", "Groceries", 268.40, 4),
    ("transport", "Transport", 186.20, 3),
]

EXPENSES = [
    ("food", "Dinner at Terra Kulture", "Food & Dining · Today", 84.50),
    ("transport", "Bolt ride to the office", "Transport · Today", 12.80),
    ("groceries", "Weekly market run", "Groceries · Today", 96.30),
    ("food", "Coffee with a friend", "Food & Dining · Yesterday", 8.40),
    ("shopping", "Running shoes", "Shopping · Yesterday", 89.90),
    ("bills", "Internet subscription", "Bills & Utilities · 3 Nov", 45.00),
    ("entertainment", "Cinema tickets", "Entertainment · 2 Nov", 32.00),
    ("transport", "Fuel top up", "Transport · 2 Nov", 60.00),
]

TOTAL = 1284.50
BUDGET = 1500.00


def money(v):
    return "${:,.2f}".format(v)


def monthly_totals():
    """Deterministic daily spend for November, matching TOTAL."""
    pattern = [0, 0, 42.0, 18.4, 96.3, 0, 210.0, 32.0, 12.8, 0, 0, 64.5,
               8.4, 0, 145.0, 0, 84.5, 0, 30.0, 0, 0, 120.0, 0, 55.0,
               0, 18.0, 0, 96.0, 0, 0]
    peak = 210.0
    out = []
    for i, v in enumerate(pattern[:30]):
        out.append((i + 1, v, v / peak))
    return out


# ---- screens -------------------------------------------------------------
def dashboard(dark=False, scrolled=False):
    surf = SURFACE_DARK if dark else SURFACE
    on = TEXT1_DARK if dark else TEXT1
    muted = TEXT2_DARK if dark else TEXT2
    card = SURFACE_CONT_DARK if dark else SURFACE_CONT

    c = Canvas(surf)

    if not scrolled:
        # SliverAppBar, expanded
        c.rect(0, 0, W, 168, fill=PRIMARY)
        status_bar(c, ON_PRIMARY)
        c.text(16, 52, "SpendWise", 22, ON_PRIMARY, True)
        c.text(16, 82, "Your budget at a glance", 12, rgba(ON_PRIMARY, 0.85))
        icon(c, "chevron_left", 32, 138, 18, ON_PRIMARY, 1.9)
        c.text(195, 128, "November 2026", 16, ON_PRIMARY, True, "ma")
        c.text(198, 152, "tap to return to this month", 10, rgba(ON_PRIMARY, 0.7), False, "ma")
        icon(c, "chevron_right", 358, 138, 18, rgba(ON_PRIMARY, 0.35), 1.9)

        # BudgetOverviewCard
        y = 184
        card_h = 192
        fill = PRIMARY_DARK if dark else PRIMARY
        c.shadow(16, y, W - 32, card_h, 24, PRIMARY_DARK, 26, 0.34, dy=12)
        c.rect(16, y, W - 32, card_h, fill=fill, radius=24)
        c.text(36, y + 22, "Spent this month", 13, rgba(ON_PRIMARY, 0.88), True)

        badge_w = 98
        bx = W - 36 - badge_w
        c.rect(bx, y + 18, badge_w, 26, fill=rgba(ON_PRIMARY, 0.18), radius=13)
        icon(c, "check", bx + 16, y + 31, 16, ON_PRIMARY)
        c.text(bx + 29, y + 23, "On track", 11, ON_PRIMARY, True)

        c.text(36, y + 66, money(TOTAL), 36, ON_PRIMARY, True)
        c.text(36, y + 114, "18 expenses \u00b7 avg $71.36", 12, rgba(ON_PRIMARY, 0.85))

        bar_y = y + 142
        c.rect(36, bar_y, W - 72, 10, fill=rgba(ON_PRIMARY, 0.24), radius=5)
        c.rect(36, bar_y, (W - 72) * (TOTAL / BUDGET), 10, fill=ACCENT, radius=5)
        c.text(36, bar_y + 22, "86% of $1,500.00", 12, rgba(ON_PRIMARY, 0.85))
        c.text(W - 36, bar_y + 22, "$215.50 left", 12, ON_PRIMARY, True, "ra")

        sy = y + card_h + 26
        ry = sy + 46
    else:
        # Pinned SliverAppBar
        c.rect(0, 0, W, 100, fill=PRIMARY_DARK if dark else PRIMARY)
        status_bar(c, ON_PRIMARY)
        c.text(16, 58, "SpendWise", 20, ON_PRIMARY, True)
        sy = 126
        ry = sy + 46

    c.text(16, sy, "Spending by category", 16, on, True)
    c.text(16, sy + 23, "6 active categories", 12, muted)

    for key, name, total, count in CATS:
        avatar(c, key, 36, ry + 20, 40, dark)
        c.text(68, ry + 2, name, 14, on, True)
        aw, _ = c.measure(money(total), 14, True)
        c.text(W - 16 - aw, ry + 2, money(total), 14, on, True)
        c.rect(68, ry + 26, W - 84, 6,
               fill=rgba(DIVIDER_DARK if dark else DIVIDER, 0.45), radius=3)
        c.rect(68, ry + 26, (W - 84) * (total / TOTAL), 6, fill=CAT_COLORS[key], radius=3)
        c.text(68, ry + 38, f"{count} expenses \u00b7 {round(total / TOTAL * 100)}%", 12, muted)
        ry += 72

    if scrolled:
        dy = ry + 6
        c.text(16, dy, "Daily rhythm", 16, on, True)
        c.text(16, dy + 23, "How the month unfolded day by day", 12, muted)
        cy = dy + 44
        c.rect(16, cy, W - 32, 200, fill=card, radius=20,
               outline=rgba(DIVIDER_DARK if dark else DIVIDER, 0.35), width=1)
        bars = monthly_totals()
        bx0, bw, gap = 32, 7.0, 3.3
        max_h = 120
        for day, val, frac in bars:
            x = bx0 + (day - 1) * (bw + gap)
            h = max(3.0, max_h * frac)
            c.rect(x, cy + 20 + (max_h - h), bw, h,
                   fill=ACCENT if day == 7 else rgba(PRIMARY, 0.55), radius=3.5)
        c.text(32, cy + 150, "Day 1", 11, muted)
        c.text(W - 32, cy + 150, "Day 30", 11, muted, False, "ra")
        icon(c, "fire", 34, cy + 176, 14, ACCENT)
        c.text(46, cy + 168, "Highest day: 7 November 2026 ($210.00)", 12, muted)

        gy = cy + 216
        c.text(16, gy, "At a glance", 16, on, True)
        c.rect(16, gy + 30, W - 32, 164, fill=card, radius=20,
               outline=rgba(DIVIDER_DARK if dark else DIVIDER, 0.35), width=1)
        rows = [("calendar", "Average per expense", "$71.36"),
                ("fire", "Highest day", "7/11"),
                ("savings", "Budget", "$1,500.00")]
        for i, (kind, label, value) in enumerate(rows):
            iy = gy + 30 + 8 + i * 52 + 20
            icon(c, kind, 44, iy, 20, PRIMARY)
            c.text(70, iy - 9, label, 13, on)
            vw, _ = c.measure(value, 13, True)
            c.text(W - 32 - vw, iy - 9, value, 13, on, True)
            if i < 2:
                c.line(32, gy + 30 + 8 + (i + 1) * 52, W - 32, gy + 30 + 8 + (i + 1) * 52,
                       rgba(DIVIDER_DARK if dark else DIVIDER, 0.35), 1)

    nav_bar(c, 0, dark)
    fab(c)
    return c.img


def expenses():
    c = Canvas(SURFACE)
    c.rect(0, 0, W, 100, fill=PRIMARY)
    status_bar(c, ON_PRIMARY)
    c.text(16, 58, "Expenses", 22, ON_PRIMARY, True)

    y = 112
    c.rect(16, y, W - 32, 112, fill=PRIMARY_LIGHT, radius=20)
    c.text(34, y + 18, "All time spending", 12, TEXT1, True)
    c.text(34, y + 38, money(4208.75), 28, TEXT1, True)
    c.text(34, y + 80, "38 expenses", 12, TEXT1)

    ly = y + 118
    for i, (key, title, sub, amount) in enumerate(EXPENSES):
        cy = ly + i * 66
        avatar(c, key, 8 + 12 + 22, cy + 33, 44)
        c.text(74, cy + 18, title, 14, TEXT1, True)
        c.text(74, cy + 38, sub, 12, TEXT2)
        aw, _ = c.measure(money(amount), 14, True)
        c.text(W - 20 - aw, cy + 24, money(amount), 14, TEXT1, True)
        if i < len(EXPENSES) - 1:
            c.line(74, cy + 66, W - 16, cy + 66, rgba(DIVIDER, 0.3), 1)

    nav_bar(c, 1)
    fab(c)
    return c.img


def add_expense_sheet():
    base = dashboard()
    c = Canvas(SURFACE)
    c.paste(base)
    overlay = Canvas((0, 0, 0))
    overlay.img = Image.new("RGBA", (W * S, H * S), (0, 0, 0, 0))
    ImageDraw.Draw(overlay.img).rectangle([0, 0, W * S, H * S], fill=(0, 0, 0, 0x73))
    c.paste(overlay.img)

    top = 236
    c.rect(0, top, W, H - top + 24, fill=SURFACE, radius=28)
    c.rect(0, top + 24, W, H - top, fill=SURFACE)
    c.rect(W / 2 - 22, top + 10, 44, 4, fill=DIVIDER, radius=2)

    c.text(20, top + 28, "New expense", 24, TEXT1, True)
    icon(c, "close", W - 34, top + 40, 20, TEXT2, 1.9)

    fy = top + 74
    c.rect(20, fy, W - 40, 66, fill=SURFACE_CONT, radius=16, outline=DIVIDER, width=1)
    c.text(36, fy + 8, "Amount", 12, PRIMARY)
    c.text(36, fy + 26, "$", 22, PRIMARY, True)
    c.text(52, fy + 25, "84.50", 23, TEXT1, True)

    ty = fy + 82
    c.rect(20, ty, W - 40, 58, fill=SURFACE_CONT, radius=16, outline=DIVIDER, width=1)
    c.text(36, ty + 7, "Title", 12, PRIMARY)
    c.text(36, ty + 26, "Dinner at Terra Kulture", 15, TEXT1)

    dy = ty + 74
    c.rect(20, dy, W - 40, 58, fill=SURFACE_CONT, radius=16, outline=DIVIDER, width=1)
    c.text(36, dy + 7, "Date", 12, PRIMARY)
    icon(c, "calendar", 47, dy + 39, 17, PRIMARY, 1.6)
    c.text(62, dy + 29, "Thu, 5 Nov 2026 · 8:15 PM", 14, TEXT1)

    cy = dy + 82
    c.text(20, cy, "Category", 14, TEXT1, True)
    chip_y = cy + 24
    x = 20
    for key, label, sel in [("food", "Food & Dining", True),
                            ("groceries", "Groceries", False),
                            ("transport", "Transport", False)]:
        tw, _ = c.measure(label, 13, sel)
        wdt = tw + 58
        if sel:
            c.rect(x, chip_y, wdt, 42, fill=CAT_COLORS[key], radius=12)
            icon(c, "restaurant", x + 20, chip_y + 21, 16, ON_PRIMARY, 1.7)
            c.text(x + 36, chip_y + 14, label, 13, ON_PRIMARY, True)
        else:
            c.rect(x, chip_y, wdt, 42, fill=rgba(CAT_COLORS[key], 0.14), radius=12,
                   outline=rgba(CAT_COLORS[key], 0.4), width=1)
            icon(c, "groceries" if key == "groceries" else key,
                 x + 20, chip_y + 21, 16, CAT_COLORS[key], 1.7)
            c.text(x + 36, chip_y + 14, label, 13, TEXT1)
        x += wdt + 8

    ny = chip_y + 56
    c.rect(20, ny, W - 40, 66, fill=SURFACE_CONT, radius=16, outline=DIVIDER, width=1)
    c.text(36, ny + 7, "Note (optional)", 12, PRIMARY)
    c.text(36, ny + 28, "Birthday dinner with Ada and Tunde", 14, TEXT2)

    btn_y = ny + 88
    c.shadow(20, btn_y, W - 40, 52, 16, PRIMARY, 16, 0.3, dy=6)
    c.rect(20, btn_y, W - 40, 52, fill=PRIMARY, radius=16)
    c.text(W / 2, btn_y + 17, "Add expense", 14, ON_PRIMARY, True, "ma")
    return c.img


def settings():
    c = Canvas(SURFACE)
    c.rect(0, 0, W, 100, fill=PRIMARY)
    status_bar(c, ON_PRIMARY)
    c.text(16, 58, "Settings", 22, ON_PRIMARY, True)

    y = 120
    c.text(16, y, "Appearance", 16, TEXT1, True)
    sy = y + 26
    c.rect(16, sy, W - 32, 48, fill=SURFACE_CONT, radius=24, outline=DIVIDER, width=1)
    seg = [("system", "System", False), ("light", "Light", True), ("dark", "Dark", False)]
    seg_w = (W - 32) / 3
    for i, (kind, label, sel) in enumerate(seg):
        sx = 16 + i * seg_w
        if sel:
            c.rect(sx + 3, sy + 3, seg_w - 6, 42, fill=PRIMARY_LIGHT, radius=21)
        tw, _ = c.measure(label, 13, sel)
        tx = sx + seg_w / 2 + 6
        icon(c, kind, sx + seg_w / 2 - tw / 2 - 11, sy + 24, 15,
             TEXT1 if sel else TEXT2, 1.7)
        c.text(tx - tw / 2, sy + 16, label, 13, TEXT1 if sel else TEXT2, sel)

    y = sy + 48 + 30
    c.text(16, y, "Budget", 16, TEXT1, True)
    cy = y + 26
    c.rect(16, cy, W - 32, 76, fill=SURFACE_CONT, radius=20,
           outline=rgba(DIVIDER, 0.45), width=1)
    c.circle(52, cy + 38, 20, fill=rgba(PRIMARY, 0.15))
    icon(c, "savings", 52, cy + 38, 22, PRIMARY)
    c.text(88, cy + 19, "Monthly budget", 15, TEXT1)
    c.text(88, cy + 42, "$1,500.00", 13, TEXT2)
    icon(c, "chevron_right", W - 36, cy + 38, 16, TEXT2, 1.7)

    y = cy + 76 + 30
    c.text(16, y + 6, "Categories", 16, TEXT1, True)
    c.text(W - 16, y + 4, "+ Add", 13, PRIMARY, True, "ra")

    ly = y + 34
    shown = [("food", "Food & Dining", False), ("groceries", "Groceries", False),
             ("transport", "Transport", False), ("other", "Pets", True)]
    c.rect(16, ly, W - 32, len(shown) * 66 + 8, fill=SURFACE_CONT, radius=20,
           outline=rgba(DIVIDER, 0.45), width=1)
    for i, (key, name, custom) in enumerate(shown):
        iy = ly + 4 + i * 66 + 33
        avatar(c, key, 16 + 16 + 19, iy, 38)
        c.text(16 + 16 + 50, iy - 15, name, 15, TEXT1)
        c.text(16 + 16 + 50, iy + 4, "Custom category" if custom else "Default category",
               12, TEXT2)
        if custom:
            icon(c, "close", W - 42, iy, 16, TEXT2, 1.7)

    c.text(W / 2, H - NAV_H - 34, "SpendWise 1.0.0", 12, TEXT2, False, "ma")
    nav_bar(c, 2)
    return c.img


# ---- device frame --------------------------------------------------------
def frame(screen_img, bezel=13):
    sw, sh = screen_img.size
    pad = int(bezel * S)
    fw, fh = sw + pad * 2, sh + pad * 2
    out = Image.new("RGBA", (fw, fh), (0, 0, 0, 0))
    d = ImageDraw.Draw(out, "RGBA")
    for i in range(16, 0, -1):
        d.rounded_rectangle([i, i + 4, fw - i, fh - i + 4],
                            radius=int(46 * S) + i,
                            fill=(58, 22, 68, int(2.0 * (16 - i)) + 3))
    d.rounded_rectangle([0, 0, fw - 1, fh - 1], radius=46 * S, fill=(26, 22, 30, 255))
    d.rounded_rectangle([2, 2, fw - 3, fh - 3], radius=44 * S,
                        outline=(62, 54, 70, 255), width=int(2 * S))

    mask = Image.new("L", (sw, sh), 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, sw - 1, sh - 1], radius=36 * S, fill=255)
    screen = screen_img.copy()
    screen.putalpha(mask)
    out.paste(screen, (pad, pad), screen)

    nw, nh = int(118 * S), int(25 * S)
    nx = pad + (sw - nw) // 2
    d.rounded_rectangle([nx, pad + int(9 * S), nx + nw, pad + int(9 * S) + nh],
                        radius=int(nh / 2), fill=(26, 22, 30, 255))
    return out


def main():
    out_dir = "/home/user/previews"
    os.makedirs(out_dir, exist_ok=True)

    screens = [
        ("01-dashboard-light.png", "Dashboard \u00b7 light mode", dashboard()),
        ("02-dashboard-scrolled.png", "Dashboard \u00b7 daily rhythm", dashboard(scrolled=True)),
        ("03-expenses-light.png", "Expenses \u00b7 light mode", expenses()),
        ("04-add-expense.png", "Add expense \u00b7 bottom sheet", add_expense_sheet()),
        ("05-dashboard-dark.png", "Dashboard \u00b7 dark mode", dashboard(dark=True)),
        ("06-settings.png", "Settings \u00b7 budget & categories", settings()),
    ]

    framed = []
    for name, caption, img in screens:
        f = frame(img)
        f.save(os.path.join(out_dir, name))
        framed.append((caption, f))
        print(os.path.join(out_dir, name))

    cols, margin, gap, cap_h, row_gap = 3, 48, 40, 56, 34
    fw, fh = framed[0][1].size
    rows = (len(framed) + cols - 1) // cols
    total_w = margin * 2 + cols * fw + (cols - 1) * gap
    total_h = margin * 2 + rows * fh + (rows - 1) * row_gap + rows * cap_h
    sheet = Image.new("RGBA", (total_w, total_h), (0, 0, 0, 0))
    bg = Image.new("RGBA", (total_w, total_h), (247, 242, 250, 255))
    bd = ImageDraw.Draw(bg, "RGBA")
    for i in range(14):
        bd.ellipse([-700 + i * 18, -460 + i * 18, 980 - i * 18, 640 - i * 18],
                   fill=(0x9C, 0x27, 0xB0, 4))
    mask = Image.new("L", (total_w, total_h), 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, total_w - 1, total_h - 1],
                                           radius=44, fill=255)
    sheet.paste(bg, (0, 0), mask)
    d = ImageDraw.Draw(sheet, "RGBA")

    for idx, (caption, f) in enumerate(framed):
        col, row = idx % cols, idx // cols
        x = margin + col * (fw + gap)
        y = margin + row * (fh + cap_h + row_gap)
        sheet.paste(f, (x, y), f)
        d.text((x + fw // 2, y + fh + 22), caption,
               font=ImageFont.truetype(FONT_BOLD, 27),
               fill=(0x33, 0x2B, 0x3B, 255), anchor="ma")

    path = os.path.join(out_dir, "app-overview.png")
    sheet.convert("RGB").save(path)
    print(path)


if __name__ == "__main__":
    main()
