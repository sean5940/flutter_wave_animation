import 'dart:typed_data';

void injectVertex(
    int i, Float32List list, double l, double t, double r, double b) {
  i *= 12;

  // Injects position(x,y) of two triangles.

  // left triangle:
  list[i + 0] = l; // x1
  list[i + 1] = t; // y1
  list[i + 2] = r; // x2
  list[i + 3] = t; // y1
  list[i + 4] = l; // x1
  list[i + 5] = b; // y2

  // right triangle:
  list[i + 6] = r; // x2
  list[i + 7] = t; // y1
  list[i + 8] = r; // x2
  list[i + 9] = b; // y2
  list[i + 10] = l; // x1
  list[i + 11] = b; // y2
}

void injectColor(int i, Int32List list, int color) {
  i *= 6;
  // Injects color values for two triangles
  list[i + 0] = list[i + 1] =
      list[i + 2] = list[i + 3] = list[i + 4] = list[i + 5] = color;
}
