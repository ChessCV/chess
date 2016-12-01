import cv2
import numpy as np
import Chessnut
import BoardDetection
from Square import Square
from util import iter_algebraic_notations

class Board:
	def __init__ (self, corner_classifier=None, search_for_theta=False):
		self.corner_classifier	= corner_classifier
		self.search_for_theta = search_for_theta

	def iter_squares (self):
		for i in range(8):
			for j in range(8):
				yield self.squares [i][j]

	def construct_squares (self, empty_board_frame):
		self.squares = [[None for i in range(8)] for j in range(8)]

		for square_an in iter_algebraic_notations():
				new_square = Square (empty_board_frame, self.BIH, square_an)
				ix = new_square.board_vertices[0]
				self.squares [ix[0]][ix[1]] = new_square

	def find_BIH (self, empty_board_frame):
		self.BIH = BoardDetection.find_board_image_homography(empty_board_frame, self.corner_classifier, self.search_for_theta)

	def initialize_board_plane (self, empty_board_frame):
		self.find_BIH (empty_board_frame)
		self.construct_squares (empty_board_frame)

	def initialize_game (self):
		self.game = Chessnut.Game ()
		self.num_moves = 0

	def add_move (self):
		self.num_moves += 1
		self.game.apply_move (self.last_move)

	def draw_squares (self, image):
		for square in self.iter_squares():
			image = square.draw_surface(image)
		return image

	def dump_squares_image (self, width, height):
		image = np.zeros ((width, height), dtype=np.uint8)
		count = 1
		for square in self.iter_squares():
			image = square.dump(image, count)
			count += 1
		return image

	def draw_vertices (self, image):
		for square in self.iter_squares():
			square.draw_vertices(image)
		return image

	def draw_square_an (self, an, image, color=(255, 0, 0)):
		i, j = algebraic_notation_to_board_coords(an)[0]
		square = self.squares[i][j]
		image = square.draw_surface(image, color)
		return image
