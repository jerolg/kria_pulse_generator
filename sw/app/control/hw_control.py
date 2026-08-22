import mmap
import os
import struct
import time


print("=" * 57)
print("         Random Nuclear Pulse Generator v1.0")
print("Scientific Instrumentation and Microelectronics Group GICM")
print("=" * 57)


# Available specs
SPECS = {
    1: "eu152_sim.bin",
    2: "co60_sim.bin",
    3: "cs137_sim.bin"
}

# Available pulse shapes
PULSES = {
    1: "biexp.bin"
}

# ----------------------------
# Select spectrum
# ----------------------------
print("Available spectra:")
for k, v in SPECS.items():
    print(f"  {k}: {v}")

spec_idx = int(input("Select spectrum: "))
spec = SPECS[spec_idx]

# ----------------------------
# Select pulse shape
# ----------------------------
print("\nAvailable pulse shapes:")
for k, v in PULSES.items():
    print(f"  {k}: {v}")

pulse_idx = int(input("Select pulse shape: "))
pulse = PULSES[pulse_idx]

# ----------------------------
# Other parameters
# ----------------------------
TARGET_EV = int(input("\nTarget number of events: "))
PROB = float(input("Probability threshold: "))



# Addresses from Device Tree Overlay
BRAM_0_ADDR = 0x80000000
BRAM_0_SIZE = 0x2000      # 8 KB
BRAM_1_ADDR = 0x82000000
BRAM_1_SIZE = 0x8000      # 32 KB

GPIO_0_ADDR = 0x80030000
GPIO_1_ADDR = 0x80070000
GPIO_2_ADDR = 0x80080000
GPIO_3_ADDR = 0x80090000
GPIO_SIZE   = 0x1000      # 4KB per GPIO is sufficient (Linux page size)

class MemoryMappedIP:
    def __init__(self, phys_addr, size):
        self.size = size # Store size for safety checks
        # Open system memory and disable caching (O_SYNC)
        self.fd = os.open("/dev/mem", os.O_RDWR | os.O_SYNC)
        # Map the physical address to a Python mmap object
        self.mem = mmap.mmap(self.fd, size, mmap.MAP_SHARED, mmap.PROT_READ | mmap.PROT_WRITE, offset=phys_addr)
        
    def write_reg(self, offset, value):
        # Write a 32-bit register (Little Endian, Unsigned Int)
        self.mem.seek(offset)
        self.mem.write(struct.pack('<I', value))
        
    def read_reg(self, offset):
        # Read a 32-bit register
        self.mem.seek(offset)
        return struct.unpack('<I', self.mem.read(4))[0]

    def write_array(self, offset, data_bytes):
        # Write an entire block of bytes (Ideal for BRAM)
        
        # SAFETY CHECK: Ensure data fits in mapped memory
        if offset + len(data_bytes) > self.size:
            raise ValueError(f"Data size ({len(data_bytes)} bytes) exceeds allocated BRAM size ({self.size} bytes) at offset {offset}")
            
        self.mem.seek(offset)
        self.mem.write(data_bytes)


    def read_array(self, offset, length):
        # Read an entire block of bytes from memory
        
        # SAFETY CHECK: Ensure we don't read out of bounds
        if offset + length > self.size:
            raise ValueError(f"Read size ({length} bytes) exceeds allocated BRAM size ({self.size} bytes) at offset {offset}")
            
        self.mem.seek(offset)
        return self.mem.read(length)

    def close(self):
        self.mem.close()
        os.close(self.fd)

if __name__ == "__main__":
    print("Initializing hardware...")
    
    # 1. Map IP blocks
    bram_0 = MemoryMappedIP(BRAM_0_ADDR, BRAM_0_SIZE)   # SIGNAL BRAM
    bram_1 = MemoryMappedIP(BRAM_1_ADDR, BRAM_1_SIZE)   # CDF BRAM
    gpio_0 = MemoryMappedIP(GPIO_0_ADDR, GPIO_SIZE)     # ENABLE_EVENTS (wr) & SELECTOR (wr)
    gpio_1 = MemoryMappedIP(GPIO_1_ADDR, GPIO_SIZE)     # PROBABILITY THRESHOLD (wr) & TARGET_EVENTS (wr)
    gpio_2 = MemoryMappedIP(GPIO_2_ADDR, GPIO_SIZE)     # DC OFFSET (wr) & DONE (rd)
    gpio_3 = MemoryMappedIP(GPIO_3_ADDR, GPIO_SIZE)     # CH_FREQS_LENGTH (wr) & PULSE_TRIG (wr)

    # 2. Load CDF into BRAM 1 (Read binary file and dump directly to memory)
    print("Loading Spec CDF...")

    with open(spec, "rb") as f:
        cdf_data = f.read()
        gpio_3.write_reg(0x0, len(cdf_data)//4)  # Configure the CH_FREQS table length
        bram_1.write_array(0x0, cdf_data)

        # Writing Verification
        print(" -> Verifying CDF BRAM...")
        read_cdf = bram_1.read_array(0x0, len(cdf_data))
        if read_cdf == cdf_data:
            print(" -> [PASS] CDF data successfully verified in hardware!")
        else:
            print(" -> [FAIL] ERROR: CDF data mismatch in hardware!")
            exit(1) # Stop execution if data is corrupt


    # 3. Load pulse signal into BRAM 0
    print("Loading pulse signal...")
    with open(pulse, "rb") as f:
        signal_data = f.read()
        bram_0.write_array(0x0, signal_data)

        # Writing Verification
        print(" -> Verifying Signal BRAM...")
        read_signal = bram_0.read_array(0x0, len(signal_data))
        if read_signal == signal_data:
            print(" -> [PASS] Pulse data successfully verified in hardware!")
        else:
            print(" -> [FAIL] ERROR: Pulse data mismatch in hardware!")
            exit(1) # Stop execution if data is corrupt



    # Toggle the BRAM update flag to notify the programmable logic (PL)
    # that a new predefined signal waveform is available
    gpio_3.write_reg(0x8, 1)
    gpio_3.write_reg(0x8, 0)

    # 4. Configure control registers
    print("Configuring control registers...")

    print(f"Setting total events: {TARGET_EV}")
    print(f"Setting probability threshold for comparison: {PROB}")

    prob_calc = int(PROB * (2**32))

    # Select the DAC_MUX signal to DAC (pulse stored in BRAM)
    gpio_0.write_reg(0x8, 4)

    # Configure the total number of synthetic pulse events
    gpio_1.write_reg(0x8, TARGET_EV)

    # Set the event generation probability threshold. Higher values increase the event rate and the likelihood
    # of pulse overlap (pileup) during signal generation.
    gpio_1.write_reg(0x0, prob_calc)

    # 5. Enable event generation
    print("Starting event generation...")
    gpio_0.write_reg(0x0, 1)

    # 6. Polling: Check if events have finished (read 1 from gpio_2, offset 0x8)
    print("Waiting for completion...")
    try:
        while True:
            status = gpio_2.read_reg(0x8)
            if status == 1:
                print("Events generated successfully!")
                break
            time.sleep(0.01) # Small delay to avoid saturating the Linux CPU
    except KeyboardInterrupt:
        print("Interrupted by user.")

    # 7. Disable the module
    gpio_0.write_reg(0x0, 0)
    print("Process finished.")

    # Close resources
    bram_0.close()
    bram_1.close()
    gpio_0.close()
    gpio_1.close()
    gpio_2.close()
    gpio_3.close() 