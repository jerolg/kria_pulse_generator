import numpy as np
import os

CHANNELS = 1024
route = "../specs/cs137_sim.txt"
spec = np.loadtxt(route)
name = os.path.splitext(os.path.basename(route))[0]

spec = spec[0:CHANNELS]

# Define lookup table size as a power of two for efficient FPGA addressing
ADDR_WIDTH = 12
TARGET_LENGTH = 2**ADDR_WIDTH

# Normalize the spectrum to obtain channel probabilities
freqs = spec / np.sum(spec)

# Scale probabilities to the desired lookup table length
freqs_int = np.round(freqs * TARGET_LENGTH).astype(np.uint32)

# Correct rounding error to guarantee exact table size
diff = TARGET_LENGTH - np.sum(freqs_int)
if diff != 0:
    # Compensate by adjusting the most probable channel
    idx = np.argmax(freqs_int)
    freqs_int[idx] += diff

# Generate frequency-expanded channel lookup table
# Each channel index is repeated according to its relative probability
CH_FREQS = np.repeat(np.arange(CHANNELS), freqs_int)
 
# Verify generated table properties
print("TARGET_LENGTH :", TARGET_LENGTH)
print("REAL_LENGTH   :", len(CH_FREQS))
print("Power of 2    :", (len(CH_FREQS) & (len(CH_FREQS) - 1)) == 0)

#Normalize to 2**14 DAC_RESOLUTION (MAX CHANNEL IS 16383)
CH_FREQS = (CH_FREQS * (2**14 - 1) / CH_FREQS.max()).astype(np.uint32)

CH_FREQS.tofile(f"../specs/{name}.bin")

print(f"Number of Elements: {len(CH_FREQS)}")
print(f"Archive Size: {CH_FREQS.nbytes} bytes")