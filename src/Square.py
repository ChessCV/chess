import numpy as np
import cv2
from util import board_to_image_coords, image_to_board_coords, algebraic_notation_to_board_coords


class Square:
	def __init__ (self, image, BIH, algebraic_notation):
		# Step 1: algebraic notation/colors
		self.an = algebraic_notation
		self.get_colors (self.an)
		self.get_vertices (BIH)

	def get_colors (self, algebraic_notation):
		i, j = algebraic_notation_to_board_coords (algebraic_notation)[0]
		if (i + j) % 2 == 1:
			self.color = 1
			self.draw_color = (255, 50, 50)
		else:
			self.color = 0
			self.draw_color = (0, 0, 200)

	def get_vertices (self, BIH):
		self.board_vertices	= algebraic_notation_to_board_coords (self.an)
		self.image_vertices	= [board_to_image_coords (BIH, bv) for bv in self.board_vertices]

	def draw_surface (self, image, color=None):
		if color == None:
			color = self.draw_color
		iv = np.array(self.image_vertices).astype(int)
		for i in range(len(self.image_vertices)):
			cv2.line (image, tuple(iv[i % len(self.image_vertices)]), tuple(iv[(i+1) % len(self.image_vertices)]), color, thickness=2)
		return image

	def dump(self, image, digit):
		cv2.fillConvexPoly(image, np.array(self.image_vertices).astype(int), digit)
		return image

	def draw_vertices (self, image):
		for vertex in self.image_vertices:
			cv2.circle (image, (int(vertex[0]), int(vertex[1])), 4, (255, 0, 0), thickness=2)
