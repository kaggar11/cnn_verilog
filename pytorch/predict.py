# set the numpy seed for better reproducibility
import numpy as np
np.random.seed(42)

# import the necessary packages
from torch.utils.data import DataLoader
from torch.utils.data import Subset
from torchvision.transforms import ToTensor
from torchvision.datasets import KMNIST
import argparse
import imutils
import torch
import cv2

# construct the argument parser and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-m", "--model", type=str, required=True,
	help="path to the trained PyTorch model")
args = vars(ap.parse_args())

# set the device we will be using to test the model
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print("[INFO] Model running on",device,"...")

# load the KMNIST dataset and randomly grab 10 data points
print("[INFO] loading the KMNIST test dataset...")
testData = KMNIST(root="data", train=False, download=True,
	transform=ToTensor())
idxs = np.random.choice(range(0, len(testData)), size=(10,))
testData = Subset(testData, idxs)

# initialize the test data loader
testDataLoader = DataLoader(testData, batch_size=1)

# load the model and set it to evaluation mode
model = torch.load(args["model"]).to(device)

print("model:\n",model)

def save_image_to_txt(data):
	f = open("./outputs/sample_kernel.txt", "w")
	nline_str = '\n'
	tab_str = '\t'
	data=data.squeeze(0)
	data_cpu = data.cpu().detach().numpy()
	im = data_cpu[0,0,:,:]
	for x in range(im.shape[0]):
		for y in range(im.shape[1]):
			im_ele = int(im[x,y]*256)
			im_str = str(hex(((abs(im_ele) ^ 0xff) + 1) & 0xff))
			print("value string:",im_str)
			f.write(im_str+tab_str)
		f.write(nline_str)
	f.close()

kernels = model.conv1.weight.detach().clone()

#check size for sanity check
print("kernels size:",kernels.size())
save_image_to_txt(kernels)

model.eval()

# switch off autograd
with torch.no_grad():
	# loop over the test set
	for (image, label) in testDataLoader:
		# grab the original image and ground truth label
		origImage = image.numpy().squeeze(axis=(0, 1))
		gtLabel = testData.dataset.classes[label.numpy()[0]]
	
    	# send the input to the device and make predictions on it
		image = image.to(device)
		pred = model(image)
	
    	# find the class label index with the largest corresponding
		# probability
		idx = pred.argmax(axis=1).cpu().numpy()[0]
		predLabel = testData.dataset.classes[idx]
		
		# convert the image from grayscale to RGB (so we can draw on
		# it) and resize it (so we can more easily see it on our
		# screen)
		origImage = np.dstack([origImage] * 3)
		origImage = imutils.resize(origImage, width=128)
		
        # draw the predicted class label on it
		color = (0, 255, 0) if gtLabel == predLabel else (0, 0, 255)
		cv2.putText(origImage, gtLabel, (2, 25),
			cv2.FONT_HERSHEY_SIMPLEX, 0.95, color, 2)
		
        # display the result in terminal and show the input image
		print("[INFO] ground truth label: {}, predicted label: {}".format(
			gtLabel, predLabel))
		cv2.imshow("image", origImage)
		cv2.waitKey(0)
		