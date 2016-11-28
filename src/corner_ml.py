import os
import pickle
import numpy as np
from sklearn.linear_model import LogisticRegression
from sklearn.decomposition import PCA

if __name__ == "__main__":

	data_dir = './corner_data'

	# Step 1: change to correct directory
	os.chdir (data_dir)

	# Step 2: load features
	features_pos = pickle.load (open('features.mat', 'r'))
	features_pos2 = pickle.load (open('specialized_corners.mat', 'r'))
	features_pos = np.concatenate ([features_pos, features_pos2])
	features_neg = pickle.load (open('features_neg.mat', 'r'))

	X_train = np.concatenate ([features_pos, features_neg])
	y_train = np.concatenate ([np.ones ((features_pos.shape[0],)), np.zeros((features_neg.shape[0],))])

	# Step 3: create/fit/score raw models
	lr = LogisticRegression ().fit (X_train, y_train)

	# Step 4: save the model
	with open('corner_classifier.clf', 'wb') as f:
		pickle.dump(lr, f)
