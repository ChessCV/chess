import sys
from copy import deepcopy
import os
import cv2
import numpy as np
import sklearn
import pickle
import CVAnalysis
from Board import Board
from util import *

# Mac: "/Applications/MATLAB_R2016a.app/bin/matlab"
MATLAB_PATH = ""

def preprocess_frame (frame):
	return frame [(frame.shape[0]/6):, :]

def main():
	global MATLAB_PATH

	try :
		script, env = sys.argv

		if env == "mac":
			MATLAB_PATH = "/Applications/MATLAB_R2016a.app/bin/matlab"
		elif env == "win64":
			MATLAB_PATH = "C:/Program Files/MATLAB/R2016a/bin/win64/matlab.exe"
		else:
			print("ERROR:\t Invalid <env> == \"{}\" as argument produces unknown Matlab locaion.".format(env))
			sys.exit(1)

		corner_classifier = pickle.load(open('corner_data/corner_classifier.clf', 'r'))
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

	except ValueError as err:
		print("ERROR:\t Run ChessCV as the follows:\t python2 test.py <env>")

if __name__ == "__main__":
    main()
