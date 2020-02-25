class FeedBack {
  String id;
  String subject;
  bool typeOfFeedBack;
  double feedbackIntensity;
  String content;
  List imageUrls;
  String feedbackStatus;
  int createdDate;
  int updatedDate;
  String comment;

  FeedBack(
      this.subject,
      this.typeOfFeedBack,
      this.feedbackIntensity,
      this.content,
      this.imageUrls,
      this.feedbackStatus,
      this.createdDate,
      this.updatedDate);

  FeedBack.withID(
      this.id,
      this.subject,
      this.typeOfFeedBack,
      this.feedbackIntensity,
      this.content,
      this.imageUrls,
      this.feedbackStatus,
      this.createdDate,
      this.updatedDate,
      this.comment);

  FeedBack.fromMap(Map snapshot, String id)
      : this.id = id ?? '',
        this.subject = snapshot['subject'] ?? '',
        this.typeOfFeedBack = snapshot['typeOfFeedBack'] ?? '',
        this.feedbackIntensity = snapshot['feedbackIntensity'] ?? '',
        this.content = snapshot['content'] ?? '',
        this.imageUrls = snapshot['imageUrls'] ?? '',
        this.feedbackStatus = snapshot['feedbackStatus'] ?? '',
        this.comment = snapshot['comment'] ?? '',
        this.createdDate = snapshot['createdDate'],
        this.updatedDate = snapshot['updatedDate'];
}
