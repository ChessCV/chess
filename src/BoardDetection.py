import os
from subprocess import call
from copy import deepcopy
import cv2
import numpy as np
from numpy import matrix, concatenate
from numpy.linalg import inv, svd
import util

# BoardDetection.py
# Author: Tyler Zeller
MATLAB_PATH = ""

def get_harris_corners (image):
	corner_detector = cv2.FeatureDetector_create('HARRIS')
	return corner_detector.detect(image)

def get_harris_points(harris_corners):
	return [corner.pt for corner in harris_corners]


def get_sift_descriptors(image, points):
	sift_descriptor = cv2.DescriptorExtractor_create('SIFT')
	return sift_descriptor.compute (image, points)[1]

def get_P_rows (bp, ip):
	u, v = ip[0], ip[1]
	x, y, z = bp[0], bp[1], 1
	return matrix 	([
						[x, y, z, 0, 0, 0, -u*x, -u*y, -u],
						[0, 0, 0, x, y, z, -v*x, -v*y, -v],

					])

def get_P (board_points, image_points):
	return concatenate ([get_P_rows (bp, ip) for bp, ip in zip(board_points, image_points)], 0)

def assemble_BIH (V):
	vt = V.T[:, -1]
	return concatenate ([vt[0:3].T, vt[3:6].T, vt[6:9].T], 0);

def point_correspondences_to_BIH (board_points, image_points):
	assert (len (board_points) == len (image_points)) and (len(board_points) >= 4)
	P = get_P (board_points, image_points)
	U, S, V = svd (P)
	BIH = assemble_BIH (V)
	return BIH

def cluster_points (points, cluster_dist=7):
	old_points = np.array (points)
	new_points = []

	while len(old_points) > 1:
		p1 = old_points [0]
		distances = np.array([util.euclidean_distance (p1, p2) for p2 in old_points])
		idx = (distances < cluster_dist)
		points_cluster = old_points[idx]
		centroid = util.get_centroid(points_cluster)
		new_points.append (centroid)
		old_points = old_points[np.invert(idx)]

	return new_points

def get_chessboard_corners (image, corner_classifier):
	harris_corners = get_harris_corners (image)
	sift_descriptors = get_sift_descriptors(image, harris_corners)
	harris_points= get_harris_points(harris_corners)

	predictions = corner_classifier.predict(sift_descriptors)
	idx = (predictions == 1)
	chessboard_corners = [c for c, i in zip(harris_points, idx) if i]

	chessboard_corners = cluster_points (chessboard_corners)
	return chessboard_corners

def get_chessboard_lines (image, corners, search_for_theta):
	global MATLAB_PATH
	corners_img = np.zeros (image.shape[:2], dtype=np.uint8)
	for corner in corners:
		corners_img[int(corner[1])][int(corner[0])] = 255

	cv2.imwrite ('./IPC/corners.png', corners_img)

	os.chdir ('./autofind_lines')

	if os.name == 'posix':
		path = '/Applications/MATLAB_R2016a.app/bin/matlab'
	elif os.name == 'nt':
		path = 'C:/Program Files/MATLAB/R2016a/bin/win64/matlab.exe'

	if search_for_theta:
		file_to_run = 'autofind_lines_search'
	else:
		file_to_run = 'autofind_lines'
	call([path, "-nojvm", "-nodisplay", "-nosplash", "-r ", file_to_run])
	os.chdir ('../')

	horz_lines_indexed = np.genfromtxt ('./IPC/horizontal_lines.csv', delimiter=',')
	vert_lines_indexed = np.genfromtxt ('./IPC/vertical_lines.csv', delimiter=',')
	horz_lines = zip(list(horz_lines_indexed[0, :]), list(horz_lines_indexed[1, :]))
	vert_lines = zip(list(vert_lines_indexed[0, :]), list(vert_lines_indexed[1, :]))
	horz_indices = horz_lines_indexed[2, :]
	vert_indices = vert_lines_indexed[2, :]
	return horz_lines, horz_indices, vert_lines, vert_indices


