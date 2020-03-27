{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["${role}.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
