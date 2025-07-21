## What is Advanced Encryption Standrad?
AES (Advanced Encryption Standard) is a **symmetric key encryption algorithm** used globally to secure digital data. It operates on 128-bit blocks of data and supports key sizes of 128, 192, or 256 bits.
**No of Rounds for different size of bits:** <br>
Rounds: <br>
**1.** 10 for AES-128. <br>
**2.** 12 for AES-192. <br>
**3.** 14 for AES-256. <br>


AES is widely adopted due to its: <br>
🔐 Strong security <br>
⚡ High performance <br>
💻 Suitability for both software and hardware implementations <br>


## About this project
AES is the core of many secure systems, including VPNs, HTTPS, encrypted storage, and IoT devices.
This project presents an optimized AES-128 hardware design tailored for resource-constrained embedded platforms. It features a combinational S-Box (no memory overhead), clock gating for reduced power, and a pipelined, resource-sharing architecture to minimize area. UART integration enables real-time I/O via a PuTTY terminal. Designed for low-power IoT devices, embedded controllers, and edge systems, the implementation balances security, performance, and efficiency.

<img width="1280" height="510" alt="image" src="https://github.com/user-attachments/assets/a7b658b1-e0e6-4a97-b88e-5d5b3df29ddb" />
* Figure: Block diagram of one round of AES encryption. *
