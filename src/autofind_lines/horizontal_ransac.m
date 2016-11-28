function indexed_lines = horizontal_ransac (lines, image_width)
% Function: horizontal_ransac
% ---------------------------
% lines: 2xN vector, with ith col = [rho; theta] of the ith line
% returns:
%	- indexed_lines: 3xN vector, where 3rd column is index; (up to a shift)
%	- p: regresses from line index to where it should be.
% 	(returns them from bottom to top)

	%=====[ Step 1: figure out how many lines we can get	]=====
	num_lines = size(lines, 2);
	if num_lines > 5
		num_lines = 5;
	else
		num_lines = 4;
	end
	num_lines = 5;		% NOTE: change this!!! only works for game 1...


	%=====[ Step 1: preprocess lines ]=====
% 	sorted_lines = sort(lines, 2);
% 	sorted_lines = sorted_lines (:, 1:num_lines);
% 	y = log(abs(sorted_lines(1, :)));
	%y = y(1:num_lines);
    
    lines_rt = [lines; get_x_intercepts(lines, image_width)]; 	% add x intercepts
	[Y, sort_permutation] = sort (lines_rt, 2, 'descend');	% sort by x intercepts
	sort_permutation = sort_permutation(3, :);	%stores the permutation for sorting thetas
	sorted_lines = lines_rt;
	sorted_lines(1, :) = lines_rt(1, sort_permutation);
	sorted_lines(2, :) = lines_rt(2, sort_permutation);
	sorted_lines(3, :) = lines_rt(3, sort_permutation);
	y = sorted_lines(3, :);

	%=====[ Step 2: initialize parameters for RANSAC ]=====
	indices = combnk(1:9, num_lines);
	num_iters = size(indices, 1);
	best_Rsq = -1;
	best_p = 0;
	best_indices = [0, 0, 0, 0, 0];

	%=====[ RANSAC ITERATIONS	]=====
	for k = 1:num_iters

		%=====[ Step 3: get a random assignment to indices	]=====
		X = indices (k, :);

		%=====[ Step 4: run linear regression	]=====
		p = polyfit (X, y, 2);

		%=====[ Step 5: calculate Rsq	]=====
		yfit = polyval (p, X);
		yresid = y - yfit;
		SSresid = sum (yresid .^ 2);
		SStotal = (length(y) - 1) * var(y);
		Rsq = 1 - (SSresid/SStotal);

		%=====[ Step 6: update Rsq	]=====
		if Rsq > best_Rsq
			best_Rsq = Rsq;
			best_p = p;
			best_indices = X;
		end
	end

	%=====[ Step 7: construct indexed_lines	]=====
	indexed_lines = vertcat(sorted_lines(1:2, :), best_indices);