def snap_points_to_lines (lines, points, max_distance=5):
	grid = [[] for line in lines]

	for point in points:
		distances = np.array([util.get_line_point_distance (line, point) for line in lines])
		if np.min (distances) < max_distance:
			line_index = np.argmin(distances)
			grid[line_index].append (point)

	for i in range(len(grid)):
		grid[i].sort (key=lambda x: x[0])

	return grid

def is_BIH_inlier (all_BIH_ip, corner, pix_dist=5):
	return any([(util.euclidean_distance(ip, corner) <= pix_dist) for ip in all_BIH_ip])

def compute_inliers (BIH, corners):
	all_board_points = []
	for i, j in util.iter_board_vertices():
		all_board_points.append((i, j))

	all_BIH_ip = [util.board_to_image_coords (BIH, bp) for bp in all_board_points]
	num_inliers = sum ([is_BIH_inlier (all_BIH_ip, corner) for corner in corners])
	return num_inliers

def evaluate_homography (horz_indices, vert_indices, horz_points_grid, vert_points_grid, corners):
	board_points, image_points = [], []

	for i in range (len(horz_points_grid)):
		for j in range(len(vert_points_grid)):

			board_x = horz_indices[i]
			board_y = vert_indices[j]
			intersection = list(set(horz_points_grid[i]).intersection (set(vert_points_grid[j])))
			if len(intersection) > 0:
				image_points.append (intersection[0])
				board_points.append ((board_x, board_y))

	BIH = point_correspondences_to_BIH (board_points, image_points)
	score = compute_inliers (BIH, corners)
	return BIH, score

def get_BIH_from_lines (corners, horz_lines, horz_ix, vert_lines, vert_ix):
	for vl_chunk, vi_chunk in zip(chunks(vert_lines, 5), chunks(vert_ix, 5)):

		horz_points_grid = snap_points_to_lines (horz_lines, corners)
		vert_points_grid = snap_points_to_lines (vl_chunk, corners)

		horz_ix = horz_ix - horz_ix[0]
		vi_chunk = vi_chunk - vi_chunk[0]

		horiz_indices = deepcopy(horz_ix)
		best_BIH = np.zeros ((3,3))
		best_score = -1
		while (horiz_indices[-1] < 9):

			vert_indices = deepcopy (vi_chunk)
			while (vert_indices[-1] < 9):

				BIH, score = evaluate_homography (horiz_indices, vert_indices, horz_points_grid, vert_points_grid, corners)
				if score > best_score:
					best_score = score
					best_BIH = BIH

				vert_indices += 1
			horiz_indices += 1

	return best_BIH

def chunks(l, n):
    for i in xrange(0, len(l), n):
        yield l[i:i + n]

def find_board_image_homography (image, corner_classifier, search_for_theta):
	corners = get_chessboard_corners (image, corner_classifier)

	# Print corners image
	corners_img = util.draw_points_xy (deepcopy(image), corners)
	cv2.namedWindow ('PREDICTED CORNERS')
	cv2.imshow ('corners', corners_img)
	cv2.imwrite ('../data/toy_images/corners.png', corners_img)
	key = 0
	while key != ord('q'):
		key = cv2.waitKey (30)

	horz_lines, horz_ix, vert_lines, vert_ix = get_chessboard_lines (image, corners, search_for_theta)

	# Print hough image
	hough = deepcopy(image)
	hough = util.draw_lines_rho_theta (hough, horz_lines)

	count = 0
	for vl_chunk in chunks(vert_lines, 5):
		hough_img = util.draw_lines_rho_theta (deepcopy(hough), vl_chunk)
		cv2.imshow ('hough lines', hough_img)
		cv2.imwrite ('../data/toy_images/hough'+str(count)+'.png', hough_img)
		key = 0
		while key != ord('q'):
			key = cv2.waitKey (30)
		count += 1

	BIH = get_BIH_from_lines (corners, horz_lines, horz_ix, vert_lines, vert_ix)
	return BIH
