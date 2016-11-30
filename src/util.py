import cv2
import numpy as np
from numpy import matrix, array, dot, transpose
from numpy.linalg import inv

def board_to_image_coords (BIH, board_coords):
	return dehomogenize(BIH * homogenize(board_coords))

def image_to_board_coords (BIH, image_coords):
	return dehomogenize(inv(BIH) * homogenize(image_coords))

an_letters, an_numbers = 'HGFEDCBA', range(8, 0, -1)
def algebraic_notation_to_board_coords (an):
	tl = an_letters.index (an[0]), an_numbers.index (an[1])
	return [tl, (tl[0] + 1, tl[1]), (tl[0] + 1, tl[1] + 1), (tl[0], tl[1] + 1)]

def an_to_index (an):
	return an_letters.index(an[0]), an_numbers.index(an[1])

def index_to_an (index):
	return an_letters[index[0]], an_numbers[index[1]]

def homogenize (x):
	return transpose (matrix ((x[0], x[1], 1)))

def dehomogenize (x):
	x = list(array(x).reshape(-1,))
	return (x[0]/x[2], x[1]/x[2])

def euclidean_distance (p1, p2):
	return np.sqrt((p1[0] - p2[0])**2 + (p1[1] - p2[1])**2)

def get_centroid (points):
	return (np.mean([p[0] for p in points]), np.mean([p[1] for p in points]))

def rho_theta_to_abc (line):
	rho, theta = line[0], line[1]
	return (np.cos(theta), np.sin(theta), -rho)

def get_line_point_distance (line, point):
	a, b, c = rho_theta_to_abc (line)
	x, y = point[0], point[1]
	return np.abs(a*x + b*y + c)/np.sqrt(a**2 + b**2)

def get_line_intersection (l1, l2):
	return np.cross (l1, l2)

def draw_points_xy (image, points, color=(0, 0, 255), radius=5):
	for p in points:
		cv2.circle (image, (int(p[0]), int(p[1])), radius, color, thickness=2)
	return image

def draw_lines_rho_theta (image, lines, color=(0, 0, 255)):
	for rho, theta in lines:
		a = np.cos(theta)
		b = np.sin(theta)
		x0 = a*rho
		y0 = b*rho
		x1 = int(x0 + 1000*(-b))
		y1 = int(y0 + 1000*(a))
		x2 = int(x0 - 1000*(-b))
		y2 = int(y0 - 1000*(a))
		cv2.line(image,(x1,y1),(x2,y2),color,2)
	return image

def iter_algebraic_notations ():
	for l in an_letters:
		for n in an_numbers:
			yield (l, n)

def iter_board_vertices ():
	for i in range (9):
		for j in range (9):
			yield (i, j)
