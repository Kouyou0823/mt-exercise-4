import matplotlib.pyplot as plt

beam = list(range(1, 11))
bleu = [
    2.126, 1.678, 1.712, 1.704, 1.679,
    1.703, 1.717, 1.744, 1.854, 1.979
]

plt.figure(figsize=(8, 5))
plt.plot(beam, bleu, marker='o', linestyle='-', color='teal')
plt.title('Beam Size vs BLEU Score')
plt.xlabel('Beam Size')
plt.ylabel('BLEU Score')
plt.grid(True)
plt.xticks(beam)
plt.tight_layout()
plt.savefig('beam_vs_bleu.png')
plt.show()