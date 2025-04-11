class board_item {
  int boardId;
  int userId;
  int boardType;
  String title;
  String content;
  int localSi;
  int localGu;
  String regDate;
  String? nickname; // 클릭 횟수 이벤트

  board_item({
    required this.boardId,
    required this.userId,
    required this.boardType,
    required this.title,
    required this.content,
    required this.localSi,
    required this.localGu,
    required this.regDate,
    this.nickname,
  });

  // JSON 데이터를 ContactVo 객체로 변환
  factory board_item.fromJson(Map<String, dynamic> apiData) {
    return board_item(
      boardId: apiData['boardId'],
      userId: apiData['userId'],
      boardType: apiData['boardType'],
      title: apiData['title'],
      content: apiData['content'],
      localSi: apiData['localSi'],
      localGu: apiData['localGu'],
      regDate: apiData['regDate'], // 추가
      nickname: apiData['nickname'],
    );
  }

  // ContactVo 객체를 JSON(Map)으로 변환
  Map<String, dynamic> toJson() {
    return {
      'boardId': boardId,
      'userId': userId,
      'boardType': boardType,
      'title': title,
      'content': content,
      'localSi': localSi,
      'localGu': localGu,
      'regDate': regDate,
      if (nickname != null) 'nickname': nickname, // null이면 생략
    };
  }

  @override
  String toString() {
    return 'BoardItem(boardId: $boardId, userId: $userId, nickname: $nickname)';
  }
}
