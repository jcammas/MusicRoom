String formatSearchParam(String str) {
  str = str.toLowerCase();
  str = str.replaceAll(new RegExp(r'[^a-zA-Z]+'), '');
  return str;
}
