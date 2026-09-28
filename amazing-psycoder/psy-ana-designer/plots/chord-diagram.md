# Chord Diagram

## Overview

Chord diagram shows the flow and relationships between nodes. Outer ring = node, inner chord = flow direction, chord width = flow size.

## When to use

| Condition | Description |
|------|------|
| Scenario | Flow/transformation relationship between groups |
| data | square matrix (traffic from → to) |

## R code

```r
library(circlize)
chordDiagram(mat, transparency=0.5,
             annotationTrack="grid",
             preAllocateTracks=list(track.height=0.1))
circos.track(track.index=1, panel.fun=function(x,y) {
  circos.text(CELL_META$xcenter, CELL_META$ylim[1],
              CELL_META$sector.index, facing="clockwise",
              adj=c(-0.1,0.5), cex=0.8)
}, bg.border=NA)
```

## vs Network Map vs Sankey

- Chord diagram = circular flow diagram, suitable for square matrix data
- Network graph = node + edge, suitable for undirected relationships
- Sankey (alluvial map) = linear flow direction, suitable for stage conversion

## Key parameters

| Parameters | Function |
|------|------|
| `transparency` | String transparency (0-1) |
| `annotationTrack` | Outer ring label style |
| `grid.col` | Sector color |
