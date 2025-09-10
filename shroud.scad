$fs=0.5;
$fa=1;
$fn=0;

module lip(th = 2) {
  linear_extrude(5.01) polygon([
    [-th, th], [97+th, th], [97+th, -34], [97, -34], [97, 0], [0, 0], [0, -34], [-th, -34]
   ]);
}

module base(th = 2) {
  shape = [
    [-th, th], [97+th, th], [97+th, -34], [95-6.5, -34],
    [95-6.5, -23], [95-6.5-3, -20], [1+43+4+3, -20], [1+43+4, -23],
    [1+43+4, -34], [-th, -34]
  ];
  hole = [
    [1, -1], [96, -1], [96, -12], [1+43+3, -12],
    [1+43, -12-3], [1+43, -24], [1, -24]];

  difference() {
    linear_extrude(2.01) polygon(concat(shape, hole), [
      [for (i = [0:9]) i], [for (i = [10:16]) i]
    ]);
  
    translate([8, -34+4.5, -0.5]) cylinder(h = 3, r = 1.8);
    translate([8+16, -34+4.5, -0.5]) cylinder(h = 3, r = 1.8);
    translate([8+16+16, -34+4.5, -0.5]) cylinder(h = 3, r = 1.8);
    translate([95-3, -34+7, -0.5]) cylinder(h = 3, r = 1.8);
    //translate([1+43+3.5, -24, 2.01]) cube([1, 0.2, 0.1], center=true);
    //translate([1+43+3.5, -20, 2.01]) cube([1, 0.2, 0.1], center=true);
  }
}

function reverse(list) = [ for (i = [len(list)-1 : -1 : 0]) list[i] ];

// https://stackoverflow.com/a/78582473
module extrude_between(points0, points1, height, convexity=2) {
    N = len(points0);
    assert(len(points1) == N);
    bottom_pts = [for (i=[0:N-1]) [points0[i].x, points0[i].y, 0]];
    top_pts    = [for (i=[0:N-1]) [points1[i].x, points1[i].y, height]];
    bottom_face = [for (i=[0:N-1]) i];
    top_face    = [for (i=[0:N-1]) 2*N - i - 1];
    side_faces  = [for (i=[0:N-1]) let (j=(i+1)%N) [i+N, j+N, j, i]];
    polyhedron(
        [each bottom_pts, each top_pts],
        [bottom_face, each side_faces, top_face],
        convexity=convexity
    );
}

module duct1(lipth, dth = 2) {
  shape0 = [
    [-lipth, lipth],
    [97+lipth, lipth],
    [97+lipth, -12-dth],
    [1+43+3+sqrt(dth)/2, -12-dth],
    [1+43+dth, -12-3-sqrt(dth)/2],
    [1+43+dth, -26+(dth-1)],
    [-lipth, -26+(dth-1)],
  ];

  skewLeft = 1;
  skewTop = 2;
  skewRight = 3;

  shape1 = [
    [shape0[0][0]-skewLeft, shape0[0][1]+skewTop],
    [shape0[1][0]+skewRight, shape0[1][1]+skewTop],
    [shape0[2][0]+skewRight, shape0[2][1]],
    shape0[3],
    shape0[4],
    shape0[5],
    [shape0[6][0]-skewLeft, shape0[6][1]],
  ];

  hole0 = [
    [shape0[0][0]+dth, shape0[0][1]-dth],
    [shape0[1][0]-dth, shape0[1][1]-dth],
    [shape0[2][0]-dth, shape0[2][1]+dth],
    [shape0[3][0]-sqrt(dth)/2, shape0[3][1]+dth],
    [shape0[4][0]-dth, shape0[4][1]+sqrt(dth)/2],
    [shape0[5][0]-dth, shape0[5][1]+dth],
    [shape0[6][0]+dth, shape0[6][1]+dth],
  ];

  hole1 = [
    [hole0[0][0]-skewLeft, hole0[0][1]+skewTop],
    [hole0[1][0]+skewRight, hole0[1][1]+skewTop],
    [hole0[2][0]+skewRight, hole0[2][1]],
    hole0[3],
    hole0[4],
    hole0[5],
    [hole0[6][0]-skewLeft, hole0[6][1]],
  ];

    difference() {
      extrude_between(reverse(shape0), reverse(shape1), 8.01);
      translate([0, 0, -0.25]) extrude_between(reverse(hole0), reverse(hole1), 8.5);
    }
}

