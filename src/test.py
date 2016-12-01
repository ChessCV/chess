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

def preprocess_frame (frame):
	return frame [(frame.shape[0]/6):, :]

def main():
	corner_classifier = pickle.load(open('corner_data/corner_classifier.clf', 'r'))
	board = Board(corner_classifier=corner_classifier)

	#empty_filename = '../data/toy_images/empty_board.jpg'
	empty_filename = '../data/toy_images/ChessBoard.png'

	frame_empty_raw = cv2.imread(empty_filename)
	frame_empty = frame_empty_raw

	board.initialize_board_plane (frame_empty)
	# TODO: search for most optimal BIH by trying many different theta buckets for vertical hough lines. [-40,40] (default) decrement by 5 ea. trial
	# TODO: BIH with highest score among all other trials is the best
	frame_ic = board.draw_squares(frame_empty)
	board_dump = board.dump_squares_image(frame_empty_raw.shape[0], frame_empty_raw.shape[1])
	cv2.imwrite ('../data/toy_images/best_BIH.png', frame_ic)
	cv2.imwrite ('../data/toy_images/dump.bmp', board_dump)

	wait_for_image ('BIH MARKED', frame_ic)
	wait_for_image ('BOARD DIGIT DUMP', board_dump)

def wait_for_image(title, image):
	cv2.imshow (title, image)
	key = 0
	while not key in [27, ord('Q'), ord('q')]:
		key = cv2.waitKey (30)
	cv2.destroyAllWindows ()

if __name__ == "__main__":
    main()
