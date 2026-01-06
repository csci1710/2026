const d3 = require('d3')

/* This is an *OLD-STYLE* visualization that invokes D3 directly and relies on 
   JS experience from the author. We will show other, better ways of controlling 
   visualization soon, but this is what I had on hand for this specific model. :-) 
   
   Former and current 0320 students may notice that this is JavaScript, not 
   TypeScript. I do indeed dislike that this is the case... */

d3.selectAll("svg > *").remove();

function printValue(row, col, yoffset, value) {
  d3.select(svg)
    .append("text")
    .style("fill", "black")
    .attr("x", (row+1)*10)
    .attr("y", (col+1)*14 + yoffset)
    .text(value);
}

function printState(stateAtom, yoffset) {
  for (r = 0; r <= 2; r++) {
    for (c = 0; c <= 2; c++) {
      printValue(r, c, yoffset,
                 stateAtom.board[r][c]
                 .toString().substring(0,1))  
    }
  }
  
  d3.select(svg)
    .append('rect')
    .attr('x', 5)
    .attr('y', yoffset+1)
    .attr('width', 40)
    .attr('height', 50)
    .attr('stroke-width', 2)
    .attr('stroke', 'black')
    .attr('fill', 'transparent');
}

// In this raw, JavaScript vis format, Sterling provides the current instance via 
// a number of bound variables, which you can access like this:
var offset = 0
for(b = 0; b <= 10; b++) {  
  if(Board.atom("Board"+b) != null)
    printState(Board.atom("Board"+b), offset)  
  offset = offset + 55
}