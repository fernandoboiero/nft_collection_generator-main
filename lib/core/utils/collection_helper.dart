import 'dart:math';

import 'package:nft_generator/features/collection_generator/domain/entities/collection_layer.dart';

class CollectionHelper {
  final List<CollectionLayer> layers;
  final CollectionLayer? rareLayer;
  List<List<int>> _indexedLayers = [];
  List<List<int>> mixedLayers = [];

  CollectionHelper(this.layers, {this.rareLayer});

  /// Calculate the possible matches
  ///     n         n!
  ///   C   = -------------
  ///     k    (n-k)! * k!
  double get getAllPossibleCombinationsCount {
    if (layersCount == 0) return 0;
    var n = imagesCount;
    var k = layersCount;

    var factorialN = factorial(n);
    var factorialNK = factorial(n - k);
    var factorialK = factorial(k);
    return factorialN / (factorialNK * factorialK);
  }

  /// Return the sum of layers
  int get layersCount => layers.length;

  /// Return the sum of images in all layers.
  int get imagesCount {
    var n = 0;
    for (var value in layers) {
      n += value.images.length;
    }
    return n;
  }

  get generateVariants {
    layers.removeWhere((value) => value == rareLayer);
    for (var value in layers) {
      List<int> mimg = [];
      for (var i = 0; i < value.images.length; i++) {
        mimg.add(i);
      }
      _indexedLayers.add(mimg);
    }
    mixedLayers = combinations<int>(_indexedLayers).toList();
    return mixedLayers;
  }

  get addRareLayer {
    List<int> mimg = [];
    for (var i = 0; i < rareLayer!.images.length; i++) {
      mimg.add(i);
    }
    mixedLayers.add(mimg);
    return mixedLayers;
  }

  int factorial(int value) {
    var factorial = 1;
    for (int i = 1; i <= value; i++) {
      factorial = factorial * i;
    }
    return factorial;
  }

  Iterable<List<T>> combinations<T>(List<List<T>> lists,
      [int index = 0, List<T>? prefix]) sync* {
    prefix ??= <T>[];

    if (lists.length == index) {
      yield prefix.toList();
    } else {
      for (final value in lists[index]) {
        yield* combinations(lists, index + 1, prefix..add(value));
        prefix.removeLast();
      }
    }
  }
}
