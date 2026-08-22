import numpy as np
import os

samples = 512               #Total Samples of pulse

# Define the synthetic detector pulse shape using a bi-exponential

def biexp(t, A, tau_f, tau_s):
    y = A * (np.exp(-t / tau_f) - np.exp(-t / tau_s))
    return -y

# Generate time axis for pulse definition
t = np.linspace(0, 30e-6, samples)

# Pulse model parameters
A = 1.0
tau_f = 0.4e-6   # Fast rise constant
tau_s = 7e-6     # Slow decay constant

# Compute pulse waveform
y = biexp(t, A, tau_f, tau_s)

# Normalize and scale to 14-bit DAC range for maximum range
scale = 2**14-1
y = y / y.max()
y = np.uint32(y * scale)

y.tofile(f"../pulses/biexp.bin")

print(f"Number of Elements: {len(y)}")
print(f"Archive Size: {y.nbytes} bytes")