module duct2(lipth, dth = 2) {
  shape0 = [
    [-1-lipth, 2+lipth],
    [100+lipth, 2+lipth],
    [100+lipth, -12-dth],
    [1+43+3+sqrt(dth)/2, -12-dth],
    [1+43+dth, -12-3-sqrt(dth)/2],
    [1+43+dth, -26+(dth-1)],
    [-1-lipth, -26+(dth-1)],
  ];

  skewLeft = 1;
  skewTop = 4 + dth;
  skewRight = 3.8;
  skewBottomNarrow = 9 + dth;

  shape1 = [
    [shape0[0][0]-skewLeft, shape0[0][1]+skewTop],
    [shape0[1][0]+skewRight, shape0[1][1]+skewTop],
    [shape0[2][0]+skewRight, shape0[2][1]-skewBottomNarrow],
    [shape0[3][0]+5,shape0[3][1]-skewBottomNarrow],
    [shape0[4][0]+3,shape0[3][1]-skewBottomNarrow],
    [shape0[5][0]-5,shape0[3][1]-skewBottomNarrow],
    [shape0[6][0]-skewLeft, shape0[3][1]-skewBottomNarrow],
  ];

  hole0 = [
    [shape0[0][0]+dth, shape0[0][1]-dth],
    [shape0[1][0]-dth, shape0[1][1]-dth],
    [shape0[2][0]-dth, shape0[2][1]+dth],
    [shape0[3][0]-sqrt(dth)/2, shape0[3][1]+dth],
    [shape0[4][0]-dth, shape0[4][1]+sqrt(dth)/2],
    [shape0[5][0]-dth, shape0[5][1]+dth],
    [shape0[6][0]+dth, shape0[6][1]+dth],
  ];

  hole1 = [
    [hole0[0][0]-skewLeft, hole0[0][1]+skewTop],
    [hole0[1][0]+skewRight, hole0[1][1]+skewTop],
    [hole0[2][0]+skewRight, hole0[2][1]-skewBottomNarrow],
    [hole0[3][0]+5, hole0[3][1]-skewBottomNarrow],
    [hole0[4][0]+3, hole0[3][1]-skewBottomNarrow],
    [hole0[5][0]-5, hole0[3][1]-skewBottomNarrow],
    [hole0[6][0]-skewLeft, hole0[3][1]-skewBottomNarrow],
  ];
  echo("topleft", shape1[0]);
  echo("fanx", shape1[1][0] - shape1[0][0] - dth);
  echo("fany", hole1[1][1] - hole1[6][1]);
    difference() {
      extrude_between(reverse(shape0), reverse(shape1), 20.01);
      translate([0, 0, -0.25]) extrude_between(reverse(hole0), reverse(hole1), 20.5);
    }
}

module fanmount (dth = 2) {
  shape0 = [
    [-dth, dth],
    [107-dth, dth],
    [107-dth, 0],
    [0, 0],
    [0, -30],
    [107-dth, -30],
    [107-dth, -30-dth],
    [-dth, -30-dth]];
  translate([dth, -dth, 0]) linear_extrude(1.51) polygon(shape0);

  narrow = 2.6;

  shape1 = [
    [-dth, dth-narrow],
    [107-5, dth-narrow],
    [107-5, -narrow],
    [0, -narrow],
    [0, -30+narrow],
    [107-5, -30+narrow],
    [107-5, -30-dth+narrow],
    [-dth, -30-dth+narrow]
  ];

  translate([dth, -dth, 1.5]) extrude_between(reverse(shape0), reverse(shape1), 3.5);

  nudge = 1;

  shape2 = [
    [-dth+nudge, dth-nudge],
    [107-nudge, dth-nudge],
    [107-nudge, 0-nudge],
    [0+nudge, 0-nudge],
    [0+nudge, -30+nudge],
    [107-nudge, -30+nudge],
    [107-nudge, -30-dth+nudge],
    [-dth+nudge, -30-dth+nudge]];
  translate([dth, -dth, -1.5]) linear_extrude(1.5) polygon(shape2);
  
  
}

translate([0, 0, -5]) lip(1.4);
base(1.4);
translate([0, 0, 2]) duct1(1.4, 1.6);
translate([0, 0, 10]) duct2(1.4, 1.6);
translate([-3.4, 9, 30]) fanmount(1.6);