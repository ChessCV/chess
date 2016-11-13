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
