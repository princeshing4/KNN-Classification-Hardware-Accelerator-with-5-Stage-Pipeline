KNN Classification Hardware Accelerator with 5-Stage Pipeline
KNN Hardware Accelerator - Complete Project Description
🎯 Project Overview
What it does: This hardware accelerator classifies Iris flowers into 3 species (Setosa, Versicolor, Virginica) using the K-Nearest Neighbors algorithm with K=5.

Input: Four measurements of a flower (petal width, petal length, sepal width, sepal length)

Output: The predicted flower class (0, 1, or 2)

📊 Project Specifications
Performance Metrics
Maximum Delay (Critical Path): 5.44 ns

Maximum Clock Frequency: 183.82 MHz (1÷5.44 ns)

Operating Frequency: 180 MHz (conservative with margin)

Clock Period: 5.56 ns @ 180 MHz

Pipeline Stages: 5 stages for maximum efficiency

Training Dataset: 150 Iris flower samples stored in ROM

Latency Analysis
Pipeline Fill Latency: 5 clock cycles=27.8 ns (initial startup)

ROM Processing Time: 150 clock cycles=833.3 ns (reading all training data)

Sorter Processing: Overlapped with ROM reads (0 additional cycles)

Voting Logic: 2 clock cycles=11.1 ns

Total Single Classification Latency: 157 clock cycles=872.2 ns

Breakdown: 27.8 ns (pipeline) + 833.3 ns (compute) + 11.1 ns (voting)

Throughput Analysis
Peak Throughput: 180 million classifications/second (180 MCPS)

Effective Rate: 1 classification per clock cycle (after pipeline fill)

Steady-State Performance: 5.56 ns per classification (continuous mode)

Batch Performance: First result in 872 ns, then 1 result every 5.56 ns

Latency vs Throughput
Single Sample: 872 ns latency (waiting time)

Continuous Stream: 180 MCPS throughput (processing rate)

Trade-off: Pipeline adds 27.8 ns initial delay but enables a 4x throughput boost

🏗️ Architecture Breakdown
Block 1: ROM Memory (Training Data Storage)
Stores 150 pre-loaded Iris flower samples.

Each entry contains 4 features (16-bit each) + 2-bit class label.

Automatically cycles through all 150 samples every classification.

ROM Address Counter increments on each clock cycle.

Block 2: Feature Extraction
Extracts the 4 features from ROM data.

Extracts the 4 features from test input.

Separates class label for later use.

All extraction happens in parallel (combinational logic).

Block 3: Euclidean Distance Pipeline (5 Stages)
Stage 1 - Difference Calculation:

Computes difference between test features and ROM features.

Four parallel subtractions (one per feature).

Uses signed arithmetic for proper distance calculation.

Stage 2 - Squaring:

Squares all four differences.

Eliminates negative values.

Four parallel multipliers.

Stage 3 - Summation:

Adds all four squared differences.

Produces final Euclidean distance (squared).

No square root needed (ordering preserved).

Stage 4 - Output Buffering:

Stores computed distance.

Stores corresponding class label.

Generates valid signal for next block.

Stage 5 - (Implicit) Handoff to Sorter

Block 4: Top-5 Sorter (Insertion Sort)
Maintains 5 smallest distances found so far.

Uses bubble-sort style comparison and insertion.

Updates continuously as new distances arrive.

Keeps both distance values AND class labels.

After 150 comparisons, holds the 5 nearest neighbors.

Block 5: Majority Voting Logic
Counts how many times each class appears in top-5.

Determines which class has the most votes.

Outputs the winning class as the final prediction.

Handles ties by selecting the first occurring maximum.

⚡ Pipeline Advantage Explained
Without Pipeline (Sequential):
Calculate difference → Wait

Square values → Wait

Sum results → Wait

Process next sample

Time per distance calculation: 4 clock cycles×5.56 ns=22.24 ns

Total time for 150 samples: 150×22.24 ns=3,336 ns=3.34 µs

Throughput: 45 million classifications/second

With 5-Stage Pipeline (This Design):
All 5 stages work simultaneously on different data.

Once filled, produces 1 result per clock cycle.

Pipeline fill time: 5 cycles×5.56 ns=27.8 ns (one-time cost)

Processing 150 samples: 150 cycles×5.56 ns=833.3 ns

Voting: 2 cycles×5.56 ns=11.1 ns

Total latency: 157 cycles×5.56 ns=872.2 ns

Throughput: 180 million classifications/second

Throughput improvement: 4x faster than sequential!

Real-World Performance Example
Classifying 1000 flowers:

Sequential Design: 1000×3.34 µs=3,340 µs=3.34 ms

Pipelined Design: 872.2 ns+(999×5.56 ns)=6,427 ns=6.43 µs

Speedup: 519x faster for batch processing!

🎓 Key Learning Points
Parallel Processing: Maximizes hardware utilization by processing four features simultaneously at each stage.

Pipelining Benefits: Increases throughput without increasing clock frequency, trading a small latency overhead (27.8 ns) for a significant speedup (4x).

Latency vs. Throughput Understanding: Differentiating between the time for one sample (872.2 ns) and the rate of continuous processing (180 MCPS) is critical.

Hardware-Software Tradeoff: Using an on-chip ROM enables fast, deterministic timing, creating a self-contained accelerator.

Algorithm Implementation: Demonstrates how ML algorithms like KNN can be mapped directly to hardware blocks like streaming sorters and parallel counters.

Real-Time Classification: Achieves predictable latency and throughput, suitable for real-time embedded applications.

🔍 Design Optimizations
Area Optimization: Utilized ROM, squared distance (no sqrt), and a limited top-5 sorter to save resources.

Power Optimization: Employed clock gating and stopped unnecessary computations to reduce power consumption.

Timing Optimization: Pipelining broke long combinational paths, achieving the 180 MHz target with a 5.44 ns critical path.

Latency Optimization: Used parallel feature computation and overlapped sorting with ROM reads.

Throughput Maximization: A 5-stage pipeline and continuous data flow eliminate idle cycles for back-to-back classifications.

✅ Verification Coverage
Functional Tests: Verified correct classification for all classes, boundary cases, and edge cases like reset and back-to-back operations.

Timing Tests: Confirmed 180 MHz operation with all setup/hold times met and no pipeline hazards.

🚀 Real-World Applications
Where This Design Could Be Used:

IoT Sensors: Classify sensor readings in real-time (872 ns response time).

Medical Devices: Rapid diagnostic classification (sub-microsecond latency).

Industrial Automation: Quality control inspection (180 MCPS throughput).

Robotics: Object recognition and classification (continuous streaming).

Smart Agriculture: Crop disease detection (batch processing efficiency).

