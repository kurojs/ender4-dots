import random, sys

sys.stdout.reconfigure(encoding="utf-8")
chars = list(
    "ァアィイゥウェエォオカガキギクグケゲコゴ"
    "サザシジスズセゼソゾタダチヂッツヅテデトド"
    "ナニヌネノハバパヒビピフブプヘベペホボポ"
    "マミムメモャヤュユョヨラリルレロワヲン"
    "∞★☆▲▼◆◇⌘†×αβγδλσω"
)
print("".join(random.choices(chars, k=10)))
