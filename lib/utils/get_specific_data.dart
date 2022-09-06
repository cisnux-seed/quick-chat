String getSpecificData(List<String> strings, String specificData) {
  return strings
      .where(
        (username) => username != specificData,
      )
      .first;
}
