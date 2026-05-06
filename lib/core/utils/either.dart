class Either<L, R> {
  final L? _left;
  final R? _right;
  final bool _isRight;

  const Either._left(L value)
      : _left = value,
        _right = null,
        _isRight = false;

  const Either._right(R value)
      : _left = null,
        _right = value,
        _isRight = true;

  bool get isRight => _isRight;
  bool get isLeft => !_isRight;

  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    if (_isRight) {
      return onRight(_right as R);
    } else {
      return onLeft(_left as L);
    }
  }

  L get left => _left as L;
  R get right => _right as R;
}

Either<L, R> left<L, R>(L value) => Either._left(value);
Either<L, R> right<L, R>(R value) => Either._right(value);

typedef EitherFailure<R> = Either<dynamic, R>;
