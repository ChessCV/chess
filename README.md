# Chess
Chess Computer Vision project for OSU CSE 5524

## Discription
### Project idea:
- Chess Checker – Detect a chess board, match pieces from an arbitrary board state. Continue from that state to detect moves with will be validated by an OSS chess engine.

### Where you will get the data:
- Data will come from:
  - Chess.com
  - An overhead mounted camera above an irl chess board

### What will you code/develop
- Computer board (AI Computer Chess)
  - [ ] P1 – Board detection of chess.com game (template matching)
  - [ ] P2 – Tracking piece movements (color histogram before and after each move is performed)
  - [ ] P3 – Classify arbitrary board positions based on piece look (template matching of pieces)
  - [ ] P4 – Hover mouse over piece and highlight possible movement squares (motion tracking, region segmentation)

- IRL board (Move detection btw two humans, camera at slight angle to game)
  - [ ] P1 – Board detection of physical game (Harris detector for points of interest, Hough transforms to solve for grid lines) 
  - [ ] P2 – Tracking piece movements
    - Mean shift tracking to determine where pieces are and where they've ended up.
  - [ ] P3 – Classify arbitrary board positions based on piece look (template matching)
  - [ ] P4 – Touch piece and have a display show where it can move (motion tracking, region segmentation)

- Parts All
  - [ ] Connect to chess engine for move validation.
  - [ ] Pieces movement heat map

### How will you evaluate:
- Demo of playing a match from arbitrary board state with the move validity checking
- Images of motion tracked game

## Run
Simply run `python2 test.py` (`test.py` is found in `src/`)

## Install
*Note*: If on **Windows** use *32bit* python2.7 as it might releviate some issues and replace `pip install` below with `python2 -m pip install` :/

1. Install `python2.7` from [Python.org](https://www.python.org/).
2. Upgrade pip: `pip install --upgrade pip`.
3. Install python packages: `pip install -r requirements.txt`
  - If having trouble with Windows install from [these Windows binaries](http://www.lfd.uci.edu/~gohlke/pythonlibs/#scipy)
4. Install opencv3
  - Windows: [install instructions](http://docs.opencv.org/3.1.0/d5/de5/tutorial_py_setup_in_windows.html)
  - Mac: [install instructions](http://www.mobileway.net/2015/02/14/install-opencv-for-python-on-mac-os-x/)
5. Setup command line Matlab:
  - Windows: Add the Matlab folder containing the executable to your path (Something like `C:/Program Files/MATLAB/R2016a/bin/win64/`)
  - Mac: We hard coded Matlab to this location `/Applications/MATLAB_R2016a.app/bin/matlab` change in `CVAnalysis.py` (Although the path thing should work as well)

## Troubleshooting
### Run Matlab locally

- Run the `test.m` file in the current directory `matlab -nodesktop -nosplash -r test`
- Run some Matlab code `matlab -nodesktop -nosplash -r 'disp(5);pause;'` >> It displays the number `5` and waits for an `enter` 
