from scanf import scanf
import matplotlib.pyplot as plt
import numpy as np

fig, ax = plt.subplots()
funds_list = []
max_time_efficiency_list = []
with open('output.txt') as f:
	for line in f:
		funds, numerator, denominator, _ = scanf("%d: %d/%d %d", line)
		funds_list.append(funds * 1e2)
		max_time_efficiency_list.append(numerator / denominator * 1e-6)
ax.ticklabel_format(style='sci', scilimits=(-1, 1), useMathText=True)
ax.plot(funds_list, max_time_efficiency_list)
ax.plot(11100000, 8190088e-6/5, '.')
plt.show()
