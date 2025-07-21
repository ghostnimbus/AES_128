##What is Advanced Encryption Standrad?
AES (Advanced Encryption Standard) is a symmetric key encryption algorithm used globally to secure digital data. It operates on 128-bit blocks of data and supports key sizes of 128, 192, or 256 bits.

AES is widely adopted due to its:

🔐 Strong security

⚡ High performance

💻 Suitability for both software and hardware implementations

In this project, we use AES-128, which includes:

A 128-bit encryption key

10 rounds of transformation steps (SubBytes, ShiftRows, MixColumns, AddRoundKey)

Fast, efficient protection for sensitive data

##About this project
AES is the core of many secure systems, including VPNs, HTTPS, encrypted storage, and IoT devices.
This project presents an optimized AES-128 hardware design tailored for resource-constrained embedded platforms. It features a combinational S-Box (no memory overhead), clock gating for reduced power, and a pipelined, resource-sharing architecture to minimize area. UART integration enables real-time I/O via a PuTTY terminal. Designed for low-power IoT devices, embedded controllers, and edge systems, the implementation balances security, performance, and efficiency.

<img width="1280" height="510" alt="image" src="https://github.com/user-attachments/assets/a7b658b1-e0e6-4a97-b88e-5d5b3df29ddb" />

