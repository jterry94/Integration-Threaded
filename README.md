# Integration-Threaded
This program uses Monte Carlo Integration to calculate multidimensional integrals. Monte Carlo Integration is slow as the calculation improves with the sqrt(N) where N is the number of guesses. One can get valuable speed up In the calculation by threading the calculation and utilizing multiple processors or cores. This program utilizes Swift 5 and DispatchQueue (specifically concurrentPerform) to thread the calculation of the integral. 

Four YouTube Videos describe this program and they can be found at the following:

Part 1: https://youtu.be/KA15gO5vrs0

Part 2: https://youtu.be/bWHt8os0HtM

Part 3: https://youtu.be/mKQFuBwchOQ

Part 4: https://youtu.be/ReHGDe4Nlks

These projects are examples for my PHYS 440 Class: Computational Physics
