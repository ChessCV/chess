from copy import deepcopy
import os
import cv2
import numpy as np
import sklearn
import pickle
import CVAnalysis
from Board import Board
from util import *

def preprocess_frame (frame):
	return frame [(frame.shape[0]/6):, :]

corner_classifier = pickle.load (open('corner_data/corner_classifier.clf', 'r'))
#corner_classifier = pickle.load (open(corner_classifier_filename, 'r'))	#more data
board = Board(corner_classifier=corner_classifier)

empty_filename = '../data/toy_images/chessboard.png'
frame_empty = preprocess_frame(cv2.imread(empty_filename))
board.initialize_board_plane (frame_empty)
####[ DEBUG: verify BIH is correct	]#####
frame_ic = board.draw_squares(frame_empty)
#cv2.imwrite ('../data/toy_images/test.jpg', frame_ic)
cv2.imshow ('BIH MARKED', frame_ic)
key = 0
while not key in [27, ord('Q'), ord('q')]:
	key = cv2.waitKey (30)
cv2.destroyAllWindows ()
