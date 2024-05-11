List<bool> dilation(List<bool> mask, int height, int width) {

List<bool> postprocessedMask =
      List.generate(height * width, (_) => false);

  for (int i = 0; i < height; i++) {
    for (int j = 0; j < width; j++) {
      int idx = i * width + j;
      if (mask[idx]) {
        for (int k = i - 1; k <= i + 1; k++) {
          for (int l = j - 1; l <= j + 1; l++) {
            int neighborIdx = k * width + l;
            if (k >= 0 && k < height && l >= 0 && l < width && !postprocessedMask[neighborIdx]) {
              postprocessedMask[neighborIdx] = true;
            }
          }
        }
      }
    }
  }

  return postprocessedMask;
}

List<bool> erosion(List<bool> mask, int height, int width) {


  List<bool> postprocessedMask =
      List.generate(height * width, (_) => false);

    for (int i = 0; i < height; i++) {
    for (int j = 0; j < width; j++) {
      int idx = i * width + j;
      if (mask[idx]) {
        bool deletePixel = false;
        for (int k = i - 1; k <= i + 1; k++) {
          for (int l = j - 1; l <= j + 1; l++) {
            int neighborIdx = k * width + l;
            if (k >= 0 && k < height && l >= 0 && l < width && !mask[neighborIdx]) {
              deletePixel = true;
              break;
            }
          }
          if (deletePixel) {
            break;
          }
        }
        if (!deletePixel) {
          postprocessedMask[idx] = true;
        }
      }
    }
  }

  return postprocessedMask;
}