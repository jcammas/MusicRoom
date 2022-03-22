String formatSearchParam(String str) {
  str = str.toLowerCase();
  str = str.replaceAll(new RegExp(r'[^a-zA-Z]+'), '');
  return str;
}

List<String> setSearchParams(String str) {
  List<String> searchParams = [];
  String temp = "";

  str = str.toLowerCase();
  str = str.replaceAll(new RegExp(r'[^a-zA-Z]+'), '');
  for (int i = 0; i < str.length; i++) {
    temp = temp + str[i];
    searchParams.add(temp);
  }
  return searchParams;
}
