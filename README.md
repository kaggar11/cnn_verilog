# cnn_verilog

This repository is created to develop a convolution mechanism to be deployed on an FPGA.

Currently, this code doesn't consider padding and striding. The implementation is just a basic implementation where it takes an image and a kernel as inputs. It then finds the windows from the image of the same size as kernels and then performs a convolution on it, which is just a multiplication and an addition of all the multiplied results.

The current TODO list includes:
- [x] Implement Python code to generate input stimulus
- [ ] Add support for padding and stride
- [ ] Develop a testbench to compare the outputs
- [ ] Create and test a Neural Network Model based on it

# Dataflow

This section explains the data flow of the computations in convolution.

The data is extracted from channel and kernel matrices in the Toeplitz Matrix format.

![MAC_OPS](./docs/architecture.jpg)

MAC operation is then performed on the two matrices shown in the figure below.

![MAC_OPS](./docs/convolution_dataflow.jpg)
