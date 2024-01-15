enum ThemeMode {
  light,
  dark,
}

enum UserKarma {
  comment(1),
  textPost(2),
  awardPost(5),
  deletePost(-1),
  linkPost(2),
  imagePost(2);

  final int karma;
  const UserKarma(this.karma);
}